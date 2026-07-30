import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'data/freelancer_providers.dart';

class FreelanceProjectDetailsScreen extends ConsumerStatefulWidget {
  final String taskId;

  const FreelanceProjectDetailsScreen({super.key, required this.taskId});

  @override
  ConsumerState<FreelanceProjectDetailsScreen> createState() => _FreelanceProjectDetailsScreenState();
}

class _FreelanceProjectDetailsScreenState extends ConsumerState<FreelanceProjectDetailsScreen> {
  final _coverNoteController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _submitProposal() async {
    if (_coverNoteController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a cover letter or pitch.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final repo = ref.read(freelancerRepositoryProvider);
      await repo.submitProposal(widget.taskId, _coverNoteController.text);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Proposal submitted successfully!')),
        );
        context.pop(); // Go back
        ref.invalidate(myProposalsProvider);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  void _showProposalDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submit Proposal'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Write a brief cover letter explaining why you are the best fit for this project.'),
            const SizedBox(height: 16),
            TextField(
              controller: _coverNoteController,
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Your pitch here...',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _isSubmitting ? null : () {
              Navigator.pop(context);
              _submitProposal();
            },
            child: _isSubmitting 
              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Submit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskAsync = ref.watch(freelanceProjectDetailProvider(widget.taskId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Details'),
      ),
      body: taskAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (task) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Chip(
                      label: Text(task.category ?? 'General'),
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    if (task.budget != null)
                      Text(
                        '\$${task.budget}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  task.title ?? 'Untitled',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Posted by: ${task.ngoName ?? 'Unknown Client'}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey[700]),
                ),
                const SizedBox(height: 24),
                const Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(task.description ?? 'No description provided.', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(task.location ?? (task.isRemote == true ? 'Remote' : 'Location TBD')),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.build, color: Colors.grey),
                    const SizedBox(width: 8),
                    const Text('Required Skills:'),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: (task.requiredSkills ?? []).map((skill) => Chip(label: Text(skill))).toList(),
                ),
                const SizedBox(height: 48),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: taskAsync.hasValue ? _showProposalDialog : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Submit Proposal', style: TextStyle(fontSize: 16)),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _coverNoteController.dispose();
    super.dispose();
  }
}
