import 'package:flutter/material.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  // Controllers for form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  // Function to handle form submission
  void _submitForm() {
    // Here, you can handle the form submission (e.g., send via email or API)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Thank you for contacting us!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name field
              Text('Full Name', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Enter your full name',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
              ),
              SizedBox(height: 20),

              // Email field
              Text('Email Address', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Enter your email address',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
              ),
              SizedBox(height: 20),

              // Message field
              Text('Your Message', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              TextField(
                controller: _messageController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Enter your message...',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
              ),
              SizedBox(height: 20),

              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: _nameController.text.isNotEmpty &&
                          _emailController.text.isNotEmpty &&
                          _messageController.text.isNotEmpty
                      ? _submitForm
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF005CFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                    child: Text('Submit', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Additional contact information
              Center(
                child: Text(
                  'Or contact us via email at: support@yourapp.com',
                  style: TextStyle(fontSize: 14, color: Color(0xFF005CFF)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
