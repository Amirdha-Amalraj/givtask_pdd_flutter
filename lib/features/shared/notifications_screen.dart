import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All marked as read')),
              );
            },
            tooltip: 'Mark all as read',
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: 10,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final isUnread = index < 3;
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: isUnread ? Colors.green.shade100 : Colors.grey.shade200,
              child: Icon(
                index % 2 == 0 ? Icons.assignment_turned_in : Icons.message,
                color: isUnread ? Colors.green : Colors.grey,
              ),
            ),
            title: Text(
              index % 2 == 0 
                  ? 'Application Accepted!' 
                  : 'New Message from NGO',
              style: TextStyle(
                fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            subtitle: Text(
              'You have an update regarding your recent activity.',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isUnread ? Colors.black87 : Colors.grey.shade600,
              ),
            ),
            trailing: Text(
              '${index + 1}h ago',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
            ),
            tileColor: isUnread ? Colors.green.withOpacity(0.05) : null,
            onTap: () {
              // Handle tap
            },
          );
        },
      ),
    );
  }
}
