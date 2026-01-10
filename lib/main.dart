// import 'package:bill_buddy/data/notification/notification_service.dart';
// import 'package:bill_buddy/ui/home/screen/home_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:provider/provider.dart';
// import 'package:firebase_auth/firebase_auth.dart'; 

// import 'data/auth/auth_service.dart';
// import 'ui/settings/view_model/setting_view_model.dart';
// import 'ui/splash/splash_screen.dart';

// import 'ui/login/login_screen.dart';

// void main() async {
//   // ✅ 1. THIS MUST BE FIRST (Before everything else)
//   WidgetsFlutterBinding.ensureInitialized(); 
  
//   try {
//     // ✅ 2. Initialize Notifications AFTER bindings are ready
//     final notificationService = NotificationService();
//     await notificationService.init();
//     await notificationService.scheduleMorningMotivation();

//     print("🔵 1. Starting DotEnv...");
//     await dotenv.load(fileName: ".env"); 
    
//     print("🔵 2. Starting Firebase...");
//     await Firebase.initializeApp();
// notificationService.scheduleMorningMotivation().then((_) => print("☀️ Motivation Scheduled"));
//     print("🔵 3. Launching App UI...");
//     runApp(
//       MultiProvider(
//         providers: [
//           Provider<AuthService>(create: (_) => AuthService()),
//           ChangeNotifierProvider(create: (_) => SettingsViewModel()),
//         ],
//         child: const MyApp(),
//       ),
//     );
//   } catch (e, stackTrace) {
//     print("❌ CRITICAL STARTUP ERROR: $e");
//     print(stackTrace);
//   }
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//   static const Color _brightTeal = Color(0xFF2DD4BF);
//   static const Color _deepTeal = Color(0xFF0F766E);

//   @override
//   Widget build(BuildContext context) {
//     final settings = Provider.of<SettingsViewModel>(context);

//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Bill Buddy', 
//       themeMode: settings.themeMode,
      
//       // LIGHT THEME
//       theme: ThemeData(
//         useMaterial3: true,
//         brightness: Brightness.light,
//         fontFamily: 'Poppins',
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: _deepTeal,
//           brightness: Brightness.light,
//           primary: _deepTeal,
//           surface: Colors.white,
//         ),
//         scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
//         cardColor: Colors.white,
//         bottomAppBarTheme: const BottomAppBarThemeData(
//           color: Color.fromARGB(255, 255, 251, 251),
//         ),
//         appBarTheme: const AppBarTheme(
//           backgroundColor: Colors.white,
//           foregroundColor: Colors.black,
//           elevation: 0,
//           surfaceTintColor: Colors.transparent,
//         ),
//       ),

//       // DARK THEME
//       darkTheme: ThemeData(
//         useMaterial3: true,
//         fontFamily: 'Poppins',
//         brightness: Brightness.dark,
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: _brightTeal,
//           brightness: Brightness.dark,
//           primary: _brightTeal,
//           surface: const Color(0xFF1E1E1E),
//         ),
//         scaffoldBackgroundColor: const Color.fromARGB(255, 0, 0, 0),
//         cardColor: const Color(0xFF1E1E1E),
//         bottomAppBarTheme: const BottomAppBarThemeData(
//           color: Color.fromARGB(255, 29, 29, 29),
//         ),
//         appBarTheme: const AppBarTheme(
//           backgroundColor: Color.fromARGB(255, 0, 0, 0), 
//           foregroundColor: Colors.white,
//           elevation: 0,
//           surfaceTintColor: Colors.transparent,
//         ),
//       ),
      
//       home: const SplashScreen(),
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
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Scaffold(body: Center(child: CircularProgressIndicator()));
//         }
//         if (snapshot.hasData) {
//           return const MainScreen(); 
//         }
//         return const LoginScreen();
//       },
//     );
//   }
// }

import 'package:bill_buddy/data/service/notification_service.dart';
import 'package:bill_buddy/ui/home/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

// 🔹 ADDED
// import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';

import 'data/auth/auth_service.dart';
import 'ui/settings/view_model/setting_view_model.dart';
import 'ui/splash/splash_screen.dart';
import 'ui/login/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    final notificationService = NotificationService();
    await notificationService.init();
    await notificationService.scheduleMorningMotivation();

    print("🔵 1. Starting DotEnv...");
    await dotenv.load(fileName: ".env");

    print("🔵 2. Starting Firebase...");
    await Firebase.initializeApp();

    notificationService
        .scheduleMorningMotivation()
        .then((_) => print("☀️ Motivation Scheduled"));

    print("🔵 3. Launching App UI...");

    // 🔹 WRAPPED WITH DevicePreview (NO LOGIC CHANGE)
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
      title: 'Bill Buddy',

      
      // useInheritedMediaQuery: true,
      // locale: DevicePreview.locale(context),
      // builder: DevicePreview.appBuilder,

      themeMode: settings.themeMode,

      // LIGHT THEME
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
          color: Color.fromARGB(255, 241, 241, 240),
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

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          return const MainScreen();
        }
        return const LoginScreen();
      },
    );
  }
}
