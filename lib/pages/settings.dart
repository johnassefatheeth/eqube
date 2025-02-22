import 'package:ekube/pages/changepass.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = false;
  String _selectedLanguage = 'English'; // Default Language

  // Function to toggle Dark Mode
  void _toggleDarkMode(bool value) {
    setState(() {
      _isDarkMode = value;
    });
  }

  // Function to change language
  void _changeLanguage(String? newValue) {
    setState(() {
      _selectedLanguage = newValue ?? 'English';
    });
    // You can add logic to switch the app's language here using a package like `flutter_localizations` or `easy_localization`.
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          // Dark Mode Toggle
          ListTile(
            title: Text('Dark Mode', style: TextStyle(fontSize: 18)),
            trailing: Switch(
              value: _isDarkMode,
              onChanged: _toggleDarkMode,
              activeColor: Colors.orange,
            ),
          ),
          Divider(),

          // Language Selection Dropdown
          ListTile(
            title: Text('Change Language', style: TextStyle(fontSize: 18)),
            trailing: DropdownButton<String>(
              value: _selectedLanguage,
              items: ['English', 'Amharic']
                  .map((lang) => DropdownMenuItem<String>(
                        value: lang,
                        child: Text(lang),
                      ))
                  .toList(),
              onChanged: _changeLanguage,
            ),
          ),
          Divider(),

          // Change Password as a ListTile
          ListTile(
            title: Text('Change Password', style: TextStyle(fontSize: 18)),
            trailing: Icon(Icons.lock, color: Colors.blue),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChangePasswordPage()),
              );
            },
          ),
        ],
      ),
    ),
  );
}

}

