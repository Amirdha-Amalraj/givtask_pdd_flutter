import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateTaskMilestonesScreen extends StatefulWidget {
  const CreateTaskMilestonesScreen({super.key});

  @override
  State<CreateTaskMilestonesScreen> createState() => _CreateTaskMilestonesScreenState();
}

class _CreateTaskMilestonesScreenState extends State<CreateTaskMilestonesScreen> {
  final List<Map<String, String>> _milestones = [];
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  void _addMilestone() {
    if (_titleController.text.isNotEmpty && _amountController.text.isNotEmpty) {
      setState(() {
        _milestones.add({
          'title': _titleController.text,
          'amount': _amountController.text,
        });
        _titleController.clear();
        _amountController.clear();
      });
    }
  }

  void _publishTask() async {
    // Show loading, save to Supabase, etc.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Task Published Successfully!')),
    );
    context.go('/ngo-dashboard');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Milestones & Payment')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Define Milestones',
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Break down the freelance project into paid milestones.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Milestone Title',
                        hintText: 'e.g. Wireframes',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Amount',
                        prefixText: '\$',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: Colors.blue, size: 32),
                    onPressed: _addMilestone,
                  )
                ],
              ),
              
              const SizedBox(height: 24),
              
              Expanded(
                child: ListView.builder(
                  itemCount: _milestones.length,
                  itemBuilder: (context, index) {
                    final m = _milestones[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text('${index + 1}'),
                        ),
                        title: Text(m['title']!),
                        trailing: Text(
                          '\$${m['amount']}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _publishTask,
                child: const Text('Publish Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
