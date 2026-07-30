import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/givtask_logo.dart';

class ProfileSetupBasicScreen extends StatefulWidget {
  const ProfileSetupBasicScreen({super.key});

  @override
  State<ProfileSetupBasicScreen> createState() => _ProfileSetupBasicScreenState();
}

class _ProfileSetupBasicScreenState extends State<ProfileSetupBasicScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  final _bioController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _locationController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_formKey.currentState?.validate() ?? false) {
      // Save data to state or Supabase
      context.push('/profile-setup-skills');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile Setup (1/2)')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(child: GivTaskLogo(size: 50)),
                const SizedBox(height: 24),
                Text(
                  'Basic Information',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tell us a bit more about yourself to help us find the best matches.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32),
                
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: Icon(Icons.phone),
                  ),
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    labelText: 'Location (City, Country)',
                    prefixIcon: Icon(Icons.location_on),
                  ),
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _bioController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Bio / About',
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 32),
                
                ElevatedButton(
                  onPressed: _nextStep,
                  child: const Text('Continue to Skills'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => context.push('/profile-setup-skills'),
                  child: const Text('Skip for now'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
