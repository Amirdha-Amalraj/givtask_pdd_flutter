import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'data/ngo_providers.dart';

class NgoVolunteersScreen extends ConsumerStatefulWidget {
  const NgoVolunteersScreen({super.key});

  @override
  ConsumerState<NgoVolunteersScreen> createState() => _NgoVolunteersScreenState();
}

class _NgoVolunteersScreenState extends ConsumerState<NgoVolunteersScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final volunteersAsync = ref.watch(ngoVolunteersProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Volunteers'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search volunteers...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
            ),
          ),
          Expanded(
            child: volunteersAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Error: $err')),
              data: (volunteers) {
                final filtered = volunteers.where((v) {
                  final name = v.fullName?.toLowerCase() ?? '';
                  return name.contains(_searchQuery);
                }).toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.group_off_outlined, size: 64, color: theme.disabledColor),
                        const SizedBox(height: 16),
                        Text('No volunteers found.', style: theme.textTheme.titleMedium),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final v = filtered[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: v.avatarUrl != null ? NetworkImage(v.avatarUrl!) : null,
                          child: v.avatarUrl == null ? const Icon(Icons.person) : null,
                        ),
                        title: Text(v.fullName ?? 'Unknown Volunteer', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(v.bio ?? 'No bio provided'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          // Could navigate to a detailed volunteer profile view
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
