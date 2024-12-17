import 'package:flutter/material.dart';

// Notification model class
class NotificationItem {
  final String title;
  final String description;
  final DateTime date;

  NotificationItem({
    required this.title,
    required this.description,
    required this.date,
  });
}

class NotificationsPage extends StatelessWidget {
  // Sample notifications data
  final List<NotificationItem> notifications = [
    NotificationItem(
      title: 'New Message',
      description: 'You have a new message from John.',
      date: DateTime.now().subtract(Duration(minutes: 10)),
    ),
    NotificationItem(
      title: 'App Update Available',
      description: 'A new version of the app is available. Please update.',
      date: DateTime.now().subtract(Duration(hours: 1)),
    ),
    NotificationItem(
      title: 'Event Reminder',
      description: 'Don\'t forget the event tomorrow at 5 PM.',
      date: DateTime.now().subtract(Duration(days: 1)),
    ),
    NotificationItem(
      title: 'System Alert',
      description: 'Your password will expire in 3 days.',
      date: DateTime.now().subtract(Duration(days: 3)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications',
            style: TextStyle(color: Colors.white)), // Set the title text color
        backgroundColor: Color(0xFF005CFF),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return NotificationTile(notification: notification);
        },
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final NotificationItem notification;

  const NotificationTile({required this.notification});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      child: ListTile(
        contentPadding: EdgeInsets.all(15),
        title: Text(
          notification.title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.description,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            SizedBox(height: 5),
            Text(
              _formatDate(notification.date),
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to format the date
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}
