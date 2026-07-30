import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'data/ngo_providers.dart';

class ApplicantsListScreen extends ConsumerStatefulWidget {
  final String? taskId;
  const ApplicantsListScreen({super.key, this.taskId});

  @override
  ConsumerState<ApplicantsListScreen> createState() => _ApplicantsListScreenState();
}

class _ApplicantsListScreenState extends ConsumerState<ApplicantsListScreen> {
  String _filterStatus = 'All';

  @override
  Widget build(BuildContext context) {
    final appsAsync = ref.watch(ngoApplicationsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Applications'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (val) => setState(() => _filterStatus = val),
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'All', child: Text('All')),
              PopupMenuItem(value: 'applied', child: Text('Applied')),
              PopupMenuItem(value: 'accepted', child: Text('Accepted')),
              PopupMenuItem(value: 'rejected', child: Text('Rejected')),
              PopupMenuItem(value: 'completed', child: Text('Completed')),
            ],
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      body: appsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (applications) {
          var filtered = applications;
          if (widget.taskId != null) {
            filtered = filtered.where((a) => a.taskId == widget.taskId).toList();
          }
          if (_filterStatus != 'All') {
            filtered = filtered.where((a) => a.status == _filterStatus).toList();
          }

          if (filtered.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.inbox_outlined, size: 64, color: theme.disabledColor),
                  const SizedBox(height: 16),
                  Text('No applications found.', style: theme.textTheme.titleMedium),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final app = filtered[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor: theme.colorScheme.primaryContainer,
                    child: const Icon(Icons.person),
                  ),
                  title: const Text('Applicant', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Task ID: ${app.taskId}'),
                        const SizedBox(height: 8),
                        Chip(
                          label: Text(app.status ?? 'applied', style: const TextStyle(fontSize: 12)),
                          backgroundColor: _getStatusColor(app.status ?? 'applied').withAlpha(30),
                          side: BorderSide.none,
                        ),
                      ],
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    context.push('/application-review?id=${app.id}');
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
      case 'accepted': return Colors.green;
      case 'applied': return Colors.orange;
      case 'rejected': return Colors.red;
      case 'completed': return Colors.blue;
      default: return Colors.grey;
    }
  }
}
