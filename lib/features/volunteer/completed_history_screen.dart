import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'data/volunteer_providers.dart';

class CompletedHistoryScreen extends ConsumerWidget {
  const CompletedHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completedTasksAsync = ref.watch(completedTasksProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Completed Tasks')),
      body: completedTasksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (applications) {
          if (applications.isEmpty) {
            return const Center(
              child: Text('You have not completed any tasks yet.'),
            );
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              task?.title ?? 'Unknown Task',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Icon(Icons.verified, color: Colors.green),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(task?.ngoName ?? 'Unknown NGO'),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(Icons.timer, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text('${task?.volunteerHours ?? 0} Hours Earned', style: const TextStyle(color: Colors.grey)),
                          const SizedBox(width: 16),
                          const Icon(Icons.date_range, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            app.updatedAt != null ? DateFormat.yMMMd().format(app.updatedAt!) : 'Unknown Date',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
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
