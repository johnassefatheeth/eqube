import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DepositPage extends StatefulWidget {
  @override
  _DepositPageState createState() => _DepositPageState();
}

class _DepositPageState extends State<DepositPage> {
  late String _depositAmount;
  late String _selectedBank;
  late String _slipImage;

  // Initialize the slip image (will be set after image selection)
  String _profilePictureUrl =
      'https://via.placeholder.com/150'; // Default placeholder for slip image

  // Function to handle image picking (attachment of deposit slip)
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profilePictureUrl = pickedFile.path;
      });
    }
  }

  // Function to handle form submission
  void _submitDeposit() {
    if (_profilePictureUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please attach the deposit slip image.')),
      );
      return;
    }

    // Submit the deposit request here (send to the server)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Your deposit request has been submitted!')),
    );
  }

  @override
  void initState() {
    super.initState();
    _depositAmount = "500";  // This is the dynamic amount, can be set as needed
    _selectedBank = "Comercial Bank of Ethiopia"; // Example Bank name, can be dynamic
    _slipImage = ""; // Initially no image attached
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deposit Payment',
        style: TextStyle(
          color: Colors.white
        ),),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF005CFF),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Deposit Instructions
            Text(
              'Please deposit the $_depositAmount Birr in one of the following payment methods:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '# Comercial Bank of Ethiopia\n1000072610613\n\n# Abisinya Bank\n177020842\n\n# Awash Bank\nEdget Equb 013201305396900\n\n',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),

            // Instructions for attaching slip
            Text(
              'And attach a screenshot or a picture of the deposit slip so that your request can be processed.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),

            // Attach Slip Image
            Text('Attach Slip (image)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: FileImage(File(_profilePictureUrl)),
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

            // Submit Button
            Center(
              child: ElevatedButton(
                onPressed: _submitDeposit,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  child: Text('Submit', style: TextStyle(fontSize: 16)),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF005CFF),
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
