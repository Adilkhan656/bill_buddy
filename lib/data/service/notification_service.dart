// // import 'dart:math';
// // import 'dart:ui';
// // import 'package:bill_buddy/data/local/database.dart';
// // import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// // import 'package:timezone/data/latest_all.dart' as tz;
// // import 'package:timezone/timezone.dart' as tz;
// // import 'package:drift/drift.dart' as drift;

// // class NotificationService {
// //   static final NotificationService _instance = NotificationService._internal();
// //   factory NotificationService() => _instance;
// //   NotificationService._internal();

// //   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

// //   // 🏁 1. INITIALIZE SERVICE
// //   Future<void> init() async {
// //     tz.initializeTimeZones();

// //     // Android Settings
// //     const AndroidInitializationSettings initializationSettingsAndroid =
// //         AndroidInitializationSettings('@mipmap/ic_launcher'); // Ensure app icon exists here

// //     // iOS Settings
// //     const DarwinInitializationSettings initializationSettingsDarwin =
// //         DarwinInitializationSettings(
// //       requestSoundPermission: true,
// //       requestBadgePermission: true,
// //       requestAlertPermission: true,
// //     );

// //     const InitializationSettings initializationSettings = InitializationSettings(
// //       android: initializationSettingsAndroid,
// //       iOS: initializationSettingsDarwin,
// //     );

// //     await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    
// //     // Request Permission (Android 13+)
// //     await flutterLocalNotificationsPlugin
// //         .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
// //         ?.requestNotificationsPermission();
// //   }

// //   // 🚨 2. BUDGET ALERT (Call this after adding an expense)
// //   Future<void> checkBudgetAndNotify(AppDatabase db) async {
// //     final budgets = await db.watchAllBudgets().first;
// //     final expenses = await db.watchAllExpenses().first;
// //     final now = DateTime.now();

// //     for (var budget in budgets) {
// //       // Calculate spend for this month
// //       final spent = expenses
// //           .where((e) =>
// //               e.category == budget.category &&
// //               e.date.month == now.month &&
// //               e.date.year == now.year)
// //           .fold(0.0, (sum, item) => sum + item.amount);

// //       // Trigger Notification if 100% exceeded
// //       if (spent >= budget.limit) {
// //         await _showNotification(
// //           id: budget.id, // Unique ID per category
// //           title: "🚨 Budget Alert: ${budget.category}",
// //           body: "You've exceeded your limit! Spent: ${spent.toStringAsFixed(0)} / ${budget.limit.toStringAsFixed(0)}",
// //         );
// //       }
// //     }
// //   }

// //   // ☀️ 3. SCHEDULE MORNING MOTIVATION (7:00 AM)
// //   Future<void> scheduleMorningMotivation() async {
// //     // Random Tips List
// //     final List<String> tips = [
// //       "💰 Tip: Track every penny to save many.",
// //       "📉 Saving is not a sacrifice, it’s a strategy.",
// //       "☕ Skip the expensive coffee today and save ₹200!",
// //       "🎯 Stay focused on your budget goals today.",
// //       "🚫 Impulse buying is the enemy of wealth.",
// //       "💡 Review your subscriptions. Do you need them all?",
// //     ];

// //     final randomTip = tips[Random().nextInt(tips.length)];

// //     // Schedule for 7:00 AM Tomorrow
// //     var scheduledDate = _nextInstanceOf7AM();

// //     // Loop to schedule for the next 5 "Alternate Days" (Day 1, 3, 5, etc.)
// //     for (int i = 0; i < 5; i++) {
// //         // Add 2 days for "alternate" schedule
// //         final notificationDate = scheduledDate.add(Duration(days: i * 2));
        
// //         await flutterLocalNotificationsPlugin.zonedSchedule(
// //           100 + i, // Unique IDs (100, 101, 102...)
// //           'Morning Money Tip ☀️',
// //           randomTip,
// //           notificationDate,
// //           const NotificationDetails(
// //             android: AndroidNotificationDetails(
// //               'motivation_channel',
// //               'Motivation & Tips',
// //               channelDescription: 'Daily financial advice',
// //               importance: Importance.low, // Low importance for morning tips (won't pop up aggressively)
// //               priority: Priority.low,
// //             ),
// //           ),
// //           androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
// //           // androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
// //           uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
// //           matchDateTimeComponents: DateTimeComponents.time, // Matches time
// //         );
// //     }
// //   }

