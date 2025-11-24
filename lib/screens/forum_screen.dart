import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'account_screen.dart';

class ForumScreen extends StatelessWidget {
  const ForumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forum'),
        actions: [
          // logout button
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => context.read<AuthService>().signOut(),
          ),
          // account button
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AccountScreen()),
            ),
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
    final now = DateTime.now();
    final postTime = timestamp.toDate();
    final difference = now.difference(postTime);
    // fancier way to display time
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}

class AddPostForm extends StatefulWidget {
  const AddPostForm({super.key});

  @override
  _AddPostFormState createState() => _AddPostFormState();
}

class _AddPostFormState extends State<AddPostForm> {
  final _messageController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  String _username = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (mounted) {
        setState(() {
          _username = userDoc.data()?['username'] ?? 'Unknown User';
        });
      }
    }
  }

  Future<void> _addPost() async {
    if (_messageController.text.isEmpty) return;

    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('posts').add({
      'message': _messageController.text,
      'userId': user.uid,
      'username': _username,
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
                hintText: 'Write a message here',
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