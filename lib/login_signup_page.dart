import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:junkee_dealer/dashboard_page.dart';
import 'dart:convert';

import 'package:junkee_dealer/global.dart';

class LoginSignupPage extends StatefulWidget {
  @override
  _LoginSignupPageState createState() => _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressLatitudeController = TextEditingController();
  final TextEditingController _addressLongitudeController = TextEditingController();

  bool _isSigningUp = false;

  Future<void> _signIn() async {
    // Validate input fields
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      // Show an error message or handle it as per your app's design
      return;
    }

    // Send login request to your Flask server
    final response = await http.post(
      Uri.parse('$baseurl/dealer_login'),
      body: jsonEncode({
        'email': _emailController.text,
        'password': _passwordController.text,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Successful login, navigate to the dealer dashboard or any other page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DealerDashboardPage()),
      );
    } else {
      // Handle login errors, show an error message, etc.
      print('Error signing in: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  Future<void> _signUp() async {
    // Validate input fields
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _usernameController.text.isEmpty ||
        _phoneController.text.isEmpty) {
      // Show an error message or handle it as per your app's design
      return;
    }

    // Send signup request to your Flask server
    final response = await http.post(
      Uri.parse('$baseurl/dealer_signup'),
      body: jsonEncode({
        'email': _emailController.text,
        'password': _passwordController.text,
        'username': _usernameController.text,
        'phone_number': _phoneController.text,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Successful signup, navigate to the dealer dashboard or any other page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DealerDashboardPage()),
      );
    } else {
      // Handle signup errors, show an error message, etc.
      print('Error signing up: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isSigningUp ? 'Dealer Signup' : 'Dealer Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isSigningUp)
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
            SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            if (_isSigningUp) ...[
              SizedBox(height: 16),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _addressLatitudeController,
                decoration: InputDecoration(labelText: 'Address Latitude'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _addressLongitudeController,
                decoration: InputDecoration(labelText: 'Address Longitude'),
              ),
            ],
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isSigningUp ? _signUp : _signIn,
              child: Text(_isSigningUp ? 'Signup' : 'Login'),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () {
                setState(() {
                  _isSigningUp = !_isSigningUp;
                });
              },
              child: Text(
                _isSigningUp
                    ? 'Already have an account? Login'
                    : 'Don\'t have an account? Signup',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

