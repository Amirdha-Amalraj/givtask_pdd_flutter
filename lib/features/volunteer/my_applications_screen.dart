import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'data/volunteer_providers.dart';
import 'package:intl/intl.dart';

class MyApplicationsScreen extends ConsumerWidget {
  const MyApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applicationsAsync = ref.watch(myApplicationsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Applications')),
      body: applicationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (applications) {
          if (applications.isEmpty) {
            return const Center(child: Text('You have not applied to any opportunities yet.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: applications.length,
            itemBuilder: (context, index) {
              final app = applications[index];
              final task = app.task;
              
              Color statusColor = Colors.grey;
              if (app.status == 'applied') statusColor = Colors.orange;
              if (app.status == 'accepted') statusColor = Colors.green;
              if (app.status == 'rejected') statusColor = Colors.red;
              
              String displayStatus = app.status ?? 'Unknown';
              if (displayStatus.isNotEmpty) {
                displayStatus = displayStatus[0].toUpperCase() + displayStatus.substring(1);
              }

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(task?.title ?? 'Unknown Task', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(task?.ngoName ?? 'Unknown NGO'),
                      const SizedBox(height: 8),
                      Text('Applied: ${app.appliedAt != null ? DateFormat.yMMMd().format(app.appliedAt!) : 'Unknown'}'),
                    ],
                  ),
                  trailing: Chip(
                    label: Text(displayStatus, style: const TextStyle(color: Colors.white)),
                    backgroundColor: statusColor,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
