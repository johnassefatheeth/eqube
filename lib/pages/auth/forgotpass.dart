import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

  // Validate phone number for Ethiopian format
  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    final phoneRegExp = RegExp(r'^\+251\d{9}$');
    if (!phoneRegExp.hasMatch(value)) {
      return 'Please enter a valid Ethiopian phone number starting with +251';
    }
    return null;
  }

  // Handle forgot password logic (e.g., send reset code)
  void _forgotPassword() {
    if (_formKey.currentState?.validate() ?? false) {
      // Perform the password reset logic here (e.g., send a reset code)
      print('Sending reset code to phone: ${_phoneController.text}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Phone number input field with validation
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  hintText: 'Enter your phone number starting with +251',
                ),
                keyboardType: TextInputType.phone,
                validator: _validatePhone,
              ),
              const SizedBox(height: 20),

              // Reset Password button
              ElevatedButton(
                onPressed: _forgotPassword,
                child: const Text('Send Reset Code'),
              ),
              const SizedBox(height: 20),

              // Link to return to the Sign In page
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Go back to Sign In page
                    },
                    child: const Text('Remember your password? Sign In'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