// //   // Helper: Get next 7 AM
// //   tz.TZDateTime _nextInstanceOf7AM() {
// //     final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
// //     tz.TZDateTime scheduledDate =
// //         tz.TZDateTime(tz.local, now.year, now.month, now.day, 7); // 7:00 AM
// //     if (scheduledDate.isBefore(now)) {
// //       scheduledDate = scheduledDate.add(const Duration(days: 1));
// //     }
// //     return scheduledDate;
// //   }
// // Future<void> testNotification() async {
// //     await flutterLocalNotificationsPlugin.zonedSchedule(
// //       999, // Unique ID for testing
// //       'Test Motivation 🚀',
// //       'This is how your morning tip will look!',
// //       tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)), // 5 seconds from now
// //       const NotificationDetails(
// //         android: AndroidNotificationDetails(
// //           'motivation_channel',
// //           'Motivation & Tips',
// //           channelDescription: 'Daily financial advice',
// //           importance: Importance.max,
// //           priority: Priority.high,
// //           color: Color(0xFF0F766E),
// //         ),
// //       ),
// //       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
// //       uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
// //     );
// //   }
// //   // Helper: Show Immediate Notification
// //   Future<void> _showNotification({required int id, required String title, required String body}) async {
// //     const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
// //       'budget_alerts',
// //       'Budget Alerts',
// //       channelDescription: 'Notifications for exceeded budgets',
// //       importance: Importance.max,
// //       priority: Priority.high,
// //       color:  const Color(0xFFFF5252), // Red Color
// //     );

// //     const NotificationDetails details = NotificationDetails(android: androidDetails);
// //     await flutterLocalNotificationsPlugin.show(id, title, body, details);
// //   }
// // }

// import 'dart:math';
// import 'dart:ui';
// import 'package:bill_buddy/data/local/database.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

// class NotificationService {
//   static final NotificationService _instance = NotificationService._internal();
//   factory NotificationService() => _instance;
//   NotificationService._internal();

//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

//   // 🏁 1. INITIALIZE SERVICE
//   Future<void> init() async {
//     tz.initializeTimeZones();

//     // Android Settings: Use standard app icon
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('notification_icon'); 

//     // iOS Settings
//     const DarwinInitializationSettings initializationSettingsDarwin =
//         DarwinInitializationSettings(
//       requestSoundPermission: true,
//       requestBadgePermission: true,
//       requestAlertPermission: true,
//     );

//     const InitializationSettings initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsDarwin,
//     );

//     // Initialize Plugin
//     await flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: (details) {
//         debugPrint("🔔 Notification Clicked: ${details.payload}");
//       },
//     );

//     // ✅ FIX: EXPLICITLY CREATE CHANNELS (Required for Android 8+)
//     final androidImplementation = flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

//     if (androidImplementation != null) {
//       // Channel 1: Motivation
//       await androidImplementation.createNotificationChannel(const AndroidNotificationChannel(
//         'motivation_channel', 
//         'Motivation & Tips',
//         description: 'Daily financial advice',
//         importance: Importance.low, 
//       ));

//       // Channel 2: Budget Alerts
//       await androidImplementation.createNotificationChannel(const AndroidNotificationChannel(
//         'budget_alerts', 
//         'Budget Alerts',
//         description: 'Notifications for exceeded budgets',
//         importance: Importance.high, 
//         playSound: true,
//       ));

//       // Request Permission (Android 13+)
//       await androidImplementation.requestNotificationsPermission();
//     }
//   }

//   // 🛠️ TEST FUNCTION (Instant - No Scheduler)
//   Future<void> testNotification() async {
//     debugPrint("🔔 Triggering Test Notification...");
//     const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//       'motivation_channel', 
//       'Motivation & Tips',
//       importance: Importance.max,
//       priority: Priority.high,
//       color: Color(0xFF0F766E),
//     );

