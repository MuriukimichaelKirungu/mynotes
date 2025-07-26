import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../services/storage_service.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';

class AddAudioNoteScreen extends StatefulWidget {
  const AddAudioNoteScreen({super.key});

  @override
  State<AddAudioNoteScreen> createState() => _AddAudioNoteScreenState();
}

class _AddAudioNoteScreenState extends State<AddAudioNoteScreen> {
  File? _audio;

  Future<void> _pickAudio() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null) {
      setState(() {
        _audio = File(result.files.single.path!);
      });
    }
  }

  Future<void> _uploadNote() async {
    if (_audio == null) return;

    final user = AuthService().currentUser;
    if (user == null) return;

    final url = await StorageService().uploadFile(_audio!, 'audio');

    await FirestoreService().addTextNote(
      userId: user.uid,
      content: url,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Audio Note')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_audio != null ? 'Audio selected: ${_audio!.path}' : 'No audio selected.'),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.audiotrack),
              label: const Text('Pick Audio'),
              onPressed: _pickAudio,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.upload),
              label: const Text('Upload Note'),
              onPressed: _uploadNote,
            ),
          ],
        ),
      ),
    );
  }
}
