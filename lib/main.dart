import 'package:ekube/pages/Notification.dart';
import 'package:ekube/pages/auth/signin.dart';
import 'package:ekube/pages/changepass.dart';
import 'package:ekube/pages/contactus.dart';
import 'package:ekube/pages/home.dart';
import 'package:ekube/pages/my_equb.dart';
import 'package:ekube/pages/profile.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: HomePage(),
      routes: {
        '/notifications': (context) => NotificationsPage(),
        '/my_ekub': (context) => MyEqubPage(),
        '/profile': (context) => ProfilePage(),
        '/changepassword': (context) => ChangePasswordPage(),
        '/contactus': (context) => ContactUsPage(),
      },
    );
  }
}
