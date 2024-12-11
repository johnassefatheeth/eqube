import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Define text controllers
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _subCityController = TextEditingController();
  TextEditingController _weredaController = TextEditingController();

  // Default data for the profile (to simulate existing user data)
  String _profilePictureUrl =
      'https://via.placeholder.com/150'; // Default profile picture
  String _phoneNumber = '0912345678'; // Non-editable phone number
  String _gender = 'Male'; // Default gender
  String _location = 'Addis Ababa'; // Default location

  // Function to handle image picking (profile picture)
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profilePictureUrl = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture Section
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(_profilePictureUrl),
                    backgroundColor: Colors.grey[300],
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      icon: Icon(Icons.camera_alt, color: Colors.white),
                      onPressed: _pickImage,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

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
              ),
            ),
            SizedBox(height: 20),

            // Phone Number (non-editable)
            Text('Phone Number', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            TextField(
              controller: TextEditingController(text: _phoneNumber),
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
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  child: Text('Save Changes', style: TextStyle(fontSize: 16)),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
