import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:provider/provider.dart'; 
import 'package:ekube/providers/auth_provider.dart';
import '../moels/equb_model.dart';

class MyEqubPage extends StatefulWidget {
  const MyEqubPage({super.key});

  @override
  _MyEqubPageState createState() => _MyEqubPageState();
}

class _MyEqubPageState extends State<MyEqubPage> {
  // Index for bottom navigation
  int _currentIndex = 0;

  // Lists to hold Equbs
  List<Equb> activeEqubs = [];
  List<Equb> pastEqubs = [];

  late AuthProvider authProvider; // Declare AuthProvider here

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Now it's safe to access the provider in didChangeDependencies
    authProvider = Provider.of<AuthProvider>(context); 
    fetchEqubs(); // Fetch data when dependencies are ready
  }


String formatDate(String dateStr) {
  // Parse the input date string into a DateTime object
  DateTime dateTime = DateTime.parse(dateStr);

  // Check if the date is today
  DateTime today = DateTime.now();
  if (dateTime.year == today.year &&
      dateTime.month == today.month &&
      dateTime.day == today.day) {
    return 'Today, ${DateFormat.Hm().format(dateTime)}'; // E.g., "Today, 10:30 AM"
  }

  // Format the date in a friendly manner
  return DateFormat.yMMMMd().format(dateTime); // E.g., "December 10, 2024"
}
  // Function to fetch Equb data from the API
  Future<void> fetchEqubs() async {
    String? token = authProvider.token;
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/api/users/equb-groups'),
        headers: {
          'Authorization': 'Bearer $token', 
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> userGroups = data['userGroups'];

        // Process the fetched Equbs
        setState(() {
          activeEqubs = userGroups
              .where((equb) => equb['status'] == 'active')
              .map((equb) => Equb.fromJson(equb))
              .toList();

          pastEqubs = userGroups
              .where((equb) => equb['status'] != 'active')
              .map((equb) => Equb.fromJson(equb))
              .toList();
        });
      } else {
      throw Exception();
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  // Function to get the color for status
  Color getStatusColor(String status) {
    switch (status) {
      case 'active':
        return Colors.orange;
      case 'closed':
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Equb', style: TextStyle(color: Colors.white)),
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
    return activeEqubs.isEmpty
        ? Center(child: Text("No Active Equbs Found")) // Display "Not Found" message
        : ListView.builder(
            itemCount: activeEqubs.length,
            itemBuilder: (context, index) {
              final equb = activeEqubs[index];
              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  title: Text(equb.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Amount Joined: ${equb.totalAmount} Birr'),
                      Text('Status: ${equb.status}'),
                      Text('Rounds: ${equb.rounds}'),
                      Text('Start Date: ${formatDate(equb.startDate)}'),
                      Text('Next Payout Date: ${formatDate(equb.nextPayoutDate)}'),
                    ],
                  ),
                  trailing: Chip(
                    label: Text(equb.status),
                    backgroundColor: getStatusColor(equb.status),
                  ),
                ),
              );
            },
          );
  }

  // Past Equbs tab
  Widget _buildEqubHistory() {
    return pastEqubs.isEmpty
        ? Center(child: Text("No Past Equbs Found")) // Display "Not Found" message
        : ListView.builder(
            itemCount: pastEqubs.length,
            itemBuilder: (context, index) {
              final equb = pastEqubs[index];
              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  title: Text('${equb.name} (Closed)'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Amount Joined: ${equb.totalAmount} Birr'),
                      Text('Rounds: ${equb.rounds}'),
                      Text('Start Date: ${equb.startDate}'),
                      Text('End Date: ${equb.endDate}'),
                    ],
                  ),
                  trailing: Chip(
                    label: Text(equb.status),
                    backgroundColor: getStatusColor(equb.status),
                  ),
                ),
              );
            },
          );
  }
}
