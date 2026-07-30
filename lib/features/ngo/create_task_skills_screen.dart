import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateTaskSkillsScreen extends StatefulWidget {
  const CreateTaskSkillsScreen({super.key});

  @override
  State<CreateTaskSkillsScreen> createState() => _CreateTaskSkillsScreenState();
}

class _CreateTaskSkillsScreenState extends State<CreateTaskSkillsScreen> {
  final List<String> _availableSkills = [
    'Teaching', 'Web Development', 'Design', 'Marketing',
    'Event Planning', 'Content Writing', 'Healthcare', 'Fundraising',
    'React', 'Flutter', 'Node.js', 'Figma'
  ];
  
  final Set<String> _selectedSkills = {};

  void _nextStep() {
    if (_selectedSkills.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one skill.')),
      );
      return;
    }
    
    // Check type from query params or state (assuming freelance for this flow test)
    context.push('/create-task-milestones');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Required Skills')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'What skills are needed?',
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Select the skills required for this task to help our AI find the best matches.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: _availableSkills.map((skill) {
                      final isSelected = _selectedSkills.contains(skill);
                      return FilterChip(
                        label: Text(skill),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedSkills.add(skill);
                            } else {
                              _selectedSkills.remove(skill);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _nextStep,
                child: const Text('Continue to Milestones'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