//     const NotificationDetails details = NotificationDetails(android: androidDetails);
    
//     // Uses .show() instead of .zonedSchedule() to verify display logic first
//     await flutterLocalNotificationsPlugin.show(
//       888, 
//       'Test Notification 🔔', 
//       'If you see this, notifications are working!', 
//       details,
//     );
//   }

//   // 🚨 BUDGET ALERT
//   Future<void> checkBudgetAndNotify(AppDatabase db) async {
//     final budgets = await db.watchAllBudgets().first;
//     final expenses = await db.watchAllExpenses().first;
//     final now = DateTime.now();

//     for (var budget in budgets) {
//       final spent = expenses
//           .where((e) => e.category == budget.category && e.date.month == now.month && e.date.year == now.year)
//           .fold(0.0, (sum, item) => sum + item.amount);

//       if (spent >= budget.limit) {
//         await flutterLocalNotificationsPlugin.show(
//           budget.id, 
//           "🚨 Budget Alert: ${budget.category}",
//           "Limit reached! Spent: ${spent.toStringAsFixed(0)} / ${budget.limit.toStringAsFixed(0)}",
//           const NotificationDetails(
//             android: AndroidNotificationDetails(
//               'budget_alerts', 
//               'Budget Alerts',
//               importance: Importance.max,
//               priority: Priority.high,
//               color: Color(0xFFFF5252),
//             ),
//           ),
//         );
//       }
//     }
//   }

//   // ☀️ MORNING MOTIVATION
//   Future<void> scheduleMorningMotivation() async {
//     final List<String> tips = [
//       "💰 Tip: Track every penny to save many.",
//       "📉 Saving is not a sacrifice, it’s a strategy.",
//       "☕ Skip the expensive coffee today!",
//       "🎯 Stay focused on your budget goals.",
//     ];
//     final randomTip = tips[Random().nextInt(tips.length)];

//     // Schedule for 7:00 AM Tomorrow
//     var scheduledDate = _nextInstanceOf7AM();

//     // Schedule 1 notification (Keep it simple to start)
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       101,
//       'Morning Money Tip ☀️',
//       randomTip,
//       scheduledDate,
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'motivation_channel',
//           'Motivation & Tips',
//           importance: Importance.defaultImportance,
//           priority: Priority.defaultPriority,
//         ),
//       ),
//       // ✅ FIX: Use inexact to avoid permission crash on Android 12+
//       androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
//       uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
//       matchDateTimeComponents: DateTimeComponents.time, 
//     );
//   }

//   tz.TZDateTime _nextInstanceOf7AM() {
//     final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
//     tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, 7);
//     if (scheduledDate.isBefore(now)) {
//       scheduledDate = scheduledDate.add(const Duration(days: 1));
//     }
//     return scheduledDate;
//   }
// }

