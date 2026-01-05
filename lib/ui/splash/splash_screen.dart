import 'dart:math';
import 'package:bill_buddy/ui/home/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // ✅ Import Lottie
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../../data/auth/auth_service.dart';
import '../onboarding/onboarding_screen.dart';
import '../login/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  // 💬 List of Quotes
  final List<String> _quotes = [
    "Track every penny, own every dream.",
    "Financial freedom starts with smart tracking.",
    "Save money and money will save you.",
    "Your personal finance companion.",
    "Budgeting is telling your money where to go.",
    "Small expenses become big savings.",
  ];

  late String _currentQuote;

  @override
  void initState() {
    super.initState();

    // 1. Pick a random quote
    _currentQuote = _quotes[Random().nextInt(_quotes.length)];

    // 2. Setup Animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart),
    );

    _controller.forward();

    // 3. Navigation Check
    _checkNavigation();
  }

  Future<void> _checkNavigation() async {
    // Wait for animation + buffer
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final isFirstTime = prefs.getBool('isFirstTime') ?? true;
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = authService.currentUser;

    if (isFirstTime) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const OnboardingScreen()));
    } else if (user != null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainScreen()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 🎨 Theme Logic
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Dynamic Colors
    final bgColor = theme.scaffoldBackgroundColor;
    final textColor = theme.colorScheme.onSurface;
    final primaryColor = theme.primaryColor;

    return Scaffold(
      backgroundColor: bgColor, 
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2), // Pushes content down

            // 🎬 CENTER CONTENT (Logo + Lottie)
            FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Lottie Animation
                  SizedBox(
                    height: 250,
                    width: 250,
                    child: Lottie.asset(
                      'assets/lottie/splashscreen.json', // ⚠️ Ensure this file exists
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback icon if Lottie fails or isn't added yet
                        return Icon(Icons.account_balance_wallet_rounded, 
                          size: 100, color: primaryColor);
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // App Name
                  Text(
                    "Bill Buddy",
                    style: TextStyle(
                      fontSize: 36, 
                      fontWeight: FontWeight.w900, 
                      color: primaryColor, // Brand Color
                      letterSpacing: -1.0,
                    ),
                  ),
                  Text(
                    "Smart Expense Tracker",
                    style: TextStyle(
                      fontSize: 14, 
                      fontWeight: FontWeight.w500, 
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                      letterSpacing: 2.0,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(flex: 3), // Pushes quote to bottom

            // 💬 BOTTOM QUOTE
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: Opacity(
                    opacity: _fadeAnimation.value,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                      child: Text(
                        "\"$_currentQuote\"",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          color: textColor.withOpacity(0.7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20), // Bottom padding
          ],
        ),
      ),
    );
  }
}