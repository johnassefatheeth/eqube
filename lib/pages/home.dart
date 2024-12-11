import 'package:ekube/components/drawerHead.dart';
import 'package:ekube/components/drawerList.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
        IconButton(
          icon: Icon(Icons.notifications),
          onPressed: () {
            // Navigate to the notifications page
            Navigator.pushNamed(context, '/notifications');
          },
        ),
        ],
      ),
      drawer: Drawer(
          child: SingleChildScrollView(
            child: Container(
              child: const Column(
                children: [
                  DrawerHeaderpart(),
                  DrawerList(),
                ],
              ),
            ),
          ),
        ),
      body: Center(
        child: Text('Welcome to the Home Page!'),
      ),
    );
  }
}
