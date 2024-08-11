import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotificationList extends StatelessWidget {
  final bool sortBySeen;
  final String userId;

  NotificationList({required this.sortBySeen, required this.userId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .orderBy(
            sortBySeen ? 'seen' : 'timestamp',
            descending: !sortBySeen,
          )
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No notifications yet.'));
        }

        final notifications = snapshot.data!.docs;

        return ListView.separated(
          itemCount: notifications.length,
          separatorBuilder: (context, index) => SizedBox(height: 10.0),
          itemBuilder: (context, index) {
            final notification =
                notifications[index].data() as Map<String, dynamic>;
            final docId = notifications[index].id;
            final seen = notification['seen'] ?? false;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: GestureDetector(
                onTap: () {
                  if (!seen) {
                    _markAsSeen(docId);
                  }
                },
                child: Container(
                  color: seen ? Colors.grey[200] : Colors.blue[100],
                  child: ListTile(
                    leading: Icon(
                      Icons.notifications,
                      color: seen ? Colors.grey : Colors.blue,
                    ),
                    title: Text(notification['title'] ?? 'No Title'),
                    subtitle: Text(notification['body'] ?? 'No Body'),
                    contentPadding: EdgeInsets.all(16.0),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _markAsSeen(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .doc(docId)
          .update({'seen': true});
    } catch (e) {
      print("Failed to mark notification as seen: $e");
    }
  }
}
