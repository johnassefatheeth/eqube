import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SetEqubDetailsPage extends StatelessWidget {
  final String equbType;

  // Constructor to accept the Equb type
  SetEqubDetailsPage({required this.equbType});

  @override
  Widget build(BuildContext context) {
    // Define options based on the Equb type
    List<int> amounts;
    List<int> peopleCount;

    if (equbType == 'Daily') {
      amounts = [100, 300, 500, 1000];
      peopleCount = [10, 20, 18, 8];
    } else if (equbType == 'Weekly') {
      amounts = [500, 1000, 1500, 2000];
      peopleCount = [41, 25, 34, 20];
    } else {  // Monthly
      amounts = [1500, 2000, 3500, 5000, 10000];
      peopleCount = [10, 20, 18, 8, 12];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('$equbType Equb Options',
            style: TextStyle(color: Colors.white)), // Set the title text color
        backgroundColor: Color(0xFF005CFF),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: amounts.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text('${amounts[index]} Birr'),
                subtitle: Text('People: ${peopleCount[index]}'),
                trailing: ElevatedButton.icon(
                  onPressed: () {
                    // Show the join Equb popup
                    showDialog(
                      context: context,
                      builder: (context) => _showJoinEqubDialog(context),
                    );
                  },
                  icon: Icon(Icons.add),
                  label: Text('Join Equb'),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Popup for joining the Equb
  Widget _showJoinEqubDialog(BuildContext context) {
    return JoinEqubDialog();
  }
}

class JoinEqubDialog extends StatefulWidget {
  @override
  _JoinEqubDialogState createState() => _JoinEqubDialogState();
}

class _JoinEqubDialogState extends State<JoinEqubDialog> {
  bool _isChecked = false; // Track checkbox state

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Join Equb'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('If you wish to join this Equb, please read and agree to the terms and conditions.'),
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
                    style: DefaultTextStyle.of(context).style,
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
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isChecked ? () {
            // Logic for joining the Equb can go here
            Navigator.pop(context); // Close the dialog
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('You have joined the Equb!')),
            );
          } : null, // Only enable if the checkbox is checked
          child: Text('Join'),
        ),
      ],
    );
  }

  // Dialog for displaying the terms and conditions
  Widget _showTermsDialog(BuildContext context) {
    return AlertDialog(
      title: Text('Terms and Conditions'),
      content: SingleChildScrollView(
        child: Text(
          ''''Terms and Conditions
Effective Date: [Date]

Welcome to Ekube! These Terms and Conditions govern your use of the Ekube mobile application ("App") and its services, including, but not limited to, creating, participating in, and managing Equbs (rotating savings and credit associations). By using the App, you agree to be bound by these Terms and Conditions, as well as any other applicable policies or rules that govern your use of the App. If you do not agree to these terms, please do not use the App.

1. Acceptance of Terms
By accessing or using the Ekube App, you agree to comply with and be bound by these Terms and Conditions. If you are using the App on behalf of an organization or entity, you represent and warrant that you have the authority to bind that organization to these terms.

2. Eligibility
You must be at least 18 years old to use the App and participate in an Equb. By agreeing to these Terms, you represent and warrant that you are 18 years of age or older, or you have obtained consent from a parent or legal guardian to use this App.

3. Registration and Account
To use the full features of the Ekube App, you must create an account. You agree to provide accurate, current, and complete information during the registration process. You are responsible for maintaining the confidentiality of your account and password, and you agree to notify us immediately of any unauthorized access to your account.

4. Equb Participation
The Ekube App allows you to create or join Equbs with other participants. An Equb is a group savings and credit system where participants contribute money on a regular basis, and each participant receives a lump sum amount in turn. Participation in an Equb is voluntary, and by joining an Equb, you agree to the following:

You will contribute a fixed amount of money on a regular schedule.
You will receive the total collected amount at a designated time as per the Equb agreement.
You will comply with the rules and terms set by the Equb organizer and other participants.
Participation in an Equb is subject to the availability of spaces in the group, and you acknowledge that the number of participants in each Equb may vary.

5. Payment and Contributions
By participating in an Equb, you authorize the App to process your contributions, which may be made via bank transfer, mobile money, or other payment methods supported by the App. All contributions must be paid on time to ensure the proper functioning of the Equb. The amount you contribute is based on the type of Equb (e.g., daily, weekly, monthly) and the available options within the app.

6. Responsibilities of Participants
Each participant in the Equb is expected to:

Pay their contributions on time.
Abide by the agreed-upon schedule and rules for the Equb.
Respect other participants and the Equb organizer.
Failure to meet your obligations may result in your removal from the Equb, and you may lose the opportunity to participate in future Equbs.

7. Equb Organizer and Administration
The Equb organizer is responsible for managing the Equb, including setting the rules, ensuring timely contributions, and distributing the lump sum amounts to the participants. The organizer must ensure transparency and fairness in the process. However, the Ekube App is not responsible for disputes that may arise between participants or between participants and the organizer.

8. Data Privacy and Security
Your personal data, including payment details, will be handled in accordance with our Privacy Policy. By using the App, you consent to the collection, use, and sharing of your data as described in the Privacy Policy. We take appropriate technical and organizational measures to protect your personal data, but we cannot guarantee absolute security.

9. Fees
The Ekube App may charge a service fee for using certain features, such as creating or managing an Equb. These fees will be disclosed to you before you proceed with any transaction, and you agree to pay any applicable fees as part of your participation.

10. Terminations and Suspensions
We reserve the right to suspend or terminate your account if you violate these Terms and Conditions, engage in fraudulent or illegal activity, or abuse the features of the App. In the event of termination, you may lose access to your account, and any uncollected contributions may be forfeited.

11. Dispute Resolution
In case of any disputes between participants, or between participants and the app, you agree to resolve the matter amicably. If a resolution cannot be reached, disputes will be settled through arbitration or in a court of law based on the applicable laws in the jurisdiction where the app is registered.

12. Changes to Terms
Ekube reserves the right to modify these Terms and Conditions at any time. Any changes will be posted on this page, and the "Effective Date" will be updated. You are responsible for regularly reviewing these Terms. Continued use of the App after changes have been posted constitutes your acceptance of the updated Terms.

13. Limitation of Liability
Ekube and its affiliates are not liable for any damages, losses, or issues that may arise from the use of the App, including financial losses, disputes between participants, or technical failures. You acknowledge that participating in an Equb carries inherent risks, and you agree to participate at your own risk.

14. Indemnification
You agree to indemnify and hold Ekube and its affiliates, directors, employees, and agents harmless from any claims, damages, liabilities, or costs (including legal fees) arising from your use of the App, your participation in any Equb, or your violation of these Terms and Conditions.

15. Third-Party Links
The App may contain links to third-party websites or services that are not owned or controlled by Ekube. We are not responsible for the content, privacy policies, or practices of third-party websites. You agree that Ekube shall not be liable for any damages or losses incurred due to your interactions with third-party websites or services.

16. Governing Law
These Terms and Conditions are governed by and construed in accordance with the laws of [Your Country/Region]. Any disputes or legal proceedings arising out of or related to these Terms shall be subject to the exclusive jurisdiction of the courts located in [Your Jurisdiction].

17. Contact Us
If you have any questions or concerns about these Terms and Conditions, please contact us at:

Ekube Support
Email: [support@ekubeapp.com]
Phone: [Your Contact Number]''''',
          style: TextStyle(fontSize: 16),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close the terms and conditions dialog
          },
          child: Text('Close'),
        ),
      ],
    );
  }
}