import 'dart:math';
import 'dart:ui';
import 'package:bill_buddy/data/local/database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // 🏁 1. INITIALIZE SERVICE
  Future<void> init() async {
    tz.initializeTimeZones();
    // Set the local location (Important for correct times)
    // You can hardcode this or use a package to detect it. 
    // For now, we rely on the device's local time.
    // tz.setLocalLocation(tz.getLocation('Asia/Kolkata')); 

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('notification_icon'); 

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

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        debugPrint("🔔 Notification Clicked: ${details.payload}");
      },
    );

    // Create Channels
    final androidImplementation = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      await androidImplementation.createNotificationChannel(const AndroidNotificationChannel(
        'daily_reminders', 
        'Daily Reminders',
        description: 'Reminders to track expenses',
        importance: Importance.defaultImportance, 
      ));

      await androidImplementation.createNotificationChannel(const AndroidNotificationChannel(
        'budget_alerts', 
        'Budget Alerts',
        description: 'Notifications for exceeded budgets',
        importance: Importance.high, 
        playSound: true,
      ));

      await androidImplementation.requestNotificationsPermission();
    }
  }

  // 🛠️ TEST NOTIFICATION
  Future<void> testNotification() async {
    await flutterLocalNotificationsPlugin.show(
      888, 
      'Test Notification 🔔', 
      'Notifications are working correctly!', 
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminders', 
          'Daily Reminders',
          importance: Importance.max,
          priority: Priority.high,
          color: Color(0xFF0F766E),
        ),
      ),
    );
  }

  // 🚨 BUDGET ALERT
  Future<void> checkBudgetAndNotify(AppDatabase db) async {
    final budgets = await db.watchAllBudgets().first;
    final expenses = await db.watchAllExpenses().first;
    final now = DateTime.now();

    for (var budget in budgets) {
      final spent = expenses
          .where((e) => e.category == budget.category && e.date.month == now.month && e.date.year == now.year)
          .fold(0.0, (sum, item) => sum + item.amount);

      if (spent >= budget.limit) {
        await flutterLocalNotificationsPlugin.show(
          budget.id, 
          "🚨 Budget Alert: ${budget.category}",
          "Limit reached! Spent: ${spent.toStringAsFixed(0)} / ${budget.limit.toStringAsFixed(0)}",
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'budget_alerts', 
              'Budget Alerts',
              importance: Importance.max,
              priority: Priority.high,
              color: Color(0xFFFF5252),
            ),
          ),
        );
      }
    }
  }

  // 🗓️ NEW: BATCH SCHEDULE REMINDERS (15 Days * 3 Times = 45 Notifications)
  Future<void> scheduleDailyReminders() async {
    // 1. Cancel all previous schedules to avoid duplicates
    await flutterLocalNotificationsPlugin.cancelAll();

    // 2. Define Messages
    final morningTips = [
      "☀️ Good morning! Plan your spending today.",
      "☕ Saved money on coffee today?",
      "🌅 New day, new savings goals!",
      "💰 Check your budget before you start the day.",
    ];
    
    final afternoonTips = [
      "🍔 Lunch time! Don't forget to log your food expense.",
      "📉 How is your daily limit looking?",
      "🧐 Track every penny to save many.",
      "🔔 Quick check: Have you updated Bill Buddy?",
    ];

    final eveningTips = [
      "🌙 Day end! Review your spending today.",
      "✅ Did you stick to your budget?",
      "📝 Log any missed transactions before bed.",
      "💤 Sleep well knowing your finances are tracked.",
    ];

    // 3. Loop for 15 Days
    for (int day = 0; day < 15; day++) {
      final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
      
      // Calculate the date (Today + day index)
      final tz.TZDateTime targetDate = now.add(Duration(days: day));

      // Schedule Morning (9:00 AM)
      await _scheduleSingle(
        id: 1000 + day, 
        title: "Morning Check-in ☀️",
        body: morningTips[Random().nextInt(morningTips.length)],
        scheduledDate: _createDate(targetDate, 9, 0), // 9:00 AM
      );

      // Schedule Afternoon (2:00 PM)
      await _scheduleSingle(
        id: 2000 + day, 
        title: "Mid-Day Update 🔔",
        body: afternoonTips[Random().nextInt(afternoonTips.length)],
        scheduledDate: _createDate(targetDate, 14, 0), // 14:00 (2 PM)
      );

      // Schedule Evening (8:00 PM)
      await _scheduleSingle(
        id: 3000 + day, 
        title: "Evening Review 🌙",
        body: eveningTips[Random().nextInt(eveningTips.length)],
        scheduledDate: _createDate(targetDate, 20, 0), // 20:00 (8 PM)
      );
    }
    
    debugPrint("✅ Scheduled 45 notifications for the next 15 days.");
  }

  // Helper to schedule a specific time
  Future<void> _scheduleSingle({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledDate,
  }) async {
    // If the time has already passed for today, don't schedule it
    if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
      return; 
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminders',
          'Daily Reminders',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          color: Color(0xFF0F766E),
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle, // Best for battery life
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // Repeats time if we didn't add date logic, but we added date logic.
    );
  }

  // Helper to construct a date with specific time
  tz.TZDateTime _createDate(tz.TZDateTime date, int hour, int minute) {
    return tz.TZDateTime(
      tz.local,
      date.year,
      date.month,
      date.day,
      hour,
      minute,
    );
  }
}