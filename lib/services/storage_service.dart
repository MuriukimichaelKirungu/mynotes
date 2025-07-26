import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  final _storage = FirebaseStorage.instance;
  final _uuid = const Uuid();

  Future<String> uploadFile(File file, String folder) async {
    final fileId = _uuid.v4();
    final ref = _storage.ref().child('$folder/$fileId');

    await ref.putFile(file);
    return await ref.getDownloadURL();
  }
}
