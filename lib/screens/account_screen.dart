// account_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';
import '../services/theme_service.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    // Get the theme notifier
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Account Details'),
      ),
      body: user == null
          ? Center(child: Text('No user logged in'))
          : StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Text('User data not found'),
            );
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final username = userData['username'] ?? 'Unknown User';
          final email = userData['email'] ?? 'No email';
          final createdAt = userData['createdAt'] as Timestamp?;

          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // profile Header
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
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
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              email,
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
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),

                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Theme Toggle added here
                        _buildThemeToggle(themeNotifier),
                        Divider(color: Theme.of(context).dividerColor),
                        _buildInfoRow('Email', email),
                        Divider(color: Theme.of(context).dividerColor),
                        _buildInfoRow('Username', username),
                        Divider(color: Theme.of(context).dividerColor),
                        _buildInfoRow(
                            'Member Since',
                            createdAt != null
                                ? _formatDate(createdAt.toDate())
                                : 'Unknown'
                        )
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
                      // Use theme/context colors
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14),
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

  // For theme toggling
  Widget _buildThemeToggle(ThemeNotifier themeNotifier) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              'Dark Mode',
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Align(
              alignment: Alignment.centerRight,
              child: Switch(
                value: themeNotifier.isDarkMode,
                onChanged: (isDark) => themeNotifier.setDarkMode(isDark),
                activeThumbColor: Colors.blue,
              ),
            ),
          ),
        ],
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
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
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