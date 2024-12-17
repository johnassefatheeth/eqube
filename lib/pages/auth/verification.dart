import 'dart:async';
import 'dart:convert'; // For JSON encoding
import 'package:ekube/pages/auth/signin.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import http package

class VerificationPage extends StatefulWidget {
  final String email; // Email as a parameter

  const VerificationPage(String text, {super.key, required this.email}); // Constructor

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  bool _canResend = false;
  int _countdown = 120; // 2 minutes countdown
  late Timer _timer;


// Show snackbar
  void _showSnackBar(String message, Color color) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }


  // Timer to count down 2 minutes
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          _canResend = true;
          _timer.cancel();
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  // Handle verification logic and send data to backend
  Future<void> _verifyCode() async {
    String enteredCode = _controllers.map((controller) => controller.text).join('');
    if (enteredCode.length == 6) {
      final payload = {
        "email": widget.email,
        "otp": enteredCode,
      };

      // URL of your backend endpoint
      final url = Uri.parse('http://localhost:5000/api/users/verify-email');
      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode(payload),
        );

        if (response.statusCode == 200) {
          // Handle successful response
          print('Verification successful');
          _showSnackBar(response.body, Colors.green);
           Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignInPage()),
                      );
        } else {
          // Handle error
          print('Error: ${response.body}');
          _showSnackBar(response.body, Colors.red);
        }
      } catch (e) {
        _showSnackBar(e.toString(), Colors.red);
        print('Error: $e');
      }
    } else {
      print('Please enter a valid 6-digit OTP');
    }
  }

  // Handle resending the verification code
  void _resendCode() {
    setState(() {
      _canResend = false;
      _countdown = 120; // Reset countdown to 2 minutes
    });
    _startTimer();
    // Add logic to resend the verification code to the user
    print('Verification code resent');
  }

  // Clear all input fields
  void _clearInputs() {
    for (var controller in _controllers) {
      controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF005CFF),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Email Verification',
        style: TextStyle(
          color: Colors.white
        ),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Instructions for verification
              Text(
                'Enter the 6-digit code sent to your email.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 20),

              // 6-digit input field (one per digit)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 50,
                    child: TextFormField(
                      controller: _controllers[index],
                      autofocus: index == 0,
                      textInputAction: index < 5 ? TextInputAction.next : TextInputAction.done,
                      maxLength: 1,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        counterText: "",
                        hintText: '-',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        if (value.length == 1 && index < 5) {
                          FocusScope.of(context).nextFocus();
                        }
                        if (value.isEmpty && index > 0) {
                          FocusScope.of(context).previousFocus();
                        }
                      },
                    ),
                  );
                }),
              ),
              SizedBox(height: 20),

              // Clear Input Button
              Center(
                child: TextButton(
                  onPressed: _clearInputs,
                  child: Text(
                    'Clear',
                    style: TextStyle(color: Color(0xFF005CFF), fontSize: 18),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Countdown timer
              Center(
                child: Text(
                  'Resend code in: ${_countdown}s',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.red),
                ),
              ),
              SizedBox(height: 20),

              // Resend Code Button
              Center(
                child: ElevatedButton(
                  onPressed: _canResend ? _resendCode : null,
                  child: Text('Resend Code'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _canResend ? Colors.blue : Colors.grey,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                ),
              ),
              SizedBox(height: 40),

              // Large Verify Button
              Center(
                child: ElevatedButton(
                  onPressed: _verifyCode,
                  child: Text(
                    'Verify',
                    style: TextStyle(fontSize: 20),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF005CFF),
                    padding: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
