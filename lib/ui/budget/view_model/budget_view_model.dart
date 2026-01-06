import 'package:bill_buddy/data/local/database.dart'; // Import your database
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BudgetViewModel extends ChangeNotifier {
  DateTime _currentMonth = DateTime.now();
  Budget? _selectedBudget;

  DateTime get currentMonth => _currentMonth;
  Budget? get selectedBudget => _selectedBudget;

  // --- ACTIONS ---

  void nextMonth() {
    _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    notifyListeners();
  }

  void previousMonth() {
    _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    notifyListeners();
  }

  void selectBudget(Budget? budget) {
    _selectedBudget = budget;
    notifyListeners();
  }

  String get formattedMonth => DateFormat('MMM yyyy').format(_currentMonth);

  // --- DATABASE OPERATIONS ---

  Stream<List<Budget>> watchBudgets() {
    return database.watchAllBudgets();
  }

  Stream<List<Expense>> watchExpenses() {
    return database.watchAllExpenses();
  }

  Future<void> saveBudget(String category, double limit) async {
    await database.setBudget(category, limit);
  }

  Future<void> deleteBudget(String category) async {
    await database.deleteBudget(category);
  }

  Future<void> createNewTag(String name, String emoji) async {
    await database.insertTag(TagsCompanion(
      name: drift.Value(name),
      emoji: drift.Value(emoji),
      isCustom: const drift.Value(true),
    ));
  }

  Stream<List<Tag>> watchTags() {
    return database.watchAllTags();
  }
}