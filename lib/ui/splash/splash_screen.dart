import 'package:bill_buddy/ui/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../../data/auth/auth_service.dart';
import '../onboarding/onboarding_screen.dart'; // We will create this next
import '../login/login_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // 1. Setup Animation (Duration: 2 seconds)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // Start Animation
    _controller.forward();

    // 2. Trigger Navigation Logic after animation
    _checkNavigation();
  }

  Future<void> _checkNavigation() async {
    // Wait for animation to finish + small buffer
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    // Check 1: Is it the first time opening the app?
    final prefs = await SharedPreferences.getInstance();
    final isFirstTime = prefs.getBool('isFirstTime') ?? true;

    // Check 2: Is user already logged in?
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = authService.currentUser;

    if (isFirstTime) {
      // Go to Onboarding
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (_) => const OnboardingScreen())
      );
    } else if (user != null) {
      // User logged in -> Home
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (_) => const MainScreen())
      );
    } else {
      // Not first time, not logged in -> Login
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (_) => const LoginScreen())
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0F766E);

    return Scaffold(
      backgroundColor: Colors.white, // Or your app background color
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Replace with your Logo Asset or Lottie
                // If using Image: Image.asset('assets/images/logo.png', width: 150),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.account_balance_wallet_rounded, size: 80, color: primaryColor),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Bill Buddy",
                  style: TextStyle(
                    fontSize: 32, 
                    fontWeight: FontWeight.bold, 
                    color: primaryColor,
                    letterSpacing: -1.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}