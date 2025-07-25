import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPhotoNoteScreen extends StatefulWidget {
  const AddPhotoNoteScreen({super.key});

  @override
  State<AddPhotoNoteScreen> createState() => _AddPhotoNoteScreenState();
}

class _AddPhotoNoteScreenState extends State<AddPhotoNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  File? _selectedImage;
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  Future<void> _savePhotoNote() async {
    if (_selectedImage == null || _titleController.text.trim().isEmpty) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _isUploading = true);

    try {
      final ref = FirebaseStorage.instance
          .ref('photos/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await ref.putFile(_selectedImage!);
      final url = await ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('notes').add({
        'title': _titleController.text.trim(),
        'imageUrl': url,
        'type': 'photo',
        'createdAt': Timestamp.now(),
        'userId': user.uid,
      });

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving photo: $e')),
      );
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Photo Note'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            onPressed: _isUploading ? null : _savePhotoNote,
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
              onPressed: _pickImage,
              icon: const Icon(Icons.photo_library),
              label: const Text('Pick Image'),
            ),
            const SizedBox(height: 10),
            if (_selectedImage != null)
              Image.file(_selectedImage!, height: 200),
          ],
        ),
      ),
    );
  }
}
