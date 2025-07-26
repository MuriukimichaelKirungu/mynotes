import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/storage_service.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';

class AddPhotoNoteScreen extends StatefulWidget {
  const AddPhotoNoteScreen({super.key});

  @override
  State<AddPhotoNoteScreen> createState() => _AddPhotoNoteScreenState();
}

class _AddPhotoNoteScreenState extends State<AddPhotoNoteScreen> {
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadNote() async {
    if (_image == null) return;

    final user = AuthService().currentUser;
    if (user == null) return;

    final url = await StorageService().uploadFile(_image!, 'photos');

    await FirestoreService().addTextNote(
      userId: user.uid,
      content: url,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Photo Note')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image != null
                ? Image.file(_image!, height: 200)
                : const Text('No image selected.'),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.photo),
              label: const Text('Pick Photo'),
              onPressed: _pickImage,
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
