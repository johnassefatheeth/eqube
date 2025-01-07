import 'dart:convert';
import 'package:ekube/pages/auth/verification.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _cityController = TextEditingController();
  final _subCityController = TextEditingController();
  final _woredaController = TextEditingController();
  final _houseNoController = TextEditingController();

  String? _selectedGender;
  bool _isLoading = false;

  // Animation Controller for smooth transitions
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Initialize the animation controller for fading and sliding in
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
  }

  // Validate fields
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

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm password is required';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  // Show snackbar
  void _showSnackBar(String message, Color color) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Handle sign-up
  Future<void> _signUp() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      final url = Uri.parse('http://localhost:8080/api/users/signup'); // Update with your backend URL
      final body = {
        "name": _nameController.text,
        "email": emailController.text,
        "password": _passwordController.text,
        "confirmpassword": _confirmPasswordController.text,
        "phone": _phoneController.text,
        "gender": _selectedGender,
        "city": _cityController.text,
        "subCity": _subCityController.text,
        "woreda": _woredaController.text,
        "houseNo": _houseNoController.text,
      };

      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(body),
        );

        setState(() {
          _isLoading = false;
        });

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          _showSnackBar(responseData['message'] ?? 'Sign-up successful!', Colors.green);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    VerificationPage(emailController.text.toString(), email: emailController.text.toString())),
          );
          // Navigate to the next page if necessary
        } else {
          final errorData = jsonDecode(response.body);
          _showSnackBar(errorData['error'] ?? 'Sign-up failed!', Colors.red);
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        _showSnackBar(e.toString(), Colors.red);
        print(e.toString());
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the animation controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF005CFF),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Sign Up',
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
                  width: MediaQuery.of(context).size.width * 0.8, // Make the width 80% of the screen
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Full name is required' : null,
                  ),
                ),
              ),
              SizedBox(height: 20),
              FadeTransition(
                opacity: _animation,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => value == null || value.isEmpty ? 'Email is required' : null,
                  ),
                ),
              ),
              SizedBox(height: 20),
              FadeTransition(
                opacity: _animation,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: _validatePhone,
                  ),
                ),
              ),
              SizedBox(height: 20),
              FadeTransition(
                opacity: _animation,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: DropdownButtonFormField<String>(
                    value: _selectedGender,
                    decoration: InputDecoration(
                      labelText: 'Gender',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: ['Male', 'Female'].map((String gender) {
                      return DropdownMenuItem(value: gender, child: Text(gender));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                    validator: (value) => value == null ? 'Gender is required' : null,
                  ),
                ),
              ),
              SizedBox(height: 20),
              FadeTransition(
                opacity: _animation,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextFormField(
                    controller: _cityController,
                    decoration: InputDecoration(
                      labelText: 'City',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'City is required' : null,
                  ),
                ),
              ),
              SizedBox(height: 20),
              FadeTransition(
                opacity: _animation,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextFormField(
                    controller: _subCityController,
                    decoration: InputDecoration(
                      labelText: 'Sub City',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Sub City is required' : null,
                  ),
                ),
              ),
              SizedBox(height: 20),
              FadeTransition(
                opacity: _animation,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextFormField(
                    controller: _woredaController,
                    decoration: InputDecoration(
                      labelText: 'Woreda',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) => value == null || value.isEmpty ? 'Woreda is required' : null,
                  ),
                ),
              ),
              SizedBox(height: 20),
              FadeTransition(
                opacity: _animation,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextFormField(
                    controller: _houseNoController,
                    decoration: InputDecoration(
                      labelText: 'House No',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'House No is required' : null,
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
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextFormField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    ),
                    obscureText: true,
                    validator: _validateConfirmPassword,
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
                          onPressed: _signUp,
                          child: Text(
                            'Sign Up',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF005CFF),
                            padding: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
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
