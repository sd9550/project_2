// main.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project_2/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:project_2/services/theme_service.dart';
import 'firebase_options.dart';
import 'screens/login_screen.dart';
import 'screens/forum_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ForumApp());
}

class ForumApp extends StatelessWidget {
  const ForumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        StreamProvider<User?>( // Explicitly specify type here
          create: (context) => context.read<AuthService>().authStateChanges,
          initialData: null,
        ),
        // Add the ThemeNotifier
        ChangeNotifierProvider<ThemeNotifier>( // <--- ADD THIS
          create: (_) => ThemeNotifier(), // <--- ADD THIS
        ), // <--- ADD THIS
      ],
      // currently uses dark theme
      child: Consumer<ThemeNotifier>( // <--- WRAP with CONSUMER
        builder: (context, themeNotifier, child) {
          return MaterialApp(
            title: 'Forum App',
            // Use the theme from the notifier
            theme: themeNotifier.getTheme(), // <--- USE NOTIFIER'S THEME
            home: AuthenticationWrapper(),
          );
        },
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    if (user == null) {
      return LoginScreen();
    }
    return ForumScreen();
  }
}