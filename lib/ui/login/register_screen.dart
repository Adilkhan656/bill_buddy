import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:drift/drift.dart' as drift; 

import '../../data/auth/auth_service.dart';
import '../../data/local/database.dart'; // ✅ Global Database

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _isLoading = false;

  // ---------------------------------------------------
  // LOGIC SECTION
  // ---------------------------------------------------

  void _handleRegister() async {
    // 1. Basic Validation
    if (_nameController.text.isEmpty || 
        _emailController.text.isEmpty || 
        _ageController.text.isEmpty ||
        _passwordController.text.isEmpty || 
        _confirmPasswordController.text.isEmpty) {
      _showError("Please fill in all fields");
      return;
    }

    // 2. Password Match Check
    if (_passwordController.text.trim() != _confirmPasswordController.text.trim()) {
      _showError("Passwords do not match");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      
      // 3. Create User in Firebase
      User? user = await auth.signUpWithEmail(
        _emailController.text.trim(), 
        _passwordController.text.trim()
      );

      if (user != null) {
        // 4. Save User Profile to Local Database
        await database.saveUserProfile(
          UserProfilesCompanion(
            uid: drift.Value(user.uid),
            name: drift.Value(_nameController.text.trim()),
            email: drift.Value(_emailController.text.trim()),
            age: drift.Value(int.tryParse(_ageController.text.trim()) ?? 0),
          )
        );

        if (mounted) {
          // Success! Go back to login or let AuthWrapper handle it
          Navigator.pop(context); 
        }
      }
    } catch (e) {
      if (mounted) _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ---------------------------------------------------
  // UI SECTION
  // ---------------------------------------------------

  @override
  Widget build(BuildContext context) {
    // Brand Colors
    const primaryColor = Color(0xFF0F766E); // Deep Teal
    const secondaryColor = Color(0xFF115E59);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                // 1. BRANDING HEADER
                Lottie.asset(
    'assets/lottie/register.json', // ✅ Make sure this file exists
    height: 180, // Adjust height as needed
    fit: BoxFit.contain,
  ),
                const SizedBox(height: 16),
                const Text(
                  "Join Bill Buddy",
                  style: TextStyle(
                    fontSize: 26, 
                    fontWeight: FontWeight.w800, 
                    color: primaryColor,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  "Create your account to start tracking",
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),

                const SizedBox(height: 30),

                // 2. THE PRO CARD
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    // ✅ SHARP BORDER (Matches Login)
                    border: Border.all(color: Colors.grey.shade200, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.08),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        "Sign Up",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const SizedBox(height: 24),

                      // Name
                      _buildBorderTextField(
                        controller: _nameController,
                        label: "Full Name",
                        icon: Icons.person_outline,
                        primaryColor: primaryColor,
                      ),
                      const SizedBox(height: 16),

                      // Email
                      _buildBorderTextField(
                        controller: _emailController,
                        label: "Email Address",
                        icon: Icons.email_outlined,
                        primaryColor: primaryColor,
                      ),
                      const SizedBox(height: 16),

                      // Age
                      _buildBorderTextField(
                        controller: _ageController,
                        label: "Age",
                        icon: Icons.calendar_today_outlined,
                        primaryColor: primaryColor,
                        isNumber: true,
                      ),
                      const SizedBox(height: 16),

                      // Password
                      _buildBorderTextField(
                        controller: _passwordController,
                        label: "Password",
                        icon: Icons.lock_outline,
                        isPassword: true,
                        primaryColor: primaryColor,
                      ),
                      const SizedBox(height: 16),

                      // Confirm Password
                      _buildBorderTextField(
                        controller: _confirmPasswordController,
                        label: "Confirm Password",
                        icon: Icons.lock_reset,
                        isPassword: true,
                        primaryColor: primaryColor,
                      ),

                      const SizedBox(height: 30),

                      // ACTION BUTTON
                      SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleRegister,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: _isLoading 
                              ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5)) 
                              : const Text("Create Account", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // 3. FOOTER LINK
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? ", style: TextStyle(color: Colors.grey[600])),
                    GestureDetector(
                      onTap: () => Navigator.pop(context), // Go back to Login
                      child: Text(
                        "Log In", 
                        style: TextStyle(
                          color: secondaryColor, 
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationColor: secondaryColor.withOpacity(0.5)
                        )
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ✅ SHARED PRO WIDGET (Exact copy from Login)
  Widget _buildBorderTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color primaryColor,
    bool isPassword = false,
    bool isNumber = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      cursorColor: primaryColor,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
        floatingLabelStyle: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),
        prefixIcon: Icon(icon, color: Colors.grey[400], size: 22),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
        ),
        
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 2.0),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 2.0),
        ),
      ),
    );
  }
}