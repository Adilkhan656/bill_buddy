import 'package:bill_buddy/data/auth/auth_service.dart';
import 'package:bill_buddy/ui/add_expense/add_expense.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // For formatting date/currency
import '../../data/local/database.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);
    final auth = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Expenses"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => auth.signOut(),
          ),
        ],
      ),
      // StreamBuilder listens to the Database changes in real-time
      body: StreamBuilder<List<Expense>>(
        stream: db.watchAllExpenses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final expenses = snapshot.data ?? [];

          if (expenses.isEmpty) {
            return const Center(
              child: Text(
                "No expenses yet.\nTap + to add one!",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            itemCount: expenses.length,
            itemBuilder: (context, index) {
              final expense = expenses[index];
              return Dismissible(
                key: Key(expense.id.toString()),
                direction: DismissDirection.endToStart,
                onDismissed: (_) {
                  db.deleteExpense(expense.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Expense deleted")),
                  );
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(expense.category[0].toUpperCase()),
                  ),
                  title: Text(expense.merchant),
                  subtitle: Text(DateFormat('MMM d, y').format(expense.date)),
                  trailing: Text(
                    "\$${expense.amount.toStringAsFixed(2)}",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddExpenseScreen()),
          );
        },
        label: const Text("Add Bill"),
        icon: const Icon(Icons.add),
      ),
    );
  }
}