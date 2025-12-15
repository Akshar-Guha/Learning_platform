import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/widgets/auth_text_field.dart';
import '../../../auth/presentation/widgets/gradient_button.dart';
import '../providers/squad_providers.dart';

/// Create Squad Screen - Form to create a new squad
class CreateSquadScreen extends ConsumerStatefulWidget {
  const CreateSquadScreen({super.key});

  @override
  ConsumerState<CreateSquadScreen> createState() => _CreateSquadScreenState();
}

class _CreateSquadScreenState extends ConsumerState<CreateSquadScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _createSquad() async {
    if (_isLoading) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final squad = await ref.read(squadNotifierProvider.notifier).createSquad(
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Squad "${squad.name}" created!'),
            backgroundColor: AppTheme.success,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left, color: AppTheme.textPrimaryDark),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Create Squad',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimaryDark,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F0F1A), AppTheme.darkBg],
            stops: [0.0, 0.3],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryPurple.withOpacity(0.3),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: const Icon(Iconsax.people, size: 36, color: Colors.white),
                    ),
                  ).animate().scale(curve: Curves.elasticOut),
                  
                  const SizedBox(height: 32),

                  // Name field
                  AuthTextField(
                    controller: _nameController,
                    label: 'Squad Name',
                    hint: 'Enter a name for your squad',
                    prefixIcon: Iconsax.tag,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Squad name is required';
                      }
                      if (value.length > 50) {
                        return 'Name must be 50 characters or less';
                      }
                      return null;
                    },
                  ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1, end: 0),

                  const SizedBox(height: 20),

                  // Description field
                  AuthTextField(
                    controller: _descriptionController,
                    label: 'Description (Optional)',
                    hint: 'What is this squad about?',
                    prefixIcon: Iconsax.document_text,
                    maxLines: 3,
                    validator: (value) {
                      if (value != null && value.length > 200) {
                        return 'Description must be 200 characters or less';
                      }
                      return null;
                    },
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),

                  const SizedBox(height: 16),

                  // Info card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryPurple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.primaryPurple.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        Icon(Iconsax.info_circle, color: AppTheme.primaryPurple.withOpacity(0.8), size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'You\'ll get a unique invite code to share with up to 3 teammates.',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.textSecondaryDark.withOpacity(0.9),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 300.ms),

                  const SizedBox(height: 40),

                  // Create button
                  GradientButton(
                    text: 'Create Squad',
                    onPressed: _createSquad,
                    isLoading: _isLoading,
                  ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
