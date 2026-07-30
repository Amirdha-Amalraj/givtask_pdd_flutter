import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'data/ngo_providers.dart';

class NgoFreelancersScreen extends ConsumerStatefulWidget {
  const NgoFreelancersScreen({super.key});

  @override
  ConsumerState<NgoFreelancersScreen> createState() => _NgoFreelancersScreenState();
}

class _NgoFreelancersScreenState extends ConsumerState<NgoFreelancersScreen> {
  String _searchQuery = '';
  String _selectedAvailability = 'All';
  String _selectedLocation = 'All';
  String _selectedSkill = 'All';

  @override
  Widget build(BuildContext context) {
    final freelancersAsync = ref.watch(ngoFreelancersProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Freelancer Directory'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search freelancers...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedAvailability,
                        decoration: const InputDecoration(labelText: 'Availability', border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 12)),
                        items: ['All', 'Full-time', 'Part-time', 'Weekends'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                        onChanged: (val) => setState(() => _selectedAvailability = val!),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedLocation,
                        decoration: const InputDecoration(labelText: 'Location', border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 12)),
                        items: ['All', 'Remote', 'On-site'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                        onChanged: (val) => setState(() => _selectedLocation = val!),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: freelancersAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Error: $err')),
              data: (freelancers) {
                final filtered = freelancers.where((v) {
                  final name = v.fullName?.toLowerCase() ?? '';
                  final matchesSearch = name.contains(_searchQuery);
                  final matchesAvail = _selectedAvailability == 'All' || (v.availability?.contains(_selectedAvailability) ?? false);
                  final matchesLoc = _selectedLocation == 'All' || (v.location?.contains(_selectedLocation) ?? false);
                  return matchesSearch && matchesAvail && matchesLoc;
                }).toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.group_off_outlined, size: 64, color: theme.disabledColor),
                        const SizedBox(height: 16),
                        Text('No freelancers found.', style: theme.textTheme.titleMedium),
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
                        title: Text(v.fullName ?? 'Unknown Freelancer', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(v.bio ?? 'No bio provided'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          // Could navigate to a detailed freelancer profile view
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
