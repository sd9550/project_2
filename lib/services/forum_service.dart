import 'package:cloud_firestore/cloud_firestore.dart';

class ForumService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // get all posts
  Stream<QuerySnapshot> getPosts() {
    return _firestore
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // create a new post
  Future<void> createPost(String title, String content, String authorId, String authorName) async {
    await _firestore.collection('posts').add({
      'title': title,
      'content': content,
      'authorId': authorId,
      'authorName': authorName,
      'timestamp': FieldValue.serverTimestamp(),
      'likes': 0,
    });
  }

}