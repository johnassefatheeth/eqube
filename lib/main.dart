import 'package:ekube/pages/home.dart';
import 'package:ekube/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ekube/pages/auth/signin.dart';
import 'package:ekube/pages/Notification.dart';
import 'package:ekube/pages/changepass.dart';
import 'package:ekube/pages/contactus.dart';
import 'package:ekube/pages/my_equb.dart';
import 'package:ekube/pages/profile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider()..loadToken(), // Load the token on app start
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Eqube',
        home: SplashScreen(), // Show SplashScreen to handle initial routing
        routes: {
          '/signin': (context) => SignInPage(),
          '/notifications': (context) => NotificationsPage(),
          '/my_ekub': (context) => MyEqubPage(),
          '/profile': (context) => ProfilePage(),
          '/changepassword': (context) => ChangePasswordPage(),
          '/contactus': (context) => ContactUsPage(),
        },
      ),
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
    _navigateBasedOnToken();
  }

  // Navigate based on whether the token is available
  _navigateBasedOnToken() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.loadToken(); // Load the token from SharedPreferences

    // Navigate to the appropriate page
    if (authProvider.token != null) {
      // Token exists, navigate to the main screen (replace with your main page)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()), // Replace with actual home page
      );
    } else {
      // No token, navigate to SignInPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,  // You can set any background color you like
      body: Center(
        child: Image.asset('assets/images/logo.png'), // Your logo image file
      ),
    );
  }
}
