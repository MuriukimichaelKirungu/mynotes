import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final _notesCollection = FirebaseFirestore.instance.collection('notes');

  Future<void> addTextNote({
    required String userId,
    required String content,
  }) async {
    await _notesCollection.add({
      'userId': userId,
      'content': content,
      'type': 'text',
      'createdAt': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> getUserNotes(String userId) {
    return _notesCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
