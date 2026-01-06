import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../data/auth/auth_service.dart';
import '../home/screen/home_screen.dart'; // ✅ IMPORTANT: Import MainScreen
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _isLoading = false;

  // ---------------------------------------------------
  // LOGIC SECTION
  // ---------------------------------------------------
void _handleGoogleLogin() async {
    setState(() => _isLoading = true);
    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      
      // 1. Try to sign in
      final user = await auth.signInWithGoogle();

      // 2. Double Check: If user is null, check if Firebase actually logged us in anyway
      final currentUser = user ?? auth.currentUser;

      if (mounted) {
        setState(() => _isLoading = false);

        // ✅ If we found a user (either from return or fallback), GO TO HOME
        if (currentUser != null) {
          print("✅ Login Success! Navigating to Home...");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        } else {
           // Only show error if we are TRULY not logged in
           _showError("Google Sign In failed or was cancelled.");
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        
        // Final Check: Did we get logged in despite the crash?
        final auth = Provider.of<AuthService>(context, listen: false);
        if (auth.currentUser != null) {
           Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        } else {
          _showError("Login Error: $e");
        }
      }
    }
  }
void _handleEmailLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showError("Please enter email and password");
      return;
    }
    
    setState(() => _isLoading = true);
    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      
      print("🔵 Attempting Login for: ${_emailController.text.trim()}");

      // 3. Attempt Sign In
      final user = await auth.signInWithEmail(
        _emailController.text.trim(), 
        _passwordController.text.trim()
      );

      // 4. Navigate if successful
      if (user != null && mounted) {
        print("✅ Login Success: ${user.uid}");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      // ✅ CATCH SPECIFIC FIREBASE ERRORS HERE
      print("❌ Firebase Auth Error Code: ${e.code}");
      print("❌ Firebase Auth Message: ${e.message}");

      String msg = "Login failed";
      if (e.code == 'user-not-found' || e.code == 'invalid-credential') {
        msg = "User not found or wrong password.";
      } else if (e.code == 'wrong-password') {
        msg = "Incorrect password.";
      } else if (e.code == 'invalid-email') {
        msg = "Email address is invalid.";
      } else if (e.code == 'user-disabled') {
        msg = "This account has been disabled.";
      } else {
        msg = "Error: ${e.message}";
      }
      
      if (mounted) _showError(msg);
    } catch (e) {
      print("❌ General Error: $e");
      if (mounted) _showError("An unexpected error occurred.");
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
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                // 1. BRANDING HEADER (With Lottie)
                Lottie.asset(
                  'assets/lottie/login.json', 
                  height: 200,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 1),
                const Text(
                  "Bill Buddy",
                  style: TextStyle(
                    fontSize: 28, 
                    fontWeight: FontWeight.w800, 
                    color: primaryColor,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  "Manage your expenses smartly",
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                
                const SizedBox(height: 40),

                // 2. THE PRO CARD
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    // BORDER
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
                        "Welcome Back",
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Please sign in to continue",
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                      ),
                      const SizedBox(height: 30),

                      // Email Input
                      _buildBorderTextField(
                        controller: _emailController,
                        label: "Email Address",
                        icon: Icons.email_outlined,
                        primaryColor: primaryColor,
                      ),
                      const SizedBox(height: 20),

                      // Password Input
                      _buildBorderTextField(
                        controller: _passwordController,
                        label: "Password",
                        icon: Icons.lock_outline,
                        isPassword: true,
                        primaryColor: primaryColor,
                      ),
                      
                      const SizedBox(height: 10),

                      // MAIN ACTION BUTTON
                      SizedBox(
                        height: 56, 
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleEmailLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 0, 
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: _isLoading 
                              ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5)) 
                              : const Text("Sign In", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // 3. DIVIDER
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text("Or continue with", style: TextStyle(color: Colors.grey.shade500, fontSize: 13, fontWeight: FontWeight.w500)),
                    ),
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                  ],
                ),

                const SizedBox(height: 30),

                // 4. GOOGLE BUTTON
                SizedBox(
                  height: 56,
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : _handleGoogleLogin,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black87,
                      side: BorderSide(color: Colors.grey.shade300, width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      backgroundColor: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/inc_google.png', height: 24),
                        const SizedBox(width: 12),
                        const Text(
                          "Sign in with Google",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // 5. FOOTER LINK
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account? ", style: TextStyle(color: Colors.grey[600])),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisterScreen()),
                        );
                      },
                      child: Text(
                        "Register", 
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBorderTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color primaryColor,
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
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