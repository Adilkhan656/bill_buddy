import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../data/local/database.dart'; // Import your DB file
import '../../data/auth/auth_service.dart';
import '../../ui/add_expense/screen/add_expense_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Modern Colors
  final Color _primaryColor = const Color(0xFF6C63FF);
  final Color _bgColor = const Color(0xFFF5F7FA);

  @override
  Widget build(BuildContext context) {
    // Access Auth via Provider, but Database via global variable
    final auth = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      backgroundColor: _bgColor,
      // Custom Modern App Bar
      appBar: AppBar(
        backgroundColor: _bgColor,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("My Expenses", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 22)),
            Text("Track your bills smart", style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [
              BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5)
            ]),
            child: IconButton(
              icon: const Icon(Icons.logout_rounded, color: Colors.black54),
              onPressed: () => auth.signOut(),
            ),
          ),
        ],
      ),
      
      body: StreamBuilder<List<Expense>>(
        // ✅ Use the global 'database' variable we created earlier
        stream: database.watchAllExpenses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: _primaryColor));
          }

          final expenses = snapshot.data ?? [];

          if (expenses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long_rounded, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    "No expenses yet",
                    style: TextStyle(color: Colors.grey[600], fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Tap the + button to scan a bill",
                    style: TextStyle(color: Colors.grey[400], fontSize: 14),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: expenses.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final expense = expenses[index];
              return _buildExpenseCard(context, expense);
            },
          );
        },
      ),

      // Modern FAB
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: _primaryColor,
        elevation: 4,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddExpenseScreen()),
          );
        },
        label: const Text("Scan Bill", style: TextStyle(fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.qr_code_scanner_rounded),
      ),
    );
  }

  // 🎨 Custom Expense Card Widget
  Widget _buildExpenseCard(BuildContext context, Expense expense) {
    return Dismissible(
      key: Key(expense.id.toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        database.deleteExpense(expense.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Expense deleted")),
        );
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: Colors.redAccent.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 28),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.06),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            // 📸 IMAGE PREVIEW CIRCLE
            Container(
              height: 55,
              width: 55,
              decoration: BoxDecoration(
                color: _primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
                image: expense.imagePath != null
                    ? DecorationImage(
                        image: FileImage(File(expense.imagePath!)),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: expense.imagePath == null
                  ? Icon(Icons.receipt_rounded, color: _primaryColor)
                  : null,
            ),
            
            const SizedBox(width: 16),
            
            // 📝 TEXT INFO
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expense.merchant,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_rounded, size: 12, color: Colors.grey[400]),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('MMM d, y').format(expense.date),
                        style: TextStyle(color: Colors.grey[500], fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // 💰 AMOUNT
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "\$${expense.amount.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: _primaryColor,
                  ),
                ),
                if (expense.tax > 0)
                  Text(
                    "+ \$${expense.tax.toStringAsFixed(2)} tax",
                    style: TextStyle(color: Colors.grey[400], fontSize: 11),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}