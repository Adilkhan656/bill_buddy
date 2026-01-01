import 'package:bill_buddy/data/local/database.dart';
import 'package:flutter/material.dart';


class HomeViewModel extends ChangeNotifier {
  // Stats Variables
  double totalSpend = 0.0;
  double monthlySpend = 0.0;
  double weeklySpend = 0.0;
  double todaySpend = 0.0;
  double averageSpend = 0.0;
  
  // Data for Graph (Category Name -> Amount)
  Map<String, double> categoryData = {};

  // Input: List of Expenses from Database
  void calculateStats(List<Expense> expenses) {
    // Reset values
    totalSpend = 0.0;
    monthlySpend = 0.0;
    weeklySpend = 0.0;
    todaySpend = 0.0;
    categoryData = {};
    
    if (expenses.isEmpty) {
      notifyListeners();
      return;
    }

    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    // Simple logic for start of week (Monday)
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    // Start of Today
    final startOfToday = DateTime(now.year, now.month, now.day);

    for (var expense in expenses) {
      // 1. Grand Total
      totalSpend += expense.amount;

      // 2. Date Filtering
      if (expense.date.isAfter(startOfMonth) || expense.date.isAtSameMomentAs(startOfMonth)) {
        monthlySpend += expense.amount;
      }
      
      if (expense.date.isAfter(startOfWeek) || expense.date.isAtSameMomentAs(startOfWeek)) {
        weeklySpend += expense.amount;
      }
      
      if (expense.date.isAfter(startOfToday) || expense.date.isAtSameMomentAs(startOfToday)) {
        todaySpend += expense.amount;
      }

      // 3. Category Data for Graph
      if (categoryData.containsKey(expense.category)) {
        categoryData[expense.category] = categoryData[expense.category]! + expense.amount;
      } else {
        categoryData[expense.category] = expense.amount;
      }
    }

    // 4. Average
    averageSpend = totalSpend / expenses.length;

    // Notify UI to update
    // Note: Since we are calling this from inside a StreamBuilder in the View,
    // we technically don't need notifyListeners() if the StreamBuilder rebuilds the widget tree.
    // But it's good practice for state management.
  }
}