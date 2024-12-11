import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  // Controllers for password fields
  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

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
  void _changePassword() {
    // Here, implement the actual password change logic with your backend or authentication service
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Password changed successfully!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
        backgroundColor: Colors.teal,
      ),
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
                    backgroundColor: Colors.teal,
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
