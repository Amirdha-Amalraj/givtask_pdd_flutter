import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'data/ngo_providers.dart';
import 'data/ngo_repository.dart';
import '../../../core/models/profile_model.dart';
import '../../../core/models/task_model.dart';

class NgoCertificatesScreen extends ConsumerStatefulWidget {
  const NgoCertificatesScreen({super.key});

  @override
  ConsumerState<NgoCertificatesScreen> createState() => _NgoCertificatesScreenState();
}

class _NgoCertificatesScreenState extends ConsumerState<NgoCertificatesScreen> {
  Future<void> _showIssueCertificateDialog() async {
    final volunteers = await ref.read(ngoVolunteersProvider.future);
    final freelancers = await ref.read(ngoFreelancersProvider.future);
    final allUsers = [...volunteers, ...freelancers];
    final tasks = await ref.read(ngoTasksProvider.future);

    if (!mounted) return;
    
    if (allUsers.isEmpty || tasks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You need both volunteers/freelancers and tasks to issue a certificate.')));
      return;
    }

    String? selectedUserId = allUsers.first.id;
    String? selectedTaskId = tasks.first.id;
    final titleController = TextEditingController(text: 'Certificate of Excellence');

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Issue Certificate'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Select Volunteer or Freelancer'),
                    value: selectedUserId,
                    items: allUsers.map((u) => DropdownMenuItem(value: u.id, child: Text('${u.fullName ?? 'Unknown'} (${u.role})'))).toList(),
                    onChanged: (val) => setDialogState(() => selectedUserId = val),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Select Task'),
                    value: selectedTaskId,
                    items: tasks.map((t) => DropdownMenuItem(value: t.id, child: Text(t.title ?? 'Untitled'))).toList(),
                    onChanged: (val) => setDialogState(() => selectedTaskId = val),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Certificate Title'),
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () async {
                    if (selectedUserId != null && selectedTaskId != null && titleController.text.isNotEmpty) {
                      Navigator.pop(context);
                      await _issueCertificate(selectedUserId!, selectedTaskId!, titleController.text);
                    }
                  },
                  child: const Text('Issue'),
                ),
              ],
            );
          }
        );
      }
    );
  }

  Future<void> _issueCertificate(String volunteerId, String taskId, String title) async {
    try {
      await ref.read(ngoRepositoryProvider).issueCertificate(volunteerId, taskId, title);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Certificate issued successfully.')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Certificate Management'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.workspace_premium, size: 80, color: Theme.of(context).disabledColor),
            const SizedBox(height: 16),
            const Text('Manage and issue certificates to volunteers and freelancers.'),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _showIssueCertificateDialog,
              icon: const Icon(Icons.add),
              label: const Text('Issue New Certificate'),
            )
          ],
        ),
      ),
    );
  }
}
