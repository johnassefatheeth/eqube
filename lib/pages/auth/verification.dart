import 'dart:async';
import 'package:flutter/material.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  bool _canResend = false;
  int _countdown = 120; // 2 minutes countdown
  late Timer _timer;

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

  // Handle verification logic
  void _verifyCode() {
    String enteredCode = _controllers.map((controller) => controller.text).join('');
    // Add logic here to verify the code entered by the user
    print('Entered Code: $enteredCode');
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
        title: Text('Phone Number Verification'),
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
                'Enter the 6-digit code sent to your phone number.',
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
                    style: TextStyle(color: Colors.blue, fontSize: 18),
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
                    backgroundColor: Colors.green,
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
