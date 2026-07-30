import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/data/auth_repository.dart';

class VolunteerDashboardLayout extends ConsumerWidget {
  final Widget child;

  const VolunteerDashboardLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width >= 1024;
    final isTablet = MediaQuery.of(context).size.width >= 768 && !isDesktop;

    return Scaffold(
      appBar: !isDesktop
          ? AppBar(
              title: const Text('GivTask Volunteer'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () => context.go('/volunteer-notifications'),
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
              'GivTask',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
        _DrawerItem(
          icon: Icons.dashboard_outlined,
          title: 'Dashboard',
          route: '/volunteer-tasks',
        ),
        _DrawerItem(
          icon: Icons.search,
          title: 'Discover Opportunities',
          route: '/volunteer-discover',
        ),
        _DrawerItem(
          icon: Icons.assignment_outlined,
          title: 'My Applications',
          route: '/my-applications',
        ),
        _DrawerItem(
          icon: Icons.volunteer_activism_outlined,
          title: 'Active Volunteering',
          route: '/my-active-tasks',
        ),
        _DrawerItem(
          icon: Icons.history,
          title: 'Completed Tasks',
          route: '/completed-history',
        ),
        _DrawerItem(
          icon: Icons.workspace_premium_outlined,
          title: 'Certificates',
          route: '/certificates-gallery',
        ),
        _DrawerItem(
          icon: Icons.calendar_month_outlined,
          title: 'Calendar',
          route: '/volunteer-calendar',
        ),
        _DrawerItem(
          icon: Icons.message_outlined,
          title: 'Messages',
          route: '/volunteer-messages',
        ),
        _DrawerItem(
          icon: Icons.bookmark_border,
          title: 'Saved Opportunities',
          route: '/volunteer-saved',
        ),
        const Divider(),
        _DrawerItem(
          icon: Icons.person_outline,
          title: 'Profile',
          route: '/volunteer-profile',
        ),
        _DrawerItem(
          icon: Icons.settings_outlined,
          title: 'Settings',
          route: '/volunteer-settings',
        ),
        _DrawerItem(
          icon: Icons.help_outline,
          title: 'Help & Support',
          route: '/volunteer-help',
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
        // Close drawer if on mobile/tablet
        if (MediaQuery.of(context).size.width < 1024) {
          Navigator.pop(context);
        }
        context.go(route);
      },
    );
  }
}
