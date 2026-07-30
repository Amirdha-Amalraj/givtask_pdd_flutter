import 'package:flutter/material.dart';

class VolunteerMessagesScreen extends StatelessWidget {
  const VolunteerMessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_square),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 3, // Mock count
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: const Icon(Icons.business),
            ),
            title: const Text('Red Cross Society', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Thank you for your application...'),
            trailing: const Text('2h ago', style: TextStyle(color: Colors.grey, fontSize: 12)),
            onTap: () {
              // Navigate to conversation
            },
          );
        },
      ),
    );
  }
}
