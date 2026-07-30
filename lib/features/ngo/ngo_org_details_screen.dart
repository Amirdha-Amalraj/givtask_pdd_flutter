import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NgoOrgDetailsScreen extends StatefulWidget {
  const NgoOrgDetailsScreen({super.key});

  @override
  State<NgoOrgDetailsScreen> createState() => _NgoOrgDetailsScreenState();
}

class _NgoOrgDetailsScreenState extends State<NgoOrgDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _orgNameController = TextEditingController();
  final _regNoController = TextEditingController();
  final _websiteController = TextEditingController();

  @override
  void dispose() {
    _orgNameController.dispose();
    _regNoController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_formKey.currentState?.validate() ?? false) {
      // Save data locally or send to backend
      context.push('/ngo-doc-upload');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('NGO Setup (1/2)')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.business_center, size: 64, color: Colors.green),
                const SizedBox(height: 16),
                Text(
                  'Organization Details',
                  style: theme.textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Provide your official organization details. This helps us verify your NGO to build trust with volunteers.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                
                TextFormField(
                  controller: _orgNameController,
                  decoration: const InputDecoration(
                    labelText: 'Registered Organization Name',
                    prefixIcon: Icon(Icons.business),
                  ),
                  validator: (value) => value != null && value.isNotEmpty ? null : 'Required',
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _regNoController,
                  decoration: const InputDecoration(
                    labelText: 'Registration/Tax ID Number',
                    prefixIcon: Icon(Icons.numbers),
                  ),
                  validator: (value) => value != null && value.isNotEmpty ? null : 'Required',
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _websiteController,
                  keyboardType: TextInputType.url,
                  decoration: const InputDecoration(
                    labelText: 'Organization Website (Optional)',
                    prefixIcon: Icon(Icons.language),
                  ),
                ),
                const SizedBox(height: 48),
                
                ElevatedButton(
                  onPressed: _nextStep,
                  child: const Text('Continue to Document Upload'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
