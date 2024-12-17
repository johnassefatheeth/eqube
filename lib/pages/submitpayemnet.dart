import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';  // Required for File class to handle images

class DepositPage extends StatefulWidget {
  final String EqubId; // Accept the EqubId as a parameter

  // Constructor to accept the EqubId
  DepositPage({required this.EqubId});

  @override
  _DepositPageState createState() => _DepositPageState();
}

class _DepositPageState extends State<DepositPage> {
  late String _depositAmount;
  late String _selectedBank;
  late String _slipImage;
  late String _EqubId;  // Store the passed EqubId

  String _profilePictureUrl =
      'https://via.placeholder.com/150'; // Default placeholder for slip image

  bool _isImagePicked = false;  // To track if an image is selected

  // Function to handle image picking (attachment of deposit slip)
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profilePictureUrl = pickedFile.path;
        _isImagePicked = true;
      });
    }
  }

  // Function to handle form submission
  void _submitDeposit() {
    if (_EqubId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your user ID.')),
      );
      return;
    }

    if (!_isImagePicked) {
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
    _EqubId = widget.EqubId; // Get the passed EqubId
    _depositAmount = "500";  // This is the dynamic amount, can be set as needed
    _selectedBank = "Comercial Bank of Ethiopia"; // Example Bank name, can be dynamic
    _slipImage = ""; // Initially no image attached
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deposit Payment'),
        backgroundColor: Color(0xFF005CFF),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Section
            Text(
              'Deposit Payment Instructions',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF005CFF),
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(height: 15),

            // Dynamic deposit amount
            Text(
              'Please deposit the $_depositAmount Birr in one of the following payment methods:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '# Comercial Bank of Ethiopia\n1000072610613\n\n'
              '# Abisinya Bank\n177020842\n\n'
              '# Awash Bank\nEdget Equb 013201305396900\n\n',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.blueGrey[800],
              ),
            ),
            SizedBox(height: 20),

            // Instructions to attach slip
            Text(
              'And attach a screenshot or a picture of the deposit slip so that your request can be processed.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 25),

            // Display the passed EqubId
            Text(
              'User ID: $_EqubId',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10),

            // Attach Slip Image
            Text('Attach Deposit Slip (image)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
