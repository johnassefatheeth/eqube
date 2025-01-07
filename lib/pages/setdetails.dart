import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:ekube/pages/submitpayemnet.dart';
import 'package:ekube/providers/auth_provider.dart';

class SetEqubDetailsPage extends StatefulWidget {
  final String equbType; // Constructor to accept the Equb type

  const SetEqubDetailsPage({super.key, required this.equbType});

  @override
  _SetEqubDetailsPageState createState() => _SetEqubDetailsPageState();
}

class _SetEqubDetailsPageState extends State<SetEqubDetailsPage> {
  late Future<List<Equb>> equbs;
  late AuthProvider authProvider;
 

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Access the provider after the dependencies are resolved
    authProvider = Provider.of<AuthProvider>(context);
    // Now you can fetch Equbs using the token
    equbs = fetchEqubs(widget.equbType);
  }

   Future<List<Equb>> fetchEqubs(String equbType) async {
    String? token = authProvider.token;
    final response = await http.get(
      Uri.parse('http://localhost:8080/api/equbs/equbs'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      // Filter Equbs based on the equbType and status == 'active'
      List<Equb> filteredEqubs = data
          .map((equbJson) => Equb.fromJson(equbJson))
          .where((equb) =>
              equb.frequency==equbType && equb.status == 'active') // Apply filter
          .toList();

      return filteredEqubs;
    } else {
      throw Exception(response.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Available Equbs',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF005CFF),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Equb>>(
          future: equbs,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No Equbs available.'));
            } else {
              List<Equb> equbsList = snapshot.data!;
              return ListView.builder(
                itemCount: equbsList.length,
                itemBuilder: (context, index) {
                  Equb equb = equbsList[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 12),
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      title: Text(
                        equb.name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.monetization_on, color: Colors.green, size: 18),
                              SizedBox(width: 8),
                              Text(
                                'Total Amount: ${equb.totalAmount} Birr',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.repeat, color: Colors.orange, size: 18),
                              SizedBox(width: 8),
                              Text(
                                'Frequency: ${equb.frequency}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                equb.status == 'active' ? Icons.check_circle : Icons.cancel,
                                color: equb.status == 'active' ? Colors.green : Colors.red,
                                size: 18,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Status: ${equb.status}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: equb.status == 'active' ? Colors.green : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Color(0xFF005CFF),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          // Show the join Equb popup
                          showDialog(
                            context: context,
                            builder: (context) => _showJoinEqubDialog(context, equb),
                          );
                        },
                        icon: Icon(Icons.add),
                        label: Text('Join Equb'),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  // Popup for joining the Equb
  Widget _showJoinEqubDialog(BuildContext context, Equb equb) {
    return JoinEqubDialog(equb: equb);
  }
}

class JoinEqubDialog extends StatefulWidget {
  final Equb equb;

  const JoinEqubDialog({super.key, required this.equb});

  @override
  _JoinEqubDialogState createState() => _JoinEqubDialogState();
}

class _JoinEqubDialogState extends State<JoinEqubDialog> {
  bool _isChecked = false; // Track checkbox state

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text('Join Equb', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'If you wish to join this Equb, please read and agree to the terms and conditions.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Checkbox(
                value: _isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    _isChecked = value ?? false;
                  });
                },
              ),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    text: "I have read and agree to the ",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'terms and conditions',
                        style: TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Handle terms and conditions link click
                            showDialog(
                              context: context,
                              builder: (context) => _showTermsDialog(context),
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close the dialog
          },
          child: Text('Cancel', style: TextStyle(fontSize: 16)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Color(0xFF005CFF),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          ),
          onPressed: _isChecked
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DepositPage(EqubId: widget.equb.id,amount: widget.equb.totalAmount,),
                    ),
                  );
                }
              : null, // Only enable if the checkbox is checked
          child: Text('Join'),
        ),
      ],
    );
  }

  // Dialog for displaying the terms and conditions
  Widget _showTermsDialog(BuildContext context) {
    return AlertDialog(
      title: Text('Terms and Conditions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      content: SingleChildScrollView(
        child: Text(
          '''Terms and Conditions Effective Date: [Date] Welcome to Ekube! These Terms and Conditions govern your use of the Ekube mobile application ("App") and its services...''',
          style: TextStyle(fontSize: 16),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close the terms and conditions dialog
          },
          child: Text('Close', style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }
}



class Equb {
  final String id;
  final String name;
  final int totalAmount;
  final int contributionPerUser;
  final String frequency;
  final String status;
  final DateTime startDate;
  final DateTime endDate;
  final List<dynamic> participants;
  final String? nextPayoutDate; // Nullable field

  Equb({
    required this.id,
    required this.name,
    required this.totalAmount,
    required this.contributionPerUser,
    required this.frequency,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.participants,
    this.nextPayoutDate, // Nullable field
  });

  factory Equb.fromJson(Map<String, dynamic> json) {
    return Equb(
      id: json['_id'] ?? 'Unknown ID',  // Default if null
      name: json['name'] ?? 'Unknown Equb', // Default if null
      totalAmount: json['totalAmount'] ?? 0, // Default to 0 if null
      contributionPerUser: json['contributionPerUser'] ?? 0, // Default if null
      frequency: json['frequency'] ?? 'Unknown Frequency', // Default if null
      status: json['status'] ?? 'inactive', // Default to 'inactive' if null
      startDate: DateTime.parse(json['startDate'] ?? DateTime.now().toIso8601String()), // Default to current date if null
      endDate: DateTime.parse(json['endDate'] ?? DateTime.now().toIso8601String()), // Default to current date if null
      participants: json['participants'] ?? [], // Default to empty list if null
      nextPayoutDate: json['nextPayoutDate'], // Nullable field, no default required
    );
  }
}

