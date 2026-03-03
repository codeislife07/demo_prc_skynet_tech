import 'package:demo_prc_skynet_tech/core/database/app_database.dart';
import 'package:demo_prc_skynet_tech/core/session/session_manager.dart';
import 'package:demo_prc_skynet_tech/features/auth/presentation/screen/home/auth_home_screen.dart';
import 'package:demo_prc_skynet_tech/features/auth/presentation/screen/login/login_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppDatabase.database;
  final loggedIn = await SessionManager.isLoggedIn();
  final email = await SessionManager.getUserEmail();
  runApp(MyApp(loggedIn: loggedIn, userEmail: email));
}

class MyApp extends StatelessWidget {
  final bool loggedIn;
  final String userEmail;

  const MyApp({super.key, this.loggedIn = false, this.userEmail = ''});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF000070),
    );

    return MaterialApp(
      title: 'Practical Test App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: colorScheme,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF000070),
          foregroundColor: Colors.white,
          centerTitle: false,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF000070),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 46),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF000070), width: 1.5),
          ),
        ),
      ),
      home: loggedIn
          ? AuthHomeScreen(userEmail: userEmail)
          : const LoginScreen(),
    );
  }
}
