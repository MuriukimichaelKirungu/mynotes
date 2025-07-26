import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get stream of notes by user
  Stream<List<Map<String, dynamic>>> getNotesStream(String userId) {
    return _db
        .collection('notes')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'content': doc['content'],
          'type': doc['type'],
        };
      }).toList();
    });
  }

  // Add a text note
  Future<void> addTextNote({
    required String userId,
    required String content,
  }) async {
    await _db.collection('notes').add({
      'userId': userId,
      'content': content,
      'type': 'text',
      'createdAt': Timestamp.now(),
    });
  }

  // Add a photo note
  Future<void> addPhotoNote({
    required String userId,
    required String imageUrl,
  }) async {
    await _db.collection('notes').add({
      'userId': userId,
      'content': imageUrl,
      'type': 'photo',
      'createdAt': Timestamp.now(),
    });
  }

  // Add an audio note
  Future<void> addAudioNote({
    required String userId,
    required String audioUrl,
  }) async {
    await _db.collection('notes').add({
      'userId': userId,
      'content': audioUrl,
      'type': 'audio',
      'createdAt': Timestamp.now(),
    });
  }
}
