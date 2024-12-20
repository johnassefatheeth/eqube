import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';  // For MediaType class
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb; // To check platform
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:http/http.dart' as http;
import 'package:html/html.dart' as html;

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

  // Function to handle image picking (attachment of deposit slip)
  Future<void> _pickImage() async {
    if (kIsWeb) {
      // For Flutter Web: Use html package to select a file
      final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
      uploadInput.accept = 'image/*';
      uploadInput.click();

      uploadInput.onChange.listen((e) async {
        final files = uploadInput.files;
        if (files!.isEmpty) return;
        final reader = html.FileReader();
        reader.readAsArrayBuffer(files[0]!);
        reader.onLoadEnd.listen((e) async {
          final bytes = reader.result as Uint8List;
          setState(() {
            _profilePictureUrl = 'data:image/jpeg;base64,' + base64Encode(bytes);
            _isImagePicked = true;
          });
        });
      });
    } else {
      // For Mobile: Use ImagePicker to get the image
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _profilePictureUrl = pickedFile.path;
          _isImagePicked = true;
        });
      }
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
      if (kIsWeb) {
        // For Flutter Web: Attach the image as a byte array
        final imageFile = http.MultipartFile.fromBytes(
          'receiptImage', 
          base64Decode(_profilePictureUrl.split(',')[1]), 
          contentType: MediaType('image', 'jpeg'),
        );
        request.files.add(imageFile);
      } else {
        // For Mobile: Attach the image from file path
        var imageFile = await http.MultipartFile.fromPath(
          'receiptImage', 
          _profilePictureUrl, 
          contentType: MediaType('image', 'jpeg')
        );
        request.files.add(imageFile);
      }

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

            // Attach Slip Image
            Text('Attach Deposit Slip (image)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Center(
              child: Stack(
                children: [
                  // Displaying the image if picked, otherwise showing a placeholder
                  _isImagePicked
                      ? ClipOval(
                          child: kIsWeb
                              ? Image.memory(
                                  base64Decode(_profilePictureUrl.split(',')[1]),
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                )
                              : Image.file(
                                  File(_profilePictureUrl),
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                        )
                      : Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 40,
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
