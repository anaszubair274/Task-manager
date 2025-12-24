
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../home_screen.dart';

class SignUpScreen extends StatefulWidget {
@override
_SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State {
final _emailController = TextEditingController();
final _passwordController = TextEditingController();
final _authService = AuthService();
bool _isLoading = false;

Future _signUp() async {
setState(() => _isLoading = true);
final error = await _authService.signUp(
_emailController.text.trim(),
_passwordController.text.trim(),
);
setState(() => _isLoading = false);

if (error == null) {
Navigator.pushReplacement(
context,
MaterialPageRoute(builder: (_) => HomeScreen()),
);
} else {
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(content: Text('Error: $error')),
);
}
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(title: Text('Sign Up')),
body: Padding(
padding: EdgeInsets.all(16),
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
TextField(
controller: _emailController,
decoration: InputDecoration(labelText: 'Email'),
),
SizedBox(height: 16),
TextField(
controller: _passwordController,
decoration: InputDecoration(labelText: 'Password'),
obscureText: true,
),
SizedBox(height: 24),
_isLoading
? CircularProgressIndicator()
    : ElevatedButton(
onPressed: _signUp,
child: Text('Sign Up'),
),
],
),
),
);
}
}