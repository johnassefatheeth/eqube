import 'dart:convert';
import 'package:ekube/pages/home.dart';
import 'package:ekube/pages/auth/forgotpass.dart';
import 'package:ekube/pages/auth/signup.dart';
import 'package:ekube/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  // Animation Controller for smooth transitions
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the animation controller
    super.dispose();
  }

  // Show snackbar for messages
  void _showSnackBar(String message, Color color) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Sign In method to make API request
  void _signIn() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true; // Show loading indicator
      });

      // Create the login data
      final Map<String, String> loginData = {
        "phone": _phoneController.text.trim(),
        "password": _passwordController.text.trim(),
      };

      // API request URL
      final url = Uri.parse("http://localhost:8080/api/users/login");

      try {
        // Send POST request to the login API
        final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: json.encode(loginData),
        );

        if (response.statusCode == 200) {
          // If the response is successful, save the token and navigate to the home page
          final responseData = json.decode(response.body);
          final token = responseData['token'];

          // Save the token using AuthProvider
          if (token != null) {
            Provider.of<AuthProvider>(context, listen: false).setToken(token);
            // Navigate to the home page after successful sign-in
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()), // Replace with your home page
            );
          }
        } else {
          // Handle API failure (e.g., invalid credentials)
          _showSnackBar("Invalid credentials. Please try again.", Colors.red);
        }
      } catch (e) {
        // Handle network or other errors
        _showSnackBar("An error occurred. Please try again later." + e.toString(), Colors.red);
      } finally {
        setState(() {
          _isLoading = false; // Hide loading indicator
        });
      }
    }
  }

  // Validate password
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF005CFF),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Sign In',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              FadeTransition(
                opacity: _animation,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8, // 80% width of screen
                  child: TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      hintText: 'Enter your phone number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                ),
              ),
              SizedBox(height: 20),
              FadeTransition(
                opacity: _animation,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    ),
                    obscureText: true,
                    validator: _validatePassword,
                  ),
                ),
              ),
              SizedBox(height: 20),
              FadeTransition(
                opacity: _animation,
                child: Center(
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _signIn,
                          child: Text(
                            'Sign In',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF005CFF),
                            padding: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                ),
              ),
              SizedBox(height: 20),
              FadeTransition(
                opacity: _animation,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignUpPage()),
                        );
                      },
                      child: Text('Sign Up'),
                    ),
                    Text(' | '),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                        );
                      },
                      child: Text('Forgot Password?'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
