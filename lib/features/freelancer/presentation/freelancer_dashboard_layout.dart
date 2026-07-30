import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/data/auth_repository.dart';

class FreelancerDashboardLayout extends ConsumerWidget {
  final Widget child;

  const FreelancerDashboardLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width >= 1024;
    final isTablet = MediaQuery.of(context).size.width >= 768 && !isDesktop;

    return Scaffold(
      appBar: !isDesktop
          ? AppBar(
              title: const Text('GivTask Freelancer'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () => context.go('/freelancer-notifications'),
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
          route: '/freelancer-dashboard',
        ),
        _DrawerItem(
          icon: Icons.search,
          title: 'Discover Projects',
          route: '/freelancer-discover',
        ),
        _DrawerItem(
          icon: Icons.description_outlined,
          title: 'My Proposals',
          route: '/freelancer-proposals',
        ),
        _DrawerItem(
          icon: Icons.work_outline,
          title: 'Active Projects',
          route: '/freelancer-active-projects',
        ),
        _DrawerItem(
          icon: Icons.task_alt,
          title: 'Completed Projects',
          route: '/freelancer-completed-projects',
        ),
        _DrawerItem(
          icon: Icons.person_outline,
          title: 'Profile',
          route: '/freelancer-profile',
        ),
        _DrawerItem(
          icon: Icons.settings_outlined,
          title: 'Settings',
          route: '/freelancer-settings',
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text('Logout', style: TextStyle(color: Colors.red)),
          onTap: () async {
            await ref.read(authRepositoryProvider).signOut();
            if (context.mounted) {
              context.go('/login');
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
    final currentRoute = GoRouterState.of(context).uri.path;
    final isSelected = currentRoute.startsWith(route);

    return ListTile(
      leading: Icon(icon, color: isSelected ? Theme.of(context).colorScheme.primary : null),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Theme.of(context).colorScheme.primary : null,
        ),
      ),
      selected: isSelected,
      selectedTileColor: Theme.of(context).colorScheme.primaryContainer.withAlpha(50),
      onTap: () {
        context.go(route);
        if (MediaQuery.of(context).size.width < 1024) {
          Navigator.pop(context); // Close drawer on mobile
        }
      },
    );
  }
}
