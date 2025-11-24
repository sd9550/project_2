import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Account Details', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
      ),
      body: user == null
          ? Center(child: Text('No user logged in', style: TextStyle(color: Colors.white)))
          : StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .snapshots(),
        builder: (context, snapshot) {

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Text(
                'User data not found',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final username = userData['username'] ?? 'Unknown';
          final email = userData['email'] ?? 'No email';
          final createdAt = userData['createdAt'] as Timestamp?;

          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // profile Header
                Card(
                  color: Colors.grey[900],
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blue,
                          radius: 30,
                          child: Text(
                            username[0].toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              username,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              email,
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // account Information
                Text(
                  'Account Information',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),

                Card(
                  color: Colors.grey[900],
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildInfoRow('User ID', user.uid),
                        Divider(color: Colors.grey[700]),
                        _buildInfoRow('Email', email),
                        Divider(color: Colors.grey[700]),
                        _buildInfoRow('Username', username),
                        Divider(color: Colors.grey[700]),
                        _buildInfoRow(
                            'Member Since',
                            createdAt != null
                                ? _formatDate(createdAt.toDate())
                                : 'Unknown'
                        ),
                        Divider(color: Colors.grey[700]),
                        _buildInfoRow('Email Verified', user.emailVerified ? 'Yes' : 'No'),
                      ],
                    ),
                  ),
                ),

                Spacer(),

                // Actions
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.read<AuthService>().signOut(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text('Sign Out'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}