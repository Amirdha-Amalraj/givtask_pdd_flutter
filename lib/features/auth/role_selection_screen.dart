import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/givtask_logo.dart';

class RoleSelectionScreen extends StatelessWidget {
  final String action;
  
  const RoleSelectionScreen({super.key, this.action = 'register'});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Who are you?'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(child: GivTaskLogo(size: 60)),
            const SizedBox(height: 24),
            Text(
              action == 'login' 
                  ? 'Select your role to log in to your account.'
                  : 'Select how you want to use GivTask. You can change this later in settings.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            _RoleCard(
              title: 'I am an NGO',
              subtitle: 'Post tasks and find verified talent',
              icon: Icons.business,
              color: theme.colorScheme.primary,
              onTap: () {
                if (action == 'login') {
                  context.go('/login?role=ngo');
                } else {
                  context.go('/register?role=ngo');
                }
              },
            ),
            const SizedBox(height: 24),
            _RoleCard(
              title: 'I am a Volunteer',
              subtitle: 'Apply to unpaid tasks and earn certificates',
              icon: Icons.volunteer_activism,
              color: Colors.orange.shade700,
              onTap: () {
                if (action == 'login') {
                  context.go('/login?role=volunteer');
                } else {
                  context.go('/register?role=volunteer');
                }
              },
            ),
            const SizedBox(height: 24),
            _RoleCard(
              title: 'I am a Freelancer',
              subtitle: 'Apply to paid tasks and earn money',
              icon: Icons.work,
              color: Colors.blue.shade700,
              onTap: () {
                if (action == 'login') {
                  context.go('/login?role=freelancer');
                } else {
                  context.go('/register?role=freelancer');
                }
              },
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (action == 'register') ...[
                  const Text('Already have an account?'),
                  TextButton(
                    onPressed: () {
                      context.go('/role-selection?action=login');
                    },
                    child: const Text('Login'),
                  ),
                ] else ...[
                  const Text('Don\'t have an account?'),
                  TextButton(
                    onPressed: () {
                      context.go('/role-selection?action=register');
                    },
                    child: const Text('Register'),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          border: Border.all(color: color.withOpacity(0.3), width: 2),
          borderRadius: BorderRadius.circular(16),
          color: color.withOpacity(0.05),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: color, size: 16),
          ],
        ),
      ),
    );
  }
}
