import 'package:flutter/material.dart';

class MyEqubPage extends StatefulWidget {
  @override
  _MyEqubPageState createState() => _MyEqubPageState();
}

class _MyEqubPageState extends State<MyEqubPage> {
  // Index for bottom navigation
  int _currentIndex = 0;

  // Active Equbs
  List<Map<String, dynamic>> activeEqubs = [
    {
      'type': 'Monthly',
      'amount': 2000,
      'status': 'Waiting for people',
      'peopleJoined': 5,
      'potentialWin': 2000 * 5,
      'round': 1,
    },
    {
      'type': 'Weekly',
      'amount': 1000,
      'status': 'Currently being selected',
      'peopleJoined': 15,
      'potentialWin': 1000 * 15,
      'round': 2,
    },
  ];

  // History of past Equbs
  List<Map<String, dynamic>> pastEqubs = [
    {
      'type': 'Daily',
      'amount': 300,
      'status': 'Closed',
      'peopleJoined': 20,
      'potentialWin': 300 * 20,
      'round': 1,
      'totalInvested': 300 * 5,
      'totalGained': 300 * 20,
    },
    {
      'type': 'Monthly',
      'amount': 2000,
      'status': 'Closed',
      'peopleJoined': 12,
      'potentialWin': 2000 * 12,
      'round': 3,
      'totalInvested': 2000 * 12,
      'totalGained': 2000 * 12,
    },
  ];

  // Function to get the color for status
  Color getStatusColor(String status) {
    switch (status) {
      case 'Waiting for people':
        return Colors.orange;
      case 'Currently being selected':
        return Colors.blue;
      case 'Closed':
        return Colors.grey;
      case 'Waiting for the next round':
        return Colors.green;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Equb',
            style: TextStyle(color: Colors.white)), // Set the title text color
        backgroundColor: Color(0xFF005CFF),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: _currentIndex == 0 ? _buildActiveEqubs() : _buildEqubHistory(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Active',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ),
    );
  }

  // Active Equbs tab
  Widget _buildActiveEqubs() {
    return ListView.builder(
      itemCount: activeEqubs.length,
      itemBuilder: (context, index) {
        final equb = activeEqubs[index];
        return Card(
          margin: EdgeInsets.all(8),
          child: ListTile(
            title: Text('${equb['type']} Equb'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Amount Joined: ${equb['amount']} Birr'),
                Text('Status: ${equb['status']}'),
                Text('People Joined: ${equb['peopleJoined']}'),
                Text('Potential Win: ${equb['potentialWin']} Birr'),
                Text('Round: ${equb['round']}'),
              ],
            ),
            trailing: Chip(
              label: Text(equb['status']),
              backgroundColor: getStatusColor(equb['status']),
            ),
          ),
        );
      },
    );
  }

  // Past Equbs tab
  Widget _buildEqubHistory() {
    return ListView.builder(
      itemCount: pastEqubs.length,
      itemBuilder: (context, index) {
        final equb = pastEqubs[index];
        return Card(
          margin: EdgeInsets.all(8),
          child: ListTile(
            title: Text('${equb['type']} Equb (Closed)'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Amount Joined: ${equb['amount']} Birr'),
                Text('People Joined: ${equb['peopleJoined']}'),
                Text('Potential Win: ${equb['potentialWin']} Birr'),
                Text('Round: ${equb['round']}'),
                Text('Total Invested: ${equb['totalInvested']} Birr'),
                Text('Total Gained: ${equb['totalGained']} Birr'),
              ],
            ),
            trailing: Chip(
              label: Text(equb['status']),
              backgroundColor: getStatusColor(equb['status']),
            ),
          ),
        );
      },
    );
  }
}
