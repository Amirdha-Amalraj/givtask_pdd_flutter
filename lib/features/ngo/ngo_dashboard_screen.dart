import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'data/ngo_providers.dart';
import '../../../core/models/task_model.dart';
import '../../../core/models/application_model.dart';

class NgoDashboardScreen extends ConsumerWidget {
  const NgoDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final tasksAsync = ref.watch(ngoTasksProvider);
    final appsAsync = ref.watch(ngoApplicationsProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerHighest.withAlpha(50),
      appBar: AppBar(
        title: const Text('NGO Dashboard'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: tasksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (tasks) {
          return appsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Error: $err')),
            data: (applications) {
              return _buildDashboardContent(context, theme, tasks, applications);
            },
          );
        },
      ),
    );
  }

  Widget _buildDashboardContent(BuildContext context, ThemeData theme, List<TaskModel> tasks, List<ApplicationModel> applications) {
    final activeTasks = tasks.where((t) => t.status != 'closed' && t.status != 'completed').length;
    final totalApplicants = applications.length;
    final acceptedApplicants = applications.where((a) => a.status == 'Accepted').length;
    
    // Generate some chart data based on task categories
    final Map<String, int> categoryCount = {};
    for (var t in tasks) {
      final cat = t.category ?? 'Uncategorized';
      categoryCount[cat] = (categoryCount[cat] ?? 0) + 1;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Overview', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          // Stats Row
          LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 600;
              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  SizedBox(
                    width: isMobile ? double.infinity : (constraints.maxWidth - 32) / 3,
                    child: _StatCard(title: 'Active Tasks', count: activeTasks.toString(), icon: Icons.assignment, color: Colors.blue),
                  ),
                  SizedBox(
                    width: isMobile ? double.infinity : (constraints.maxWidth - 32) / 3,
                    child: _StatCard(title: 'Total Applications', count: totalApplicants.toString(), icon: Icons.people, color: Colors.orange),
                  ),
                  SizedBox(
                    width: isMobile ? double.infinity : (constraints.maxWidth - 32) / 3,
                    child: _StatCard(title: 'Accepted Volunteers', count: acceptedApplicants.toString(), icon: Icons.verified, color: Colors.green),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 32),
          // Quick Actions
          Text('Quick Actions', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _QuickActionButton(label: 'Create Task', icon: Icons.add, onTap: () => context.push('/create-task-type')),
              _QuickActionButton(label: 'Review Applications', icon: Icons.checklist, onTap: () => context.go('/applicants-list')),
              _QuickActionButton(label: 'Issue Certificate', icon: Icons.workspace_premium, onTap: () => context.go('/ngo-certificates')),
              _QuickActionButton(label: 'Manage Volunteers', icon: Icons.group, onTap: () => context.go('/ngo-volunteers')),
              _QuickActionButton(label: 'Edit Profile', icon: Icons.settings, onTap: () => context.go('/ngo-profile-settings')),
            ],
          ),
          const SizedBox(height: 40),
          // Charts Area
          if (tasks.isNotEmpty) ...[
            Text('Tasks by Category', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Container(
              height: 300,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.dividerColor),
              ),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: (categoryCount.values.isEmpty ? 1 : categoryCount.values.reduce((a, b) => a > b ? a : b)).toDouble() + 1,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= categoryCount.keys.length) return const SizedBox.shrink();
                          final title = categoryCount.keys.elementAt(value.toInt());
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(title, style: const TextStyle(fontSize: 10)),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 28)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: categoryCount.entries.toList().asMap().entries.map((entry) {
                    final index = entry.key;
                    final count = entry.value.value;
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: count.toDouble(),
                          color: theme.colorScheme.primary,
                          width: 20,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                        )
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
          const SizedBox(height: 32),
          // Recent Activity
          Text('Recent Tasks', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          if (tasks.isEmpty)
            const Text('No tasks created yet.')
          else
            ...tasks.take(3).map((task) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(task.title ?? 'Untitled Task', style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${task.category ?? 'General'} • ${_getDisplayStatus(task.status ?? 'open')}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/task-detail-edit?id=${task.id}'),
              ),
            )),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String count;
  final IconData icon;
  final MaterialColor color;

  const _StatCard({required this.title, required this.count, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color.shade700),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(title, style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w600, fontSize: 14))),
            ],
          ),
          const SizedBox(height: 16),
          Text(count, style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.grey.shade900)),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickActionButton({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(icon, size: 16),
      label: Text(label),
      onPressed: onTap,
    );
  }
}

String _getDisplayStatus(String status) {
  switch (status) {
    case 'open': return 'Published';
    case 'in_progress': return 'In Progress';
    case 'closed': return 'Archived';
    case 'completed': return 'Completed';
    default: return 'Unknown';
  }
}
