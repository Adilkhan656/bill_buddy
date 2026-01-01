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
import 'package:bill_buddy/ui/login/login_screen.dart';
import 'package:bill_buddy/ui/settings/view_model/setting_view_model.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart'; 

import 'data/auth/auth_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        // 1. Auth Service
        Provider<AuthService>(create: (_) => AuthService()),
        
        // 2. Settings ViewModel (For Dark Mode & Currency)
        ChangeNotifierProvider(create: (_) => SettingsViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Listen to Settings
    final settings = Provider.of<SettingsViewModel>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Expense',
      
      // ✅ Dynamic Theme Control
      themeMode: settings.themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6C63FF), brightness: Brightness.light),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6C63FF), brightness: Brightness.dark),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF121212),
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
          return const MainScreen(); // ✅ Goes to Dashboard/Home
        }

        return const LoginScreen();
      },
    );
  }
}