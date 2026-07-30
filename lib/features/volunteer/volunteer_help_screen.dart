import 'package:flutter/material.dart';

class VolunteerHelpScreen extends StatelessWidget {
  const VolunteerHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Frequently Asked Questions',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const ExpansionTile(
            title: Text('How do I log my hours?'),
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('You can log your hours by going to the Active Volunteering tab and clicking on "Check In / Log Hours".'),
              ),
            ],
          ),
          const ExpansionTile(
            title: Text('How do I earn certificates?'),
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Certificates are automatically awarded by NGOs upon successful completion of an opportunity.'),
              ),
            ],
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.email),
            label: const Text('Contact Support'),
          ),
        ],
      ),
    );
  }
}
