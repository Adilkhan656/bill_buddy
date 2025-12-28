import 'package:bill_buddy/data/auth/auth_service.dart';
import 'package:bill_buddy/ui/login/register_screen.dart';
import 'package:flutter/material.dart';
// To access Auth Service if needed


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService(); // Create instance
  bool _isLoading = false;

  void _handleGoogleLogin() async {
    setState(() => _isLoading = true);
    final user = await _authService.signInWithGoogle();
    setState(() => _isLoading = false);
    
    if (user != null) {
      // Navigation is handled automatically by main.dart (StreamBuilder)
      print("Google Login Success: ${user.email}");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Google Login Failed")),
      );
    }
  }

  void _handleEmailLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) return;
    
    setState(() => _isLoading = true);
    try {
      await _authService.signInWithEmail(
        _emailController.text.trim(), 
        _passwordController.text.trim()
      );
      // Success - StreamBuilder handles navigation
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Bill Buddy",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 48),
            
            // Email Field
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            
            // Password Field
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Password", border: OutlineInputBorder()),
              obscureText: true,
            ),
            const SizedBox(height: 24),

            // Login Button
            ElevatedButton(
              onPressed: _isLoading ? null : _handleEmailLogin,
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
              child: _isLoading 
                  ? const CircularProgressIndicator() 
                  : const Text("Login with Email"),
            ),
            const SizedBox(height: 16),

            // Google Button
            OutlinedButton.icon(
              onPressed: _isLoading ? null : _handleGoogleLogin,
              icon: const Icon(Icons.login),
              label: const Text("Sign in with Google"),
              style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
            ),
            Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    const Text("Don't have an account?"),
    TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RegisterScreen()),
        );
      },
      child: const Text("Register"),
    ),
  ],
),
          ],
        ),
      ),
    );
  }
}