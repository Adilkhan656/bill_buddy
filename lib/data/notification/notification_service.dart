import 'dart:math';
import 'dart:ui';
import 'package:bill_buddy/data/local/database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:drift/drift.dart' as drift;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // 🏁 1. INITIALIZE SERVICE
  Future<void> init() async {
    tz.initializeTimeZones();

    // Android Settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher'); // Ensure app icon exists here

    // iOS Settings
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    
    // Request Permission (Android 13+)
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  // 🚨 2. BUDGET ALERT (Call this after adding an expense)
  Future<void> checkBudgetAndNotify(AppDatabase db) async {
    final budgets = await db.watchAllBudgets().first;
    final expenses = await db.watchAllExpenses().first;
    final now = DateTime.now();

    for (var budget in budgets) {
      // Calculate spend for this month
      final spent = expenses
          .where((e) =>
              e.category == budget.category &&
              e.date.month == now.month &&
              e.date.year == now.year)
          .fold(0.0, (sum, item) => sum + item.amount);

      // Trigger Notification if 100% exceeded
      if (spent >= budget.limit) {
        await _showNotification(
          id: budget.id, // Unique ID per category
          title: "🚨 Budget Alert: ${budget.category}",
          body: "You've exceeded your limit! Spent: ${spent.toStringAsFixed(0)} / ${budget.limit.toStringAsFixed(0)}",
        );
      }
    }
  }

  // ☀️ 3. SCHEDULE MORNING MOTIVATION (7:00 AM)
  Future<void> scheduleMorningMotivation() async {
    // Random Tips List
    final List<String> tips = [
      "💰 Tip: Track every penny to save many.",
      "📉 Saving is not a sacrifice, it’s a strategy.",
      "☕ Skip the expensive coffee today and save ₹200!",
      "🎯 Stay focused on your budget goals today.",
      "🚫 Impulse buying is the enemy of wealth.",
      "💡 Review your subscriptions. Do you need them all?",
    ];

    final randomTip = tips[Random().nextInt(tips.length)];

    // Schedule for 7:00 AM Tomorrow
    var scheduledDate = _nextInstanceOf7AM();

    // Loop to schedule for the next 5 "Alternate Days" (Day 1, 3, 5, etc.)
    for (int i = 0; i < 5; i++) {
        // Add 2 days for "alternate" schedule
        final notificationDate = scheduledDate.add(Duration(days: i * 2));
        
        await flutterLocalNotificationsPlugin.zonedSchedule(
          100 + i, // Unique IDs (100, 101, 102...)
          'Morning Money Tip ☀️',
          randomTip,
          notificationDate,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'motivation_channel',
              'Motivation & Tips',
              channelDescription: 'Daily financial advice',
              importance: Importance.low, // Low importance for morning tips (won't pop up aggressively)
              priority: Priority.low,
            ),
          ),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time, // Matches time
        );
    }
  }

  // Helper: Get next 7 AM
  tz.TZDateTime _nextInstanceOf7AM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, 7); // 7:00 AM
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
Future<void> testNotification() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      999, // Unique ID for testing
      'Test Motivation 🚀',
      'This is how your morning tip will look!',
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)), // 5 seconds from now
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'motivation_channel',
          'Motivation & Tips',
          channelDescription: 'Daily financial advice',
          importance: Importance.max,
          priority: Priority.high,
          color: Color(0xFF0F766E),
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
  // Helper: Show Immediate Notification
  Future<void> _showNotification({required int id, required String title, required String body}) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'budget_alerts',
      'Budget Alerts',
      channelDescription: 'Notifications for exceeded budgets',
      importance: Importance.max,
      priority: Priority.high,
      color:  const Color(0xFFFF5252), // Red Color
    );

    const NotificationDetails details = NotificationDetails(android: androidDetails);
    await flutterLocalNotificationsPlugin.show(id, title, body, details);
  }
}