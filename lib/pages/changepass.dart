import 'package:ekube/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {

  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  late AuthProvider authProvider;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
  }
  // To check if passwords match
  bool _passwordsMatch = true;

  // Function to validate password strength (basic example)
  String _validatePasswordStrength(String password) {
    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return 'Password must contain at least one number';
    }
    return '';
  }

  // Function to check if new and confirm passwords match
  void _checkPasswordMatch() {
    setState(() {
      _passwordsMatch = _newPasswordController.text == _confirmPasswordController.text;
    });
  }

  // Function to handle password change
  Future<void> _changePassword() async {
    // Ensure all fields are valid
    if (_oldPasswordController.text.isEmpty ||
        _newPasswordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty ||
        !_passwordsMatch) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill in all fields correctly')));
      return;
    }
    

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );
    String? token = authProvider.token;

    try {
      // Make API call to change password
      final response = await http.post(
        Uri.parse('http://localhost:8080/api/users/change-password'), // Use the correct endpoint here
        headers: {
          'Authorization': 'Bearer $token'
        },
        body: json.encode({
          'oldPassword': _oldPasswordController.text,
          'newPassword': _newPasswordController.text,
        }),
      );

      Navigator.pop(context); // Close the loading indicator

      if (response.statusCode == 200) {
        // Success response
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Password changed successfully!')));
      } else {
        // Handle errors from backend
        final responseBody = json.decode(response.body);
        String message = responseBody['message'] ?? 'Error changing password';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      }
    } catch (error) {
      Navigator.pop(context); // Close the loading indicator
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to change password. Please try again.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Old Password
              Text('Old Password', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              TextField(
                controller: _oldPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Enter your old password',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
              ),
              SizedBox(height: 20),

              // New Password
              Text('New Password', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              TextField(
                controller: _newPasswordController,
                obscureText: true,
                onChanged: (value) {
                  setState(() {
                    _validatePasswordStrength(value);
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Enter your new password',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
              ),
              SizedBox(height: 10),

              // Password Strength Indicator
              _validatePasswordStrength(_newPasswordController.text).isEmpty
                  ? Container()
                  : Text(
                      _validatePasswordStrength(_newPasswordController.text),
                      style: TextStyle(color: Colors.red, fontSize: 14),
                    ),
              SizedBox(height: 20),

              // Confirm New Password
              Text('Confirm New Password', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                onChanged: (value) {
                  _checkPasswordMatch();
                },
                decoration: InputDecoration(
                  hintText: 'Confirm your new password',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
              ),
              SizedBox(height: 10),

              // Password Match Error
              _passwordsMatch
                  ? Container()
                  : Text(
                      'Passwords do not match',
                      style: TextStyle(color: Colors.red, fontSize: 14),
                    ),
              SizedBox(height: 20),

              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: _oldPasswordController.text.isNotEmpty &&
                          _newPasswordController.text.isNotEmpty &&
                          _confirmPasswordController.text.isNotEmpty &&
                          _passwordsMatch
                      ? _changePassword
                      : null,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                    child: Text('Change Password', style: TextStyle(fontSize: 16)),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF005CFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
