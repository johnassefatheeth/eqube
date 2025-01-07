import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';  // For MediaType class
import 'package:path/path.dart';  // To extract the file name from the path
import 'package:flutter/foundation.dart'; // for kIsWeb
import 'dart:html' as html;  // for web support
import 'package:ekube/providers/auth_provider.dart';

class DepositPage extends StatefulWidget {
  final String EqubId; 
  final int amount; 

  // Constructor to accept the EqubId
  DepositPage({required this.EqubId,required this.amount});

  @override
  _DepositPageState createState() => _DepositPageState();
}

class _DepositPageState extends State<DepositPage> {
  late int _depositAmount;
  late String _EqubId; 
  late AuthProvider authProvider;

  String _profilePictureUrl = ''; // Initially no image
  bool _isImagePicked = false;  // To track if an image is selected
  String _fileName = '';  // To store the file name of the selected image

    @override
    void didChangeDependencies() {
    super.didChangeDependencies();
    _EqubId = widget.EqubId;  // Get the passed EqubId
    _depositAmount = widget.amount;  // This is the dynamic amount, can be set as needed
  }

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

  Future<void> _submitDeposit(context) async {
    String? token = authProvider.token;

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

    try {
      if (kIsWeb) {
        final html.File imageFile = html.File(
          [html.Blob([await html.HttpRequest.getString(_profilePictureUrl)])], 
          _fileName,
          {'type': 'image/jpeg'}
        );

        var formData = html.FormData();
        formData.appendBlob('receiptImage', imageFile);

        formData.append('equbId', _EqubId);

        var xhr = html.HttpRequest();
        xhr.open('POST', 'http://localhost:8080/api/users/join-request');
        xhr.setRequestHeader('Authorization', 'Bearer $token');
        xhr.send(formData);

        xhr.onLoadEnd.listen((event) {
          if (xhr.status == 200) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Your deposit request has been submitted!')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to submit deposit request. Status code: ${xhr.status}')),
            );
          }
        });
      } else {
        var uri = Uri.parse('http://localhost:5000/api/users/join-request');
        var request = http.MultipartRequest('POST', uri);

        var imageFile = await http.MultipartFile.fromPath(
          'receiptImage',
          _profilePictureUrl,
          contentType: MediaType('image', 'jpeg'),
        );
        request.files.add(imageFile);

        request.fields['equbId'] = _EqubId;
        request.headers['Authorization'] = 'Bearer $token';

        var response = await request.send();

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Your deposit request has been submitted!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to submit deposit request. Status code: ${response.statusCode}')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
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
            Text(
              'Please deposit the $_depositAmount Birr in one of the following payment methods:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10),

            // Displaying bank names and images
            Column(
              children: [
                _buildBankRow('Comercial Bank of Ethiopia', 'images/cbe.png'),
                _buildBankRow('Abisinya Bank', 'images/abbisiniya_bank.png'),
                _buildBankRow('Awash Bank', 'images/awash.png'),
              ],
            ),
            SizedBox(height: 20),

            Text(
              'And attach a screenshot or a picture of the deposit slip so that your request can be processed.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 25),

            Text('Attach Deposit Slip (image)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Center(
              child: Stack(
                children: [
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

            Center(
              child: ElevatedButton(
                onPressed: () => _submitDeposit(context),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  child: Text(
                    'Submit Deposit Request',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF005CFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build a Row for each bank
  Widget _buildBankRow(String bankName, String imagePath) {
    return Row(
      children: [
        Image.asset(
          imagePath,
          width: 40,  // Set the width of the image
          height: 40, // Set the height of the image
        ),
        SizedBox(width: 10),  // Space between the image and text
        Expanded(
          child: Text(
            bankName,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.blueGrey[800],
            ),
          ),
        ),
      ],
    );
  }
}
