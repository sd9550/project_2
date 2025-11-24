import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class ForumScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forum'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => context.read<AuthService>().signOut(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final posts = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return PostCard(
                      message: post['message'],
                      username: post['username'],
                      timestamp: post['timestamp'],
                    );
                  },
                );
              },
            ),
          ),
          AddPostForm(),
        ],
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  final String message;
  final String username;
  final Timestamp timestamp;

  const PostCard({super.key,
    required this.message,
    required this.username,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              username,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(message),
            SizedBox(height: 8),
            Text(
              _formatTimestamp(timestamp),
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    return DateTime.now()
        .difference(timestamp.toDate())
        .inHours
        .toString();
  }
}

class AddPostForm extends StatefulWidget {
  @override
  _AddPostFormState createState() => _AddPostFormState();
}

class _AddPostFormState extends State<AddPostForm> {
  final _messageController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> _addPost() async {
    if (_messageController.text.isEmpty) return;

    final user = _auth.currentUser;
    if (user == null) return;

    // Get user data
    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    final username = userDoc.data()?['username'] ?? 'Anonymous';
    //print("Message check in _AddPostFormState");

    await _firestore.collection('posts').add({
      'message': _messageController.text,
      'userId': user.uid,
      'username': username,
      'timestamp': Timestamp.now(),
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Message',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _addPost,
          ),
        ],
      ),
    );
  }
}