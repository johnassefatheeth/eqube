import 'package:ekube/pages/Notification.dart';
import 'package:ekube/pages/changepass.dart';
import 'package:ekube/pages/contactus.dart';
import 'package:ekube/pages/my_equb.dart';
import 'package:ekube/pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:ekube/pages/auth/signin.dart'; // Import your SignInPage here

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: SplashScreen(),
      routes: {
        '/signin': (context) => SignInPage(),
        '/notifications': (context) => NotificationsPage(),
        '/my_ekub': (context) => MyEqubPage(),
        '/profile': (context) => ProfilePage(),
        '/changepassword': (context) => ChangePasswordPage(),
        '/contactus': (context) => ContactUsPage(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToSignIn();
  }

  _navigateToSignIn() async {
    // Duration of the splash screen display
    await Future.delayed(Duration(seconds: 3));
    // Navigate to the SignInPage after the delay
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignInPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,  // You can set any background color you like
      body: Center(
        child: Image.asset('assets/images/logo.png'), // Your logo image file should be in the 'assets' folder
      ),
    );
  }
}
