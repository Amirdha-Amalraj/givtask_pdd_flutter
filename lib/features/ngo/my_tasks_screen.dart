import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'data/ngo_providers.dart';
import 'data/ngo_repository.dart';

class MyTasksScreen extends ConsumerWidget {
  const MyTasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(ngoTasksProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Create New Task',
            onPressed: () => context.push('/create-task-type'),
          ),
        ],
      ),
      body: tasksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error loading tasks: $err')),
        data: (tasks) {
          if (tasks.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.assignment_outlined, size: 64, color: theme.disabledColor),
                  Text('No tasks created yet', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.push('/create-task-type'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    child: const Text('Create Task'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(task.title ?? 'Untitled', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${task.category ?? 'General'} • ${task.location ?? 'Remote'}'),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Chip(
                              label: Text(_getDisplayStatus(task.status ?? 'open'), style: const TextStyle(fontSize: 12)),
                              backgroundColor: _getStatusColor(task.status ?? 'open').withAlpha(30),
                              side: BorderSide.none,
                            ),
                            const SizedBox(width: 8),
                            if ((task.budget ?? 0) > 0 || (task.rate ?? 0) > 0)
                              const Chip(
                                label: Text('Paid', style: TextStyle(fontSize: 12, color: Colors.green)),
                                backgroundColor: Color(0x334CAF50),
                                side: BorderSide.none,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == 'edit') {
                        context.push('/create-task-details?id=${task.id}');
                      } else if (value == 'view_applications') {
                        context.push('/applicants-list?taskId=${task.id}');
                      } else if (value == 'publish' || value == 'archive') {
                        final newStatus = value == 'publish' ? 'open' : 'closed';
                        await ref.read(ngoRepositoryProvider).updateTask(task.id, {'status': newStatus});
                        ref.invalidate(ngoTasksProvider);
                      } else if (value == 'delete') {
                        await ref.read(ngoRepositoryProvider).deleteTask(task.id);
                        ref.invalidate(ngoTasksProvider);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'edit', child: Text('Edit')),
                      const PopupMenuItem(value: 'view_applications', child: Text('View Applications')),
                      if (task.status != 'open')
                        const PopupMenuItem(value: 'publish', child: Text('Publish')),
                      if (task.status != 'closed')
                        const PopupMenuItem(value: 'archive', child: Text('Archive')),
                      const PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: Colors.red))),
                    ],
                  ),
                  onTap: () {
                    context.push('/applicants-list?taskId=${task.id}');
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'open': return Colors.green;
      case 'in_progress': return Colors.orange;
      case 'closed': return Colors.grey;
      case 'completed': return Colors.blue;
      default: return Colors.grey;
    }
  }

  String _getDisplayStatus(String status) {
    switch (status) {
      case 'open': return 'Published';
      case 'in_progress': return 'In Progress';
      case 'closed': return 'Archived';
      case 'completed': return 'Completed';
      default: return 'Unknown';
    }
  }
}
