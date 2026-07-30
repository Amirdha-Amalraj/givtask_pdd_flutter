import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'data/ngo_providers.dart';
import 'data/ngo_repository.dart';
import '../../../core/models/ngo_profile_model.dart';

class NgoProfileSettingsScreen extends ConsumerStatefulWidget {
  const NgoProfileSettingsScreen({super.key});

  @override
  ConsumerState<NgoProfileSettingsScreen> createState() => _NgoProfileSettingsScreenState();
}

class _NgoProfileSettingsScreenState extends ConsumerState<NgoProfileSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _orgNameCtrl;
  late TextEditingController _orgDescCtrl;
  late TextEditingController _websiteCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _addressCtrl;
  late TextEditingController _missionCtrl;
  late TextEditingController _visionCtrl;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _orgNameCtrl = TextEditingController();
    _orgDescCtrl = TextEditingController();
    _websiteCtrl = TextEditingController();
    _emailCtrl = TextEditingController();
    _phoneCtrl = TextEditingController();
    _addressCtrl = TextEditingController();
    _missionCtrl = TextEditingController();
    _visionCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _orgNameCtrl.dispose();
    _orgDescCtrl.dispose();
    _websiteCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _missionCtrl.dispose();
    _visionCtrl.dispose();
    super.dispose();
  }

  void _populateForm(NgoProfileModel profile) {
    _orgNameCtrl.text = profile.orgName ?? '';
    _orgDescCtrl.text = profile.orgDescription ?? '';
    _websiteCtrl.text = profile.website ?? '';
    _emailCtrl.text = profile.email ?? '';
    _phoneCtrl.text = profile.phone ?? '';
    _addressCtrl.text = profile.address ?? '';
    _missionCtrl.text = profile.mission ?? '';
    _visionCtrl.text = profile.vision ?? '';
  }

  Future<void> _saveProfile() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSaving = true);
    try {
      await ref.read(ngoRepositoryProvider).updateNgoProfile({
        'org_name': _orgNameCtrl.text,
        'org_description': _orgDescCtrl.text,
        'website': _websiteCtrl.text,
        'email': _emailCtrl.text,
        'phone': _phoneCtrl.text,
        'address': _addressCtrl.text,
        'mission': _missionCtrl.text,
        'vision': _visionCtrl.text,
      });
      ref.invalidate(ngoProfileProvider);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated successfully.')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(ngoProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('NGO Profile Settings'),
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (profile) {
          if (profile != null && _orgNameCtrl.text.isEmpty && _orgDescCtrl.text.isEmpty) {
            _populateForm(profile);
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    child: Icon(Icons.business, size: 50),
                  ),
                  const SizedBox(height: 16),
                  const Center(child: TextButton(onPressed: null, child: Text('Change Logo (Coming Soon)'))),
                  const SizedBox(height: 32),
                  
                  TextFormField(
                    controller: _orgNameCtrl,
                    decoration: const InputDecoration(labelText: 'Organization Name', border: OutlineInputBorder()),
                    validator: (val) => val != null && val.isNotEmpty ? null : 'Required',
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _orgDescCtrl,
                    maxLines: 3,
                    decoration: const InputDecoration(labelText: 'About Organization', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _missionCtrl,
                    maxLines: 2,
                    decoration: const InputDecoration(labelText: 'Mission', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _visionCtrl,
                    maxLines: 2,
                    decoration: const InputDecoration(labelText: 'Vision', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailCtrl,
                    decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneCtrl,
                    decoration: const InputDecoration(labelText: 'Phone', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _addressCtrl,
                    decoration: const InputDecoration(labelText: 'Address', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _websiteCtrl,
                    decoration: const InputDecoration(labelText: 'Website', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 48),
                  
                  if (_isSaving)
                    const Center(child: CircularProgressIndicator())
                  else
                    ElevatedButton(
                      onPressed: _saveProfile,
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                      child: const Text('Save Profile'),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
