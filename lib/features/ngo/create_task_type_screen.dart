import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateTaskTypeScreen extends StatelessWidget {
  const CreateTaskTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(title: const Text('Create New Task')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'What kind of help do you need?',
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Select the type of task you are posting to find the right candidates.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 32),
              
              _TaskTypeCard(
                title: 'Volunteer Task',
                description: 'Unpaid opportunity for individuals looking to gain experience and contribute to a cause.',
                icon: Icons.volunteer_activism,
                color: Colors.orange,
                onTap: () {
                  context.push('/create-task-details?type=volunteer');
                },
              ),
              const SizedBox(height: 16),
              
              _TaskTypeCard(
                title: 'Freelance Project',
                description: 'Paid project with defined milestones and deliverables for professional freelancers.',
                icon: Icons.work,
                color: Colors.blue,
                onTap: () {
                  context.push('/create-task-details?type=freelance');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TaskTypeCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final MaterialColor color;
  final VoidCallback onTap;

  const _TaskTypeCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          border: Border.all(color: color.shade200),
          borderRadius: BorderRadius.circular(16),
          color: color.shade50.withOpacity(0.5),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: color.shade700),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color.shade900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right, color: color.shade700),
          ],
        ),
      ),
    );
  }
}
