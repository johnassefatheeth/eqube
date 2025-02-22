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
  late AuthProvider authProvider;

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _subCityController = TextEditingController();
  final TextEditingController _weredaController = TextEditingController();

  String _gender = 'Male';
  bool _isLoading = true;

  Future<void> _fetchUserData() async {
    final url = 'http://localhost:8080/api/users/user-data';
    String? token = authProvider.token;

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final user = data['user'];

        setState(() {
          _fullNameController.text = user['name'];
          _emailController.text = user['email'];
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

  Future<void> _changeProfile() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    String? token = authProvider.token;

    try {
      final response = await http.put(
        Uri.parse('http://localhost:8080/api/users/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name': _fullNameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
          'gender': _gender,
          'city': _cityController.text,
          'subCity': _subCityController.text,
          'woreda': _weredaController.text,
        }),
      );

      Navigator.pop(context);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully!')));
      } else {
        final responseBody = json.decode(response.body);
        String message = responseBody['message'] ?? 'Error updating profile';
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      }
    } catch (error) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Failed to update profile. Please try again.')));
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    authProvider = Provider.of<AuthProvider>(context);
    if (_isLoading) {
      _fetchUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // Personal Info
            const Text('Personal Information',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            TextField(
              controller: _fullNameController,
              decoration: const InputDecoration(
                hintText: 'Full Name',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              ),
            ),
            const SizedBox(height: 10),

            // Gender
            const Text('Gender',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            DropdownButtonFormField<String>(
              value: _gender,
              onChanged: (newValue) {
                setState(() {
                  _gender = newValue!;
                });
              },
              items: ['Male', 'Female']
                  .map((gender) =>
                      DropdownMenuItem(value: gender, child: Text(gender)))
                  .toList(),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              ),
            ),
            const SizedBox(height: 20),

            // Contact Information
            const Text('Contact Information',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: 'Email',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                hintText: 'Phone Number',
                enabled: false,
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                suffixIcon: Icon(Icons.phone, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 20),

            // Location Details
            const Text('Location Details',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(
                hintText: 'City',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _subCityController,
              decoration: const InputDecoration(
                hintText: 'Sub-city',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _weredaController,
              decoration: const InputDecoration(
                hintText: 'Wereda',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              ),
            ),
            const SizedBox(height: 20),

            // Save Changes Button
            Center(
              child: ElevatedButton(
                onPressed: _changeProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF005CFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  child: Text('Save Changes',
                      style: TextStyle(color: Colors.white, fontSize: 14)),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Logout Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  authProvider.setToken('');
                  Navigator.pushReplacementNamed(context, '/signin');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF005CFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  child: Text('Log out',
                      style: TextStyle(color: Colors.white, fontSize: 14)),
                ),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
