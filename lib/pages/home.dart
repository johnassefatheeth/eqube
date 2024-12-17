import 'package:ekube/pages/setdetails.dart';
import 'package:flutter/material.dart';
import 'package:ekube/components/drawerHead.dart';
import 'package:ekube/components/drawerList.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home',
            style: TextStyle(color: Colors.white)), // Set the title text color
        backgroundColor: Color(0xFF005CFF),
        iconTheme: IconThemeData(color: Colors.white),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),  // Add padding for some spacing
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title for the Equb options
            Text(
              'Choose Your Equb Type',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 20), // Space between title and list

            ListTile(
  title: Text('Monthly Equb'),
  leading: Icon(Icons.calendar_month),
  onTap: () {
    // Pass the 'Monthly' type to SetEqubDetailsPage
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SetEqubDetailsPage(equbType: 'Monthly'),
      ),
    );
  },
),
ListTile(
  title: Text('Weekly Equb'),
  leading: Icon(Icons.calendar_today),
  onTap: () {
    // Pass the 'Weekly' type to SetEqubDetailsPage
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SetEqubDetailsPage(equbType: 'Weekly'),
      ),
    );
  },
),
ListTile(
  title: Text('Daily Equb'),
  leading: Icon(Icons.date_range),
  onTap: () {
    // Pass the 'Daily' type to SetEqubDetailsPage
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SetEqubDetailsPage(equbType: 'Daily'),
      ),
    );
  },
),
          ],
        ),
      ),
    );
  }
}
