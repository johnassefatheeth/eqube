import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:ekube/pages/contactus.dart';
import 'package:ekube/pages/my_equb.dart';
import 'package:ekube/pages/profile.dart';
import 'package:ekube/pages/setdetails.dart';
import 'package:ekube/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:ekube/components/slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 2;

  @override
  Widget build(BuildContext context) {
  final items =<Widget>[
    Icon(Icons.person, size: 30),
    Icon(Icons.history, size: 30),
    Icon(Icons.home, size: 30),
    Icon(Icons.phone, size: 30),
    Icon(Icons.settings, size: 30),
  ];

  final screens=[
    ProfilePage(),
    MyEqubPage(),
    homeBody(),
    ContactUsPage(),
    SettingsPage(),
  ];
  final appbarNames=<Widget>[
    Text('Profile',
     style: TextStyle(color: Colors.white)),
    Text('My Equbs',
     style: TextStyle(color: Colors.white)),
    Text('Home',
     style: TextStyle(color: Colors.white)),
    Text('Contact Us',
     style: TextStyle(color: Colors.white)),
    Text('Settings',
     style: TextStyle(color: Colors.white))
  ];
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          iconTheme: IconThemeData(color:Colors.white),
        ),
        child: CurvedNavigationBar(
          color: Color(0xFF005CFF),
          backgroundColor: Colors.transparent,
          index: index,
          items: items,
          onTap: (index) => setState(() => this.index = index),
        ),
      ),
      appBar: AppBar(
        title: appbarNames[index], 
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
      
      body: screens[index],
    );
  }

  Padding homeBody() {
    return Padding(
      padding: const EdgeInsets.all(16.0),  // Add padding for some spacing
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Slider at the top
          SizedBox(
            height: 170, // Set a fixed height for the slider
            child: SliderP(),
          ), 

          // Title for the Equb options
          Text(
            'Choose Your Equb Type',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: 10), // Space between title and list

          // Horizontal Scrollable List of Equb types
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                EqubCard(
                  title: 'Monthly Equb',
                  icon: Icons.calendar_month,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SetEqubDetailsPage(equbType: 'daily'),
                      ),
                    );
                  },
                ),
                EqubCard(
                  title: 'Weekly Equb',
                  icon: Icons.calendar_today,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SetEqubDetailsPage(equbType: 'daily'),
                      ),
                    );
                  },
                ),
                EqubCard(
                  title: 'Daily Equb',
                  icon: Icons.date_range,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SetEqubDetailsPage(equbType: 'daily'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Reusable Widget for Equb Type Cards
class EqubCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const EqubCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0), // Space between cards
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            width: 150,  // Fixed width for each card
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 40,
                  color: Colors.blue,
                ),
                SizedBox(height: 8),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
