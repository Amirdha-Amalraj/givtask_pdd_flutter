import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'data/freelancer_providers.dart';

class FreelancerDashboardScreen extends ConsumerWidget {
  const FreelancerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paidProjectsAsync = ref.watch(paidProjectsProvider);
    final activeProjectsAsync = ref.watch(freelancerActiveProjectsProvider);
    final proposalsAsync = ref.watch(myProposalsProvider);
    final earningsAsync = ref.watch(freelancerEarningsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: [
                _StatCard(
                  title: 'Available Projects',
                  value: paidProjectsAsync.maybeWhen(
                    data: (data) => data.length.toString(),
                    orElse: () => '-',
                  ),
                  icon: Icons.work_outline,
                  color: Colors.blue,
                ),
                _StatCard(
                  title: 'Active Projects',
                  value: activeProjectsAsync.maybeWhen(
                    data: (data) => data.length.toString(),
                    orElse: () => '-',
                  ),
                  icon: Icons.play_circle_outline,
                  color: Colors.orange,
                ),
                _StatCard(
                  title: 'Pending Proposals',
                  value: proposalsAsync.maybeWhen(
                    data: (data) => data.where((app) => app.status == 'applied').length.toString(),
                    orElse: () => '-',
                  ),
                  icon: Icons.pending_actions,
                  color: Colors.purple,
                ),
                _StatCard(
                  title: 'Earnings',
                  value: earningsAsync.maybeWhen(
                    data: (data) => '\$${data.toStringAsFixed(0)}',
                    orElse: () => '-',
                  ),
                  icon: Icons.attach_money,
                  color: Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'Recent Activity',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            proposalsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Text('Error loading activity: $err'),
              data: (proposals) {
                if (proposals.isEmpty) {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Center(
                        child: Text('No recent activity. Start applying to projects!'),
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: proposals.take(5).length,
                  itemBuilder: (context, index) {
                    final app = proposals[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                          child: Icon(Icons.description, color: Theme.of(context).colorScheme.primary),
                        ),
                        title: Text('Proposal submitted for: ${app.task?.title ?? 'Unknown Project'}'),
                        subtitle: Text('Status: ${app.status?.toUpperCase() ?? 'PENDING'}'),
                        trailing: Text(
                          app.appliedAt != null ? '${app.appliedAt!.day}/${app.appliedAt!.month}/${app.appliedAt!.year}' : '',
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }
}
