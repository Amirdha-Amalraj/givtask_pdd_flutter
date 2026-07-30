import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/data/auth_repository.dart';

class NgoDashboardLayout extends ConsumerWidget {
  final Widget child;

  const NgoDashboardLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width >= 1024;
    final isTablet = MediaQuery.of(context).size.width >= 768 && !isDesktop;

    return Scaffold(
      appBar: !isDesktop
          ? AppBar(
              title: const Text('GivTask NGO'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () => context.go('/notifications'),
                ),
                const SizedBox(width: 8),
              ],
            )
          : null,
      drawer: !isDesktop ? _buildSidebar(context, ref) : null,
      body: Row(
        children: [
          if (isDesktop)
            Container(
              width: 280,
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: theme.dividerColor)),
                color: theme.colorScheme.surface,
              ),
              child: _buildSidebar(context, ref),
            ),
          Expanded(
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        if (MediaQuery.of(context).size.width >= 1024)
          const Padding(
            padding: EdgeInsets.all(24.0),
            child: Text(
              'GivTask NGO',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green, // Differentiate from Volunteer
              ),
            ),
          ),
        _DrawerItem(
          icon: Icons.dashboard_outlined,
          title: 'Dashboard',
          route: '/ngo-dashboard',
        ),
        _DrawerItem(
          icon: Icons.assignment_outlined,
          title: 'Task Management',
          route: '/my-tasks',
        ),
        _DrawerItem(
          icon: Icons.people_outline,
          title: 'Applications',
          route: '/applicants-list',
        ),
        _DrawerItem(
          icon: Icons.group_outlined,
          title: 'Volunteers',
          route: '/ngo-volunteers',
        ),
        _DrawerItem(
          icon: Icons.workspace_premium_outlined,
          title: 'Certificates',
          route: '/ngo-certificates',
        ),
        _DrawerItem(
          icon: Icons.calendar_month_outlined,
          title: 'Calendar',
          route: '/ngo-calendar',
        ),
        _DrawerItem(
          icon: Icons.analytics_outlined,
          title: 'Reports & Analytics',
          route: '/ngo-analytics',
        ),
        const Divider(),
        _DrawerItem(
          icon: Icons.settings_outlined,
          title: 'Profile Settings',
          route: '/ngo-profile-settings',
        ),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text('Logout', style: TextStyle(color: Colors.red)),
          onTap: () async {
            await ref.read(authRepositoryProvider).signOut();
            if (context.mounted) {
              context.go('/landing');
            }
          },
        ),
      ],
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String route;

  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).uri.toString();
    final isSelected = currentRoute.startsWith(route);

    return ListTile(
      leading: Icon(icon, color: isSelected ? Theme.of(context).colorScheme.primary : null),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Theme.of(context).colorScheme.primary : null,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: Theme.of(context).colorScheme.primaryContainer.withAlpha(50),
      onTap: () {
        if (MediaQuery.of(context).size.width < 1024) {
          Navigator.pop(context);
        }
        context.go(route);
      },
    );
  }
}
