import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'data/volunteer_providers.dart';

class VolunteerSavedScreen extends ConsumerWidget {
  const VolunteerSavedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedTasksAsync = ref.watch(savedTasksProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Saved Opportunities')),
      body: savedTasksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (savedTasks) {
          if (savedTasks.isEmpty) {
            return const Center(child: Text('No saved opportunities.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: savedTasks.length,
            itemBuilder: (context, index) {
              final task = savedTasks[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(task.title ?? 'Untitled Task', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(task.ngoName ?? 'Unknown NGO'),
                  trailing: IconButton(
                    icon: const Icon(Icons.bookmark, color: Colors.blue),
                    onPressed: () {
                      // Remove from saved
                      ref.read(volunteerRepositoryProvider).unsaveTask(task.id);
                      ref.invalidate(savedTasksProvider);
                    },
                  ),
                  onTap: () {
                    // Navigate to details
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
