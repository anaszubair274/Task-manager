import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            child: Icon(Icons.person, size: 50),
          ),
          SizedBox(height: 16),
          Text(
            user?.email ?? 'No email',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 8),
          Text('User ID: ${user?.uid ?? 'N/A'}'),
        ],
      ),
    );
  }
}