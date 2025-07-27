import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/add_note_screen.dart';
import 'screens/add_text_note_screen.dart';
import 'screens/add_photo_note_screen.dart';
import 'screens/add_audio_note_screen.dart';
import 'screens/profile_screen.dart';

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
  bool isDarkMode = false;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Notes',
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => HomeScreen(toggleTheme: toggleTheme),
        '/add_note': (context) => const AddNoteScreen(),
        '/add_text_note': (context) => const AddTextNoteScreen(),
        '/add_photo_note': (context) => const AddPhotoNoteScreen(),
        '/add_audio_note': (context) => const AddAudioNoteScreen(),
        '/profile': (context) => ProfileScreen(toggleTheme: toggleTheme),
      },
    );
  }
}
