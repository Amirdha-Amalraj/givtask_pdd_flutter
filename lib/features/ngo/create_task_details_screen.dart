import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'data/ngo_providers.dart';
import 'data/ngo_repository.dart';
import '../../../core/models/task_model.dart';
import 'package:intl/intl.dart';

class CreateTaskDetailsScreen extends ConsumerStatefulWidget {
  final String? taskId;
  final String? taskType; // 'volunteer' or 'freelance'
  
  const CreateTaskDetailsScreen({super.key, this.taskId, this.taskType});

  @override
  ConsumerState<CreateTaskDetailsScreen> createState() => _CreateTaskDetailsScreenState();
}

class _CreateTaskDetailsScreenState extends ConsumerState<CreateTaskDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _categoryController = TextEditingController();
  final _skillsController = TextEditingController();
  final _volunteersNeededController = TextEditingController();
  final _hoursController = TextEditingController();
  final _budgetController = TextEditingController();
  final _rateController = TextEditingController();
  
  bool _isRemote = false;
  DateTime? _eventDate;
  DateTime? _deadlineDate;
  String _paymentType = 'Fixed Price';
  String _experienceLevel = 'medium';
  
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.taskId != null) {
      _loadTaskData();
    }
  }

  Future<void> _loadTaskData() async {
    final tasks = await ref.read(ngoTasksProvider.future);
    final task = tasks.where((t) => t.id == widget.taskId).firstOrNull;
    if (task != null) {
      _titleController.text = task.title ?? '';
      _descriptionController.text = task.description ?? '';
      _locationController.text = task.location ?? '';
      _categoryController.text = task.category ?? '';
      _skillsController.text = (task.requiredSkills ?? []).join(', ');
      _volunteersNeededController.text = task.volunteersNeeded?.toString() ?? '';
      _hoursController.text = task.volunteerHours?.toString() ?? '';
      _budgetController.text = task.budget?.toString() ?? '';
      _rateController.text = task.rate?.toString() ?? '';
      
      setState(() {
        _isRemote = task.isRemote ?? false;
        _eventDate = task.eventDate;
        _deadlineDate = task.deadline;
        _experienceLevel = task.complexity ?? 'medium';
        if ((task.rate ?? 0) > 0) {
          _paymentType = 'Hourly';
        } else {
          _paymentType = 'Fixed Price';
        }
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _categoryController.dispose();
    _skillsController.dispose();
    _volunteersNeededController.dispose();
    _hoursController.dispose();
    _budgetController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  Future<void> _saveTask(bool publish) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSaving = true);
    
    try {
      final repo = ref.read(ngoRepositoryProvider);
      
      final skillsList = _skillsController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      final isPaid = widget.taskType == 'freelance';
      
      num? budgetVal;
      num? rateVal;
      
      if (isPaid) {
        if (_paymentType == 'Fixed Price') {
          budgetVal = num.tryParse(_budgetController.text);
        } else {
          rateVal = num.tryParse(_rateController.text);
        }
      }

      final taskData = {
        'title': _titleController.text,
        'description': _descriptionController.text,
        'location': _locationController.text,
        'category': _categoryController.text.isNotEmpty ? _categoryController.text : 'General',
        'required_skills': skillsList,
        'is_remote': _isRemote,
        'mode': isPaid ? 'paid' : 'volunteer',
        'status': publish ? 'open' : 'closed',
        'volunteers_needed': int.tryParse(_volunteersNeededController.text),
        'volunteer_hours': int.tryParse(_hoursController.text),
        'event_date': _eventDate?.toIso8601String(),
        'deadline': _deadlineDate?.toIso8601String(),
        'budget': budgetVal,
        'rate': rateVal,
        'complexity': isPaid ? _experienceLevel : 'medium',
        'is_flagged': false,
      };

      if (widget.taskId != null) {
        taskData['updated_at'] = DateTime.now().toIso8601String();
        await repo.updateTask(widget.taskId!, taskData);
      } else {
        taskData['created_at'] = DateTime.now().toIso8601String();
        taskData['updated_at'] = DateTime.now().toIso8601String();
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

  Future<void> _selectDate(BuildContext context, bool isDeadline) async {
    final initialDate = isDeadline ? _deadlineDate : _eventDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null) {
      setState(() {
        if (isDeadline) {
          _deadlineDate = picked;
        } else {
          _eventDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.taskId != null;
    final isFreelance = widget.taskType == 'freelance';
    final typeLabel = isFreelance ? 'Freelance Project' : 'Volunteer Opportunity';

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit $typeLabel' : 'Create $typeLabel'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Common Fields
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
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
                  controller: _skillsController,
                  decoration: const InputDecoration(labelText: 'Required Skills (comma separated)', border: OutlineInputBorder(), hintText: 'e.g. Flutter, UI Design, Marketing'),
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
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _locationController,
                        decoration: const InputDecoration(labelText: 'Location', border: OutlineInputBorder()),
                        validator: (value) => !_isRemote && (value == null || value.isEmpty) ? 'Required if not remote' : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text('Is Remote?'),
                        value: _isRemote,
                        onChanged: (val) {
                          setState(() => _isRemote = val ?? false);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _volunteersNeededController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: isFreelance ? 'Freelancers Required' : 'Volunteers Needed', border: const OutlineInputBorder()),
                        validator: (value) => value != null && value.isNotEmpty ? null : 'Required',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _hoursController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: isFreelance ? 'Estimated Hours' : 'Hours Required', border: const OutlineInputBorder()),
                        validator: (value) => value != null && value.isNotEmpty ? null : 'Required',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                if (isFreelance) ...[
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _paymentType,
                          decoration: const InputDecoration(labelText: 'Payment Type', border: OutlineInputBorder()),
                          items: ['Fixed Price', 'Hourly'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                          onChanged: (val) => setState(() => _paymentType = val!),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _paymentType == 'Fixed Price'
                            ? TextFormField(
                                controller: _budgetController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(labelText: 'Budget Amount (\$)', border: OutlineInputBorder()),
                                validator: (value) => value != null && value.isNotEmpty ? null : 'Required',
                              )
                            : TextFormField(
                                controller: _rateController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(labelText: 'Hourly Rate (\$)', border: OutlineInputBorder()),
                                validator: (value) => value != null && value.isNotEmpty ? null : 'Required',
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _experienceLevel,
                    decoration: const InputDecoration(labelText: 'Experience Level', border: OutlineInputBorder()),
                    items: ['beginner', 'medium', 'advanced'].map((e) => DropdownMenuItem(value: e, child: Text(e.toUpperCase()))).toList(),
                    onChanged: (val) => setState(() => _experienceLevel = val!),
                  ),
                  const SizedBox(height: 16),
                ],
                
                Row(
                  children: [
                    if (!isFreelance)
                      Expanded(
                        child: InkWell(
                          onTap: () => _selectDate(context, false),
                          child: InputDecorator(
                            decoration: const InputDecoration(labelText: 'Start Date', border: OutlineInputBorder()),
                            child: Text(_eventDate != null ? DateFormat.yMMMd().format(_eventDate!) : 'Select Date'),
                          ),
                        ),
                      ),
                    if (!isFreelance) const SizedBox(width: 16),
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectDate(context, true),
                        child: InputDecorator(
                          decoration: InputDecoration(labelText: isFreelance ? 'Project Deadline' : 'End Date', border: const OutlineInputBorder()),
                          child: Text(_deadlineDate != null ? DateFormat.yMMMd().format(_deadlineDate!) : 'Select Date'),
                        ),
                      ),
                    ),
                  ],
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
