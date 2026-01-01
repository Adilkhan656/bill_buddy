import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../login/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  // 1. DATA FOR THE 4 PAGES
  final List<Map<String, String>> _pages = [
    {
      "lottie": "assets/lottie/scan.json", // 1. SCAN
      "title": "Instant Receipt Scan",
      "subtitle": "Snap a photo and let our AI extract every detail instantly. Say goodbye to manual entry forever."
    },
    {
      "lottie": "assets/lottie/help.json", // 2. HELP
      "title": "Smart AI Support",
      "subtitle": "Confused by a bill? Our smart assistant breaks down complex receipts and categorizes them automatically."
    },
    {
      "lottie": "assets/lottie/secure.json", // 3. SECURE (Offline)
      "title": "100% Offline Privacy",
      "subtitle": "We made everything offline. Your financial data stays on your device, so there is zero risk of cloud data breaches."
    },
    {
      "lottie": "assets/lottie/budget.json", // 4. BUDGET
      "title": "Master Your Budget",
      "subtitle": "Visualize your spending with beautiful charts. Set limits, save more, and take full control of your money."
    },
  ];

  void _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', false);

    if (!mounted) return;
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (_) => const LoginScreen())
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0F766E);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ✅ ANIMATED PAGE VIEW
          PageView.builder(
            controller: _controller,
            itemCount: _pages.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) {
              // 🎨 "Great Effect" Logic: Calculate Scale & Opacity based on scroll
              return AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  double value = 1.0;
                  if (_controller.position.haveDimensions) {
                    value = _controller.page! - index;
                    value = (1 - (value.abs() * 0.5)).clamp(0.0, 1.0);
                  }
                  
                  return Transform.scale(
                    scale: Curves.easeOut.transform(value),
                    child: Opacity(
                      opacity: Curves.easeIn.transform(value),
                      child: child,
                    ),
                  );
                },
                child: _OnboardPage(
                  lottieAsset: _pages[index]["lottie"]!,
                  title: _pages[index]["title"]!,
                  subtitle: _pages[index]["subtitle"]!,
                ),
              );
            },
          ),

          // 2. BOTTOM CONTROLS
          Container(
            alignment: const Alignment(0, 0.85),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // SKIP BUTTON
                  TextButton(
                    onPressed: _finishOnboarding,
                    child: Text("Skip", style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                  ),

                  // DOTS INDICATOR
                  SmoothPageIndicator(
                    controller: _controller,
                    count: _pages.length,
                    effect: const ExpandingDotsEffect(
                      activeDotColor: primaryColor,
                      dotColor: Colors.black12,
                      dotHeight: 8,
                      dotWidth: 8,
                      expansionFactor: 3,
                    ),
                  ),

                  // NEXT / START BUTTON
                  _currentIndex == _pages.length - 1 
                    ? ElevatedButton(
                        onPressed: _finishOnboarding,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                          elevation: 4,
                        ),
                        child: const Text("Get Started", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          onPressed: () => _controller.nextPage(
                            duration: const Duration(milliseconds: 600), // Slower for smoother effect
                            curve: Curves.easeOutCubic, // Premium curve
                          ),
                          icon: const Icon(Icons.arrow_forward_rounded, color: primaryColor, size: 28),
                        ),
                      ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ✅ REUSABLE PAGE CONTENT
class _OnboardPage extends StatelessWidget {
  final String lottieAsset;
  final String title;
  final String subtitle;

  const _OnboardPage({
    required this.lottieAsset,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animation
          Lottie.asset(
            lottieAsset, 
            height: 300, 
            fit: BoxFit.contain,
            // Add error builder just in case file is missing
            errorBuilder: (context, error, stackTrace) {
               return const Icon(Icons.image_not_supported, size: 100, color: Colors.grey);
            }
          ),
          const SizedBox(height: 50),
          
          // Title
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28, 
              fontWeight: FontWeight.w800, 
              color: Color(0xFF1E293B), 
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),
          
          // Subtitle
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16, 
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 80), 
        ],
      ),
    );
  }
}