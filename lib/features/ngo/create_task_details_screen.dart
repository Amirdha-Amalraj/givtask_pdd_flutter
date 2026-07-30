import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'data/ngo_providers.dart';
import 'data/ngo_repository.dart';
import '../../../core/models/task_model.dart';

class CreateTaskDetailsScreen extends ConsumerStatefulWidget {
  final String? taskId;
  const CreateTaskDetailsScreen({super.key, this.taskId});

  @override
  ConsumerState<CreateTaskDetailsScreen> createState() => _CreateTaskDetailsScreenState();
}

class _CreateTaskDetailsScreenState extends ConsumerState<CreateTaskDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _categoryController = TextEditingController();
  
  bool _isPaid = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.taskId != null) {
      _loadTaskData();
    }
  }

  Future<void> _loadTaskData() async {
    // In a real app we'd fetch the specific task, or read it from the provider list
    final tasks = await ref.read(ngoTasksProvider.future);
    final task = tasks.where((t) => t.id == widget.taskId).firstOrNull;
    if (task != null) {
      _titleController.text = task.title ?? '';
      _descriptionController.text = task.description ?? '';
      _locationController.text = task.location ?? '';
      _categoryController.text = task.category ?? '';
      setState(() {
        _isPaid = (task.budget ?? 0) > 0 || (task.rate ?? 0) > 0;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _saveTask(bool publish) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSaving = true);
    
    try {
      final repo = ref.read(ngoRepositoryProvider);
      
      final taskData = {
        'title': _titleController.text,
        'description': _descriptionController.text,
        'location': _locationController.text,
        'category': _categoryController.text.isNotEmpty ? _categoryController.text : 'General',
        'budget': _isPaid ? 100 : null, // Set budget to null if not paid to match numeric? schema, or 0 if preferred
        'mode': _isPaid ? 'paid' : 'volunteer',
        'status': publish ? 'open' : 'closed', // draft is not an enum value, so use closed for drafts
        'is_remote': false, // Provide default explicitly
        'required_skills': [], // Provide default explicitly
        'complexity': 'medium', // Provide default explicitly
        'is_flagged': false, // Provide default explicitly
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (widget.taskId != null) {
        await repo.updateTask(widget.taskId!, taskData);
      } else {
        await repo.createTask(taskData);
      }
      
      ref.invalidate(ngoTasksProvider);
      if (mounted) {
        context.pop();
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
    final isEdit = widget.taskId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Task' : 'Create Task'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Task Title', border: OutlineInputBorder()),
                  validator: (value) => value != null && value.isNotEmpty ? null : 'Required',
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _categoryController,
                  decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
                  validator: (value) => value != null && value.isNotEmpty ? null : 'Required',
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 5,
                  decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
                  validator: (value) => value != null && value.isNotEmpty ? null : 'Required',
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(labelText: 'Location', border: OutlineInputBorder()),
                  validator: (value) => value != null && value.isNotEmpty ? null : 'Required',
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Is this a paid freelance task?'),
                  value: _isPaid,
                  onChanged: (val) => setState(() => _isPaid = val),
                ),
                const SizedBox(height: 48),
                if (_isSaving)
                  const Center(child: CircularProgressIndicator())
                else
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _saveTask(false),
                          child: const Text('Save as Draft'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _saveTask(true),
                          child: Text(isEdit ? 'Publish Changes' : 'Publish Task'),
                        ),
                      ),
                    ],
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
