import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileSetupSkillsScreen extends StatefulWidget {
  const ProfileSetupSkillsScreen({super.key});

  @override
  State<ProfileSetupSkillsScreen> createState() => _ProfileSetupSkillsScreenState();
}

class _ProfileSetupSkillsScreenState extends State<ProfileSetupSkillsScreen> {
  final List<String> _availableSkills = [
    'Teaching', 'Web Development', 'Design', 'Marketing',
    'Event Planning', 'Content Writing', 'Healthcare', 'Fundraising',
  ];
  
  final Set<String> _selectedSkills = {};

  void _finishSetup() {
    // Save to backend
    // Navigate to dashboard
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile setup complete!')),
    );
    context.go('/home'); // Assuming home route
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile Setup (2/2)')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Skills & Interests',
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Select the skills you have or are interested in. This powers our AI matching engine.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
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
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _finishSetup,
                child: const Text('Finish Setup'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.go('/home'),
                child: const Text('Skip for now'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
