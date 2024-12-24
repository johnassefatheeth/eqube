import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';  // For MediaType class
import 'package:path/path.dart';  // To extract the file name from the path

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

  String _profilePictureUrl = ''; // Initially no image
  bool _isImagePicked = false;  // To track if an image is selected
  String _fileName = '';  // To store the file name of the selected image

  // Function to handle image picking (attachment of deposit slip)
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profilePictureUrl = pickedFile.path;  // Save the image path
        _isImagePicked = true;
        _fileName = basename(pickedFile.path);  // Extract the file name from the path
      });
    }
  }

  // Function to handle form submission
  Future<void> _submitDeposit(BuildContext context) async {
    if (_EqubId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your EqubId.')),
      );
      return;
    }

    if (!_isImagePicked) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please attach the deposit slip image.')),
      );
      return;
    }

    // Prepare the request data
    try {
      var uri = Uri.parse('http://localhost:5000/api/users/join-request');
      var request = http.MultipartRequest('POST', uri);

      // Attach the image
      var imageFile = await http.MultipartFile.fromPath(
        'receiptImage',  // This should match the field name expected by the backend (e.g., 'receiptImage')
        _profilePictureUrl,
        contentType: MediaType('image', 'jpeg'),  // You can adjust the MIME type if needed
      );
      request.files.add(imageFile);

      // Add other form data (like EqubId)
      request.fields['equbId'] = _EqubId;

      // Send the request to the server
      var response = await request.send();

      // Handle the response
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Your deposit request has been submitted!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit deposit request.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
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
        title: Text('Deposit Payment', style: TextStyle(color: Colors.white)),
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

            // Attach Slip Image (File Name Display)
            Text('Attach Deposit Slip (image)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Center(
              child: Stack(
                children: [
                  // If an image is picked, display the file name; otherwise, show a placeholder
                  _isImagePicked
                      ? Text(
                          _fileName,  // Display the file name here
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey,
                          ),
                        )
                      : Text(
                          'No image selected',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey,
                          ),
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
                onPressed: () => _submitDeposit(context),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  child: Text('Submit', style: TextStyle(color: Colors.white, fontSize: 16)),
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
