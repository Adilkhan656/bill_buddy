import 'package:bill_buddy/data/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' as drift; // Helper for database values
import '../../data/local/database.dart';


class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _merchantController = TextEditingController();
  final _amountController = TextEditingController();
  final _categoryController = TextEditingController(text: "General");
  
  bool _isLoading = false;

  void _saveExpense() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    
    // Get DB and Auth provider
    final db = Provider.of<AppDatabase>(context, listen: false);
    final auth = Provider.of<AuthService>(context, listen: false);
    final user = auth.currentUser;

    if (user == null) return; // Safety check

    try {
      // Insert into Drift Database
      await db.insertExpense(
        ExpensesCompanion(
          userId: drift.Value(user.uid),
          merchant: drift.Value(_merchantController.text),
          amount: drift.Value(double.parse(_amountController.text)),
          category: drift.Value(_categoryController.text),
          date: drift.Value(DateTime.now()),
        ),
      );
      
      if (mounted) Navigator.pop(context); // Go back to Home
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Expense")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Merchant Name
              TextFormField(
                controller: _merchantController,
                decoration: const InputDecoration(
                  labelText: "Merchant / Store", 
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.store),
                ),
                validator: (v) => v!.isEmpty ? "Enter store name" : null,
              ),
              const SizedBox(height: 16),

              // Amount
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: "Amount", 
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Enter amount" : null,
              ),
              const SizedBox(height: 16),

              // Category
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: "Category", 
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
              ),
              const SizedBox(height: 24),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveExpense,
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: const Text("Save Expense"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}