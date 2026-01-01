// import 'package:bill_buddy/data/auth/auth_service.dart';
// import 'package:bill_buddy/ui/login/login_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:provider/provider.dart';
// import 'package:firebase_auth/firebase_auth.dart'; 

// import 'data/local/database.dart';

// import 'ui/home/home_screen.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await dotenv.load(fileName: ".env");
//   await Firebase.initializeApp();

//   runApp(
//     MultiProvider(
//       providers: [
//         Provider<AppDatabase>(
//           create: (_) => AppDatabase(),
//           dispose: (context, db) => db.close(),
//         ),
        
//         Provider<AuthService>(create: (_) => AuthService()),
//       ],
//       child: const MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Smart Expense',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       // Auth Wrapper: Decides which screen to show
//       home: const AuthWrapper(),
//     );
//   }
// }

// class AuthWrapper extends StatelessWidget {
//   const AuthWrapper({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final authService = Provider.of<AuthService>(context);

//     return StreamBuilder<User?>(
//       stream: authService.authStateChanges,
//       builder: (context, snapshot) {
//         // If the stream is waiting, show a loading spinner
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Scaffold(body: Center(child: CircularProgressIndicator()));
//         }

//         // If we have a user data, they are logged in!
//         if (snapshot.hasData) {
          
//           return const MainScreen();
//         }

//         // Otherwise, show Login
//         return const LoginScreen();
//       },
//     );
//   }
// }
import 'package:bill_buddy/ui/home/home_screen.dart';
import 'package:bill_buddy/ui/settings/view_model/setting_view_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart'; 

import 'data/auth/auth_service.dart';

import 'ui/login/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => SettingsViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // ✅ 1. Define your new Deep Teal Color
  static const Color _deepTeal = Color(0xFF0F766E);

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsViewModel>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Expense',
      themeMode: settings.themeMode,
      
      // ✅ LIGHT THEME
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _deepTeal,
          brightness: Brightness.light,
          primary: _deepTeal,
          surface: Colors.white, // Cards will be white
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F7FA), // Light Grey Background
        cardColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF5F7FA),
          foregroundColor: Colors.black87,
        ),
      ),

      // ✅ DARK THEME
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _deepTeal,
          brightness: Brightness.dark,
          primary: _deepTeal, // Keep Teal as primary even in dark mode
          surface: const Color(0xFF1E1E1E), // Cards will be Dark Grey
        ),
        scaffoldBackgroundColor: const Color(0xFF121212), // Almost Black Background
        cardColor: const Color(0xFF1E1E1E),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF121212),
          foregroundColor: Colors.white,
        ),
      ),
      
      home: const AuthWrapper(),
    );
  }
}

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
          return const MainScreen();
        }
        return const LoginScreen();
      },
    );
  }
}