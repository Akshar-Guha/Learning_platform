import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../providers/goals_providers.dart';

class CreateGoalForm extends ConsumerStatefulWidget {
  const CreateGoalForm({super.key});

  @override
  ConsumerState<CreateGoalForm> createState() => _CreateGoalFormState();
}

class _CreateGoalFormState extends ConsumerState<CreateGoalForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _hoursController = TextEditingController();
  
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 7));
  int _priority = 2; // Medium

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _hoursController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref.read(createGoalNotifierProvider.notifier).createGoal(
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      targetHours: int.parse(_hoursController.text.trim()),
      deadline: _selectedDate,
      priority: _priority,
    );

    if (success && mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Goal created successfully!'),
          backgroundColor: AppTheme.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createGoalNotifierProvider);
    final isLoading = state is AsyncLoading;

    return Container(
      padding: EdgeInsets.only(
        top: 24,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.darkCard,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'New Study Goal',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimaryDark,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: AppTheme.textSecondaryDark),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Title
            TextFormField(
              controller: _titleController,
              style: const TextStyle(color: AppTheme.textPrimaryDark),
              decoration: const InputDecoration(
                labelText: 'Goal Title',
                hintText: 'e.g. Master Linear Algebra',
                prefixIcon: Icon(Iconsax.task, color: AppTheme.primaryPurple),
              ),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),

            // Target Hours
            TextFormField(
              controller: _hoursController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: AppTheme.textPrimaryDark),
              decoration: const InputDecoration(
                labelText: 'Target Hours',
                hintText: 'Total hours to study',
                prefixIcon: Icon(Iconsax.timer_1, color: AppTheme.primaryPurple),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Required';
                final h = int.tryParse(v);
                if (h == null || h <= 0) return 'Invalid hours';
                if (h > 1000) return 'Max 1000 hours';
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Deadline
            InkWell(
              onTap: () async {
                final d = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                  builder: (context, child) {
                    return Theme(
                      data: ThemeData.dark().copyWith(
                        colorScheme: const ColorScheme.dark(
                          primary: AppTheme.primaryPurple,
                          onPrimary: Colors.white,
                          surface: AppTheme.darkCard,
                          onSurface: AppTheme.textPrimaryDark,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (d != null) setState(() => _selectedDate = d);
              },
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Deadline',
                  prefixIcon: Icon(Iconsax.calendar_1, color: AppTheme.primaryPurple),
                ),
                child: Text(
                  DateFormat('MMM dd, yyyy').format(_selectedDate),
                  style: const TextStyle(color: AppTheme.textPrimaryDark),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryPurple,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  disabledBackgroundColor: AppTheme.primaryPurple.withOpacity(0.5),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Create Goal',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
