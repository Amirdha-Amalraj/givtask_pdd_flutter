import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'data/ngo_providers.dart';
import 'data/ngo_repository.dart';

class ApplicationReviewScreen extends ConsumerStatefulWidget {
  final String? applicationId;
  const ApplicationReviewScreen({super.key, this.applicationId});

  @override
  ConsumerState<ApplicationReviewScreen> createState() => _ApplicationReviewScreenState();
}

class _ApplicationReviewScreenState extends ConsumerState<ApplicationReviewScreen> {
  bool _isSaving = false;

  Future<void> _updateStatus(String status, String applicantId, String taskTitle) async {
    if (widget.applicationId == null) return;
    
    setState(() => _isSaving = true);
    try {
      await ref.read(ngoRepositoryProvider).updateApplicationStatus(
        widget.applicationId!,
        status,
        applicantId,
        taskTitle,
      );
      ref.invalidate(ngoApplicationsProvider);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Application $status successfully.')));
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.applicationId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Application Review')),
        body: const Center(child: Text('Invalid Application ID')),
      );
    }

    final appsAsync = ref.watch(ngoApplicationsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Application Review')),
      body: appsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (applications) {
          final app = applications.where((a) => a.id == widget.applicationId).firstOrNull;
          if (app == null) return const Center(child: Text('Application not found.'));

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: theme.colorScheme.primaryContainer,
                    child: const Icon(Icons.person, size: 30),
                  ),
                  title: Text('Applicant ID: ${app.applicantId}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Task ID: ${app.taskId}'),
                ),
                const SizedBox(height: 24),
                const Text('Cover Letter / Note', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest.withAlpha(50),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(app.coverNote ?? 'No cover letter provided.'),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Current Status:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Chip(
                      label: Text(app.status ?? 'applied', style: const TextStyle(fontWeight: FontWeight.bold)),
                      backgroundColor: _getStatusColor(app.status ?? 'applied').withAlpha(40),
                      side: BorderSide.none,
                    ),
                  ],
                ),
                const SizedBox(height: 48),
                if (_isSaving)
                  const Center(child: CircularProgressIndicator())
                else if (app.status == 'applied')
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                        onPressed: () => _updateStatus('accepted', app.applicantId, 'Task ${app.taskId}'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                        child: const Text('Accept Applicant'),
                      ),
                      const SizedBox(height: 16),
                      if (app.status == 'applied') ...[
                        OutlinedButton(
                          // TODO: Future enhancement. Shortlist is not currently supported in DB schema.
                          onPressed: null,
                          style: OutlinedButton.styleFrom(foregroundColor: Colors.purple),
                          child: const Text('Shortlist Applicant (Coming Soon)'),
                        ),
                        const SizedBox(height: 16),
                      ],
                      TextButton(
                        onPressed: () => _updateStatus('rejected', app.applicantId, 'Task ${app.taskId}'),
                        style: TextButton.styleFrom(foregroundColor: Colors.red),
                        child: const Text('Reject Applicant'),
                      ),
                    ],
                  ),
              ],
            ),
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
