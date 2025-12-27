import 'package:bill_buddy/data/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' as drift; // Alias for drift helper

import '../../data/local/database.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();
  
  bool _isLoading = false;

  void _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final authService = Provider.of<AuthService>(context, listen: false);
    final db = Provider.of<AppDatabase>(context, listen: false);

    try {
      // 1. Create User in Firebase
      final user = await authService.signUpWithEmail(
        _emailController.text.trim(), 
        _passController.text.trim()
      );

      if (user != null) {
        // 2. Save Extra Details (Name, Age) to Local Database
        await db.saveUserProfile(
          UserProfilesCompanion(
            uid: drift.Value(user.uid),
            name: drift.Value(_nameController.text.trim()),
            email: drift.Value(_emailController.text.trim()),
            age: drift.Value(int.parse(_ageController.text.trim())),
          )
        );

        // 3. Success! (Navigator pops back to login or Main handles auth state)
        if (mounted) Navigator.pop(context); 
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Account")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // 1. User Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "User Name", border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? "Please enter name" : null,
              ),
              const SizedBox(height: 16),

              // 2. Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder()),
                validator: (v) => !v!.contains("@") ? "Invalid email" : null,
              ),
              const SizedBox(height: 16),

              // 3. Age
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: "Age", border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Enter age" : null,
              ),
              const SizedBox(height: 16),

              // 4. Password
              TextFormField(
                controller: _passController,
                decoration: const InputDecoration(labelText: "Password", border: OutlineInputBorder()),
                obscureText: true,
                validator: (v) => v!.length < 6 ? "Min 6 chars" : null,
              ),
              const SizedBox(height: 16),

              // 5. Confirm Password
              TextFormField(
                controller: _confirmPassController,
                decoration: const InputDecoration(labelText: "Confirm Password", border: OutlineInputBorder()),
                obscureText: true,
                validator: (v) {
                  if (v != _passController.text) return "Passwords do not match";
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Register Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleRegister,
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: _isLoading 
                    ? const CircularProgressIndicator() 
                    : const Text("Register"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}