import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart'; 

import 'data/auth/auth_service.dart';
import 'ui/settings/view_model/setting_view_model.dart';
import 'ui/splash/splash_screen.dart';
import 'ui/home/home_screen.dart'; // Make sure this path is correct for MainScreen
import 'ui/login/login_screen.dart';

void main() async {
  // ✅ 1. Wrap entire initialization in one Try-Catch block
  try {
    WidgetsFlutterBinding.ensureInitialized();
    
    print("🔵 1. Starting DotEnv...");
    await dotenv.load(fileName: ".env"); 
    
    print("🔵 2. Starting Firebase...");
    await Firebase.initializeApp();

    print("🔵 3. Launching App UI...");
    runApp(
      MultiProvider(
        providers: [
          Provider<AuthService>(create: (_) => AuthService()),
          ChangeNotifierProvider(create: (_) => SettingsViewModel()),
        ],
        child: const MyApp(),
      ),
    );
  } catch (e, stackTrace) {
    print("❌ CRITICAL STARTUP ERROR: $e");
    print(stackTrace);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
static const Color _brightTeal = Color(0xFF2DD4BF);
  static const Color _deepTeal = Color(0xFF0F766E);

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsViewModel>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bill Buddy', // Updated Name
      themeMode: settings.themeMode,
      
      // ✅ LIGHT THEME
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(
          seedColor: _deepTeal,
          brightness: Brightness.light,
          primary: _deepTeal,
          
          surface: Colors.white,
        ),
        
  scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
  cardColor: Colors.white,
  bottomAppBarTheme: const BottomAppBarThemeData(
    color: Color.fromARGB(255, 255, 251, 251),
  ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
      ),

      // DARK THEME
      darkTheme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins',
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _brightTeal,
          brightness: Brightness.dark,
          
          primary: _brightTeal,
          surface: const Color(0xFF1E1E1E),
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 0, 0, 0),
        cardColor: const Color(0xFF1E1E1E),
         bottomAppBarTheme: const BottomAppBarThemeData(
    color: Color.fromARGB(255, 29, 29, 29),
  ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 0, 0, 0), 
          foregroundColor: Colors.white,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
      ),
      
      
      home: const SplashScreen(),
    );
  }
}

// Keep AuthWrapper for later internal navigation use if needed
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasData) {
          return const MainScreen(); // Ensure MainScreen is imported correctly
        }
        return const LoginScreen();
      },
    );
  }
}