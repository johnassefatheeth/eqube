import 'package:ekube/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late AuthProvider authProvider; // Declare but don't initialize yet

  // Define text controllers
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _subCityController = TextEditingController();
  final TextEditingController _weredaController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String _gender = 'Male'; // Default gender

  bool _isLoading = true;

 

  // Function to fetch user data from API
  Future<void> _fetchUserData() async {
    final url = 'http://localhost:8080/api/users/user-data';
    String? token = authProvider.token;  // Get the token from authProvider

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final user = data['user'];

        setState(() {
          _fullNameController.text = user['name'];
          _phoneController.text = user['phone'];
          _cityController.text = user['city'];
          _subCityController.text = user['subCity'];
          _weredaController.text = user['woreda'].toString();
          _gender = user['gender'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _changePassword() async {
    
    

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );
    String? token = authProvider.token;

    try {
      // Make API call to change password
      final response = await http.put(
        Uri.parse('http://localhost:8080/api/users/profile'), // Use the correct endpoint here
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name':_fullNameController.text,
          'phone':_phoneController.text,
          'gender':_gender,
          'city':_cityController.text,
          'subCity':_subCityController.text,
          'woreda':_weredaController.text,
        }),
      );

      Navigator.pop(context); // Close the loading indicator

      if (response.statusCode == 200) {
        // Success response
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Password changed successfully!')));
      } else {
        // Handle errors from backend
        final responseBody = json.decode(response.body);
        String message = responseBody['message'] ?? 'Error changing password';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      }
    } catch (error) {
      Navigator.pop(context); // Close the loading indicator
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to change password. Please try again.')));
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize authProvider in didChangeDependencies instead of initState
    authProvider = Provider.of<AuthProvider>(context);
    // Fetch user data when dependencies are ready
    if (_isLoading) {
      _fetchUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        extendBody: true,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            SizedBox(height: 10),

            // Full Name
            Text('Full Name', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            TextField(
              controller: _fullNameController,
              decoration: InputDecoration(
                hintText: 'Enter your full name',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
            ),
            SizedBox(height: 20),

            // Gender
            Text('Gender', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            DropdownButtonFormField<String>(
              value: _gender,
              onChanged: (newValue) {
                setState(() {
                  _gender = newValue!;
                });
              },
              items: ['Male', 'Female']
                  .map((gender) => DropdownMenuItem(
                        value: gender,
                        child: Text(gender),
                      ))
                  .toList(),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                enabled: false
              ),
            ),
            SizedBox(height: 20),

            // Phone Number (non-editable)
            Text('Phone Number', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                hintText: 'Phone number',
                enabled: false,
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                suffixIcon: Icon(Icons.phone, color: Colors.grey),
              ),
            ),
            SizedBox(height: 20),

            // Location (City, Sub-city, Wereda)
            Text('Location Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                hintText: 'City',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _subCityController,
              decoration: InputDecoration(
                hintText: 'Sub-city',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _weredaController,
              decoration: InputDecoration(
                hintText: 'Wereda',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
            ),
            SizedBox(height: 20),

            // Save Changes Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Here you can save the changes (e.g., send to server)
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Profile updated successfully!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF005CFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  child: Text('Save Changes', style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Logged out succesfuly successfully!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF005CFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  child: Text('Log out', style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ),
            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
