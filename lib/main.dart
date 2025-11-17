// main.dart - Simple forum
import 'package:flutter/material.dart';

void main() {
  runApp(ForumApp());
}

class ForumApp extends StatelessWidget {
  const ForumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Simple Forum'),
          backgroundColor: Colors.blue,
        ),
        body: ListView(
          children: [
            ForumPost(
              title: 'PLACEHOLDER 1',
              content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent laoreet accumsan justo in semper. Pellentesque at ex orci. Phasellus blandit vulputate nisi, quis maximus risus tempor aliquam.',
              author: 'Admin',
            ),
            ForumPost(
              title: 'PLACEHOLDER 2',
              content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent laoreet accumsan justo in semper. Pellentesque at ex orci. Phasellus blandit vulputate nisi, quis maximus risus tempor aliquam.',
              author: 'Admin',
            ),
            ForumPost(
              title: 'PLACEHOLDER 3',
              content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent laoreet accumsan justo in semper. Pellentesque at ex orci. Phasellus blandit vulputate nisi, quis maximus risus tempor aliquam.',
              author: 'Admin',
            ),
            ForumPost(
              title: 'PLACEHOLDER 4',
              content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent laoreet accumsan justo in semper. Pellentesque at ex orci. Phasellus blandit vulputate nisi, quis maximus risus tempor aliquam..',
              author: 'Admin',
            ),
            ForumPost(
              title: 'PLACEHOLDER 5',
              content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent laoreet accumsan justo in semper. Pellentesque at ex orci. Phasellus blandit vulputate nisi, quis maximus risus tempor aliquam.',
              author: 'Admin',
            ),
          ],
        ),
      ),
    );
  }
}

class ForumPost extends StatelessWidget {
  final String title;
  final String content;
  final String author;

  const ForumPost({
    Key? key,
    required this.title,
    required this.content,
    required this.author,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
          ),
          SizedBox(height: 8),
          Text(content),
          SizedBox(height: 8),
          Text(
            'By $author',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}