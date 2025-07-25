import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
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

class MyNotesApp extends StatelessWidget {
  const MyNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Notes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      initialRoute: '/login',
      routes: {
        '/add_note':(context) => const AddNoteScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
         '/home': (context) => const HomeScreen(),
        '/add_text_note': (context) => const AddTextNoteScreen(),
        '/add_photo_note': (context) => const AddPhotoNoteScreen(),
        '/add_audio_note': (context) => const AddAudioNoteScreen(),




      },
    );
  }
}
