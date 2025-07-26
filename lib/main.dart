import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/add_note_screen.dart';
import 'screens/add_text_note_screen.dart';
import 'screens/add_photo_note_screen.dart';
import 'screens/add_audio_note_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyNotesApp());
}

class MyNotesApp extends StatefulWidget {
  const MyNotesApp({super.key});

  @override
  State<MyNotesApp> createState() => _MyNotesAppState();
}

class _MyNotesAppState extends State<MyNotesApp> {
  bool _isDarkMode = false;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Notes',
      debugShowCheckedModeBanner: false,
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light().copyWith(
        primaryColor: Colors.deepPurple,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.deepPurple,
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => HomeScreen(toggleTheme: _toggleTheme),
        '/add_note': (context) => const AddNoteScreen(),
        '/add_text_note': (context) => const AddTextNoteScreen(),
        '/add_photo_note': (context) => const AddPhotoNoteScreen(),
        '/add_audio_note': (context) => const AddAudioNoteScreen(),
      },
    );
  }
}
