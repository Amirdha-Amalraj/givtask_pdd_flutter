import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'data/freelancer_providers.dart';

class MyProposalsScreen extends ConsumerWidget {
  const MyProposalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final proposalsAsync = ref.watch(myProposalsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Proposals'),
      ),
      body: proposalsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (proposals) {
          if (proposals.isEmpty) {
            return const Center(
              child: Text('You have not submitted any proposals yet.'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: proposals.length,
            itemBuilder: (context, index) {
              final app = proposals[index];
              final task = app.task;

              Color statusColor = Colors.grey;
              if (app.status == 'accepted') statusColor = Colors.green;
              if (app.status == 'rejected') statusColor = Colors.red;
              if (app.status == 'shortlisted') statusColor = Colors.orange;
              if (app.status == 'completed') statusColor = Colors.blue;

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              task?.title ?? 'Unknown Project',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Chip(
                            label: Text(
                              app.status?.toUpperCase() ?? 'UNKNOWN',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            backgroundColor: statusColor,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        task?.ngoName ?? 'Unknown Client',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 16),
                      const Text('Your Cover Note:', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(
                        app.coverNote ?? 'No cover note provided.',
                        style: const TextStyle(color: Colors.grey),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Applied on: ${app.appliedAt != null ? '${app.appliedAt!.day}/${app.appliedAt!.month}/${app.appliedAt!.year}' : 'Unknown'}',
                            style: const TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
