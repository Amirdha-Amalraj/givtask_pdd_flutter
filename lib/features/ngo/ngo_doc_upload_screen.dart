import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NgoDocUploadScreen extends StatefulWidget {
  const NgoDocUploadScreen({super.key});

  @override
  State<NgoDocUploadScreen> createState() => _NgoDocUploadScreenState();
}

class _NgoDocUploadScreenState extends State<NgoDocUploadScreen> {
  bool _isFileSelected = false;
  bool _isUploading = false;

  void _pickDocument() async {
    // Simulate picking a file
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _isFileSelected = true;
    });
  }

  void _submitForVerification() async {
    if (!_isFileSelected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload a document first.')),
      );
      return;
    }

    setState(() => _isUploading = true);
    // Simulate upload and backend save
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isUploading = false);

    if (mounted) {
      context.go('/ngo-verification-status');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('NGO Setup (2/2)')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Verify your NGO',
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Upload a copy of your NGO registration certificate or official tax document.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 32),
              
              InkWell(
                onTap: _pickDocument,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _isFileSelected ? Colors.green : Colors.grey.shade400, 
                      width: 2,
                      style: BorderStyle.solid, // Should ideally be dashed
                    ),
                    borderRadius: BorderRadius.circular(16),
                    color: _isFileSelected ? Colors.green.withOpacity(0.05) : Colors.grey.withOpacity(0.05),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _isFileSelected ? Icons.check_circle : Icons.upload_file,
                          size: 48,
                          color: _isFileSelected ? Colors.green : Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _isFileSelected ? 'Document Selected (registration.pdf)' : 'Tap to Upload Document',
                          style: TextStyle(
                            color: _isFileSelected ? Colors.green : Colors.grey.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (!_isFileSelected)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              'PDF, JPG, or PNG (Max 5MB)',
                              style: theme.textTheme.bodySmall,
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _isUploading ? null : _submitForVerification,
                child: _isUploading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Submit for Verification'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
