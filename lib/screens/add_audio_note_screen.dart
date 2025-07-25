import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AddAudioNoteScreen extends StatefulWidget {
  const AddAudioNoteScreen({super.key});

  @override
  State<AddAudioNoteScreen> createState() => _AddAudioNoteScreenState();
}

class _AddAudioNoteScreenState extends State<AddAudioNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  File? _selectedAudio;
  bool _isUploading = false;

  Future<void> _pickAudio() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedAudio = File(result.files.single.path!);
      });
    }
  }

  Future<void> _saveAudioNote() async {
    if (_selectedAudio == null || _titleController.text.trim().isEmpty) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _isUploading = true);

    try {
      final ref = FirebaseStorage.instance
          .ref('audio/${DateTime.now().millisecondsSinceEpoch}.mp3');
      await ref.putFile(_selectedAudio!);
      final url = await ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('notes').add({
        'title': _titleController.text.trim(),
        'audioUrl': url,
        'type': 'audio',
        'createdAt': Timestamp.now(),
        'userId': user.uid,
      });

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving audio: $e')),
      );
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Audio Note'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            onPressed: _isUploading ? null : _saveAudioNote,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(hintText: 'Title'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _pickAudio,
              icon: const Icon(Icons.audiotrack),
              label: const Text('Pick Audio File'),
            ),
            const SizedBox(height: 10),
            if (_selectedAudio != null)
              Text('File selected: ${_selectedAudio!.path.split('/').last}'),
          ],
        ),
      ),
    );
  }
}
