// import 'package:bill_buddy/data/local/database.dart';
// import 'package:flutter/material.dart';


// class HomeViewModel extends ChangeNotifier {
//   // Stats Variables
//   double totalSpend = 0.0;
//   double monthlySpend = 0.0;
//   double weeklySpend = 0.0;
//   double todaySpend = 0.0;
//   double averageSpend = 0.0;
  
//   // Data for Graph (Category Name -> Amount)
//   Map<String, double> categoryData = {};

//   // Input: List of Expenses from Database
//   void calculateStats(List<Expense> expenses) {
//     // Reset values
//     totalSpend = 0.0;
//     monthlySpend = 0.0;
//     weeklySpend = 0.0;
//     todaySpend = 0.0;
//     categoryData = {};
    
//     if (expenses.isEmpty) {
//       notifyListeners();
//       return;
//     }

//     final now = DateTime.now();
//     final startOfMonth = DateTime(now.year, now.month, 1);
//     // Simple logic for start of week (Monday)
//     final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
//     // Start of Today
//     final startOfToday = DateTime(now.year, now.month, now.day);

//     for (var expense in expenses) {
//       // 1. Grand Total
//       totalSpend += expense.amount;

//       // 2. Date Filtering
//       if (expense.date.isAfter(startOfMonth) || expense.date.isAtSameMomentAs(startOfMonth)) {
//         monthlySpend += expense.amount;
//       }
      
//       if (expense.date.isAfter(startOfWeek) || expense.date.isAtSameMomentAs(startOfWeek)) {
//         weeklySpend += expense.amount;
//       }
      
//       if (expense.date.isAfter(startOfToday) || expense.date.isAtSameMomentAs(startOfToday)) {
//         todaySpend += expense.amount;
//       }

//       // 3. Category Data for Graph
//       if (categoryData.containsKey(expense.category)) {
//         categoryData[expense.category] = categoryData[expense.category]! + expense.amount;
//       } else {
//         categoryData[expense.category] = expense.amount;
//       }
//     }

//     // 4. Average
//     averageSpend = totalSpend / expenses.length;

//     // Notify UI to update
//     // Note: Since we are calling this from inside a StreamBuilder in the View,
//     // we technically don't need notifyListeners() if the StreamBuilder rebuilds the widget tree.
//     // But it's good practice for state management.
//   }
// }
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/local/database.dart';

class HomeViewModel extends ChangeNotifier {
  Map<String, double> _categoryData = {};
  double _totalSpend = 0;
  double _weeklySpend = 0;
  double _dailyAverage = 0;
  
  // New Stats for "All Time"
  String _highestSpendMonth = "N/A";
  double _highestSpendAmount = 0;

  Map<String, double> get categoryData => _categoryData;
  double get totalSpend => _totalSpend;
  double get weeklySpend => _weeklySpend;
  double get dailyAverage => _dailyAverage;
  String get highestSpendMonth => _highestSpendMonth;
  double get highestSpendAmount => _highestSpendAmount;

  // ✅ UPDATED: Accepts Nullable DateTime (null = All Time)
  void calculateStats(List<Expense> allExpenses, DateTime? selectedDate) {
    _totalSpend = 0;
    _weeklySpend = 0;
    _dailyAverage = 0;
    _highestSpendMonth = "N/A";
    _highestSpendAmount = 0;
    _categoryData.clear();

    if (allExpenses.isEmpty) {
      notifyListeners();
      return;
    }

    List<Expense> filteredExpenses;

    if (selectedDate == null) {
      // --------------------------
      // 1. ALL TIME LOGIC
      // --------------------------
      filteredExpenses = allExpenses;

      // Calculate Highest Spending Month
      Map<String, double> monthlyTotals = {};
      for (var e in allExpenses) {
        String key = DateFormat('MMM yyyy').format(e.date);
        monthlyTotals[key] = (monthlyTotals[key] ?? 0) + e.amount;
      }

      if (monthlyTotals.isNotEmpty) {
        var maxEntry = monthlyTotals.entries.reduce((a, b) => a.value > b.value ? a : b);
        _highestSpendMonth = maxEntry.key;
        _highestSpendAmount = maxEntry.value;
      }

      // Calculate Total Days (from first expense to today)
      // This gives a realistic "Lifetime Daily Avg"
      if (allExpenses.isNotEmpty) {
        final firstDate = allExpenses.last.date; // List is usually desc
        final lastDate = DateTime.now();
        final daysDiff = lastDate.difference(firstDate).inDays + 1;
        _totalSpend = allExpenses.fold(0, (sum, item) => sum + item.amount);
        _dailyAverage = daysDiff > 0 ? _totalSpend / daysDiff : _totalSpend;
      }

    } else {
      // --------------------------
      // 2. SPECIFIC MONTH LOGIC
      // --------------------------
      filteredExpenses = allExpenses.where((e) {
        return e.date.year == selectedDate.year && e.date.month == selectedDate.month;
      }).toList();

      _totalSpend = filteredExpenses.fold(0, (sum, item) => sum + item.amount);

      final now = DateTime.now();
      final isCurrentMonth = selectedDate.year == now.year && selectedDate.month == now.month;

      // Weekly Avg (Simple approximation: Total / 4)
      _weeklySpend = _totalSpend / 4; 

      // Daily Avg
      int daysInMonth = DateTime(selectedDate.year, selectedDate.month + 1, 0).day;
      int daysPassed = isCurrentMonth ? now.day : daysInMonth;
      _dailyAverage = daysPassed > 0 ? _totalSpend / daysPassed : 0;
    }

    // Populate Chart Data
    for (var expense in filteredExpenses) {
      _categoryData[expense.category] = (_categoryData[expense.category] ?? 0) + expense.amount;
    }

    notifyListeners();
  }
}