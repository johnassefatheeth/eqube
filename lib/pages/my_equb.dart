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

class _MyEqubPageState extends State<MyEqubPage> with SingleTickerProviderStateMixin {
  // Tab controller for TabBar
  late TabController _tabController;

  // Lists to hold Equbs
  List<Equb> activeEqubs = [];
  List<Equb> pastEqubs = [];

  late AuthProvider authProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    authProvider = Provider.of<AuthProvider>(context); 
    fetchEqubs(); 
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // TabBar with 2 tabs
  }

  String formatDate(String dateStr) {
    DateTime dateTime = DateTime.parse(dateStr);
    DateTime today = DateTime.now();
    if (dateTime.year == today.year && dateTime.month == today.month && dateTime.day == today.day) {
      return 'Today, ${DateFormat.Hm().format(dateTime)}'; 
    }
    return DateFormat.yMMMMd().format(dateTime); 
  }

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
        throw Exception('Failed to load data');
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
      body: Column(
        children: [
          // Styled TabBar without AppBar
          Container(
            color: Colors.blueAccent,
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              tabs: [
                Tab(text: 'Active'),
                Tab(text: 'History'),
              ],
            ),
          ),
          // TabBarView with content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildActiveEqubs(),
                _buildEqubHistory(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Active Equbs tab
  Widget _buildActiveEqubs() {
    return activeEqubs.isEmpty
        ? Center(child: Text("No Active Equbs Found", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54)))
        : ListView.builder(
            itemCount: activeEqubs.length,
            itemBuilder: (context, index) {
              final equb = activeEqubs[index];
              return Card(
                margin: EdgeInsets.all(12),
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  title: Text(
                    equb.name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.attach_money, color: Colors.green, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Amount Joined: ${equb.totalAmount} Birr',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.loop, color: Colors.orange, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Rounds: ${equb.rounds}',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, color: Colors.blue, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Start Date: ${formatDate(equb.startDate)}',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.date_range, color: Colors.blueAccent, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Next Payout Date: ${formatDate(equb.nextPayoutDate)}',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: Chip(
                    label: Text(equb.status),
                    backgroundColor: getStatusColor(equb.status),
                    labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              );
            },
          );
  }

  // Past Equbs tab
  Widget _buildEqubHistory() {
    return pastEqubs.isEmpty
        ? Center(child: Text("No Past Equbs Found", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54)))
        : ListView.builder(
            itemCount: pastEqubs.length,
            itemBuilder: (context, index) {
              final equb = pastEqubs[index];
              return Card(
                margin: EdgeInsets.all(12),
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  title: Text(
                    '${equb.name} (Closed)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.redAccent),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.attach_money, color: Colors.green, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Amount Joined: ${equb.totalAmount} Birr',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.loop, color: Colors.orange, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Rounds: ${equb.rounds}',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, color: Colors.blue, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Start Date: ${formatDate(equb.startDate)}',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, color: Colors.redAccent, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'End Date: ${formatDate(equb.endDate)}',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: Chip(
                    label: Text(equb.status),
                    backgroundColor: getStatusColor(equb.status),
                    labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              );
            },
          );
  }
}
