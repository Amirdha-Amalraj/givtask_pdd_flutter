import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'data/volunteer_providers.dart';

class MyActiveTasksScreen extends ConsumerWidget {
  const MyActiveTasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTasksAsync = ref.watch(myActiveTasksProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Active Volunteering')),
      body: activeTasksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (applications) {
          if (applications.isEmpty) {
            return const Center(child: Text('No active volunteering tasks at the moment.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: applications.length,
            itemBuilder: (context, index) {
              final app = applications[index];
              final task = app.task;

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task?.title ?? 'Unknown Task',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(task?.ngoName ?? 'Unknown NGO'),
                      const SizedBox(height: 16),
                      LinearProgressIndicator(
                        value: 0.5, // Mock progress
                        backgroundColor: Colors.grey[200],
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 8),
                      const Text('Task Progress: 50%'),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: FilledButton(
                          onPressed: () {
                            // Check in or submit milestone
                          },
                          child: const Text('Check In / Log Hours'),
                        ),
                      ),
                    ],
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
