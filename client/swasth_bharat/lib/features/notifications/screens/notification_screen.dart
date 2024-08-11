import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widgets/notification_list.dart';
import '../widgets/sort_button.dart';

class NotificationScreen extends StatefulWidget {
  static const String routeName =
      '/notifications'; // Define a route name for the screen

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool _sortBySeen = false;
  final String _staticUserId =
      'staticUserId123'; // Use a static or dynamic user ID as needed

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        actions: [
          SortButton(
            sortBySeen: _sortBySeen,
            onSortChanged: (bool value) {
              setState(() {
                _sortBySeen = value;
              });
            },
          ),
        ],
      ),
      body: NotificationList(
        sortBySeen: _sortBySeen,
        userId: _staticUserId,
      ),
    );
  }
}
