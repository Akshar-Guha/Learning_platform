import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/widgets/gradient_button.dart';
import '../providers/squad_providers.dart';

/// Join Squad Screen - Enter invite code to join
class JoinSquadScreen extends ConsumerStatefulWidget {
  const JoinSquadScreen({super.key});

  @override
  ConsumerState<JoinSquadScreen> createState() => _JoinSquadScreenState();
}

class _JoinSquadScreenState extends ConsumerState<JoinSquadScreen> {
  final _codeController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _joinSquad() async {
    final code = _codeController.text.trim().toUpperCase();
    
    if (code.isEmpty) {
      setState(() => _error = 'Please enter an invite code');
      return;
    }
    
    if (code.length != 8) {
      setState(() => _error = 'Invite code must be 8 characters');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final squad = await ref.read(squadNotifierProvider.notifier).joinSquad(code);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Joined "${squad.name}" successfully!'),
            backgroundColor: AppTheme.success,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _error = _parseError(e.toString()));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _parseError(String error) {
    if (error.contains('full')) return 'This squad is full (4/4 members)';
    if (error.contains('not found') || error.contains('no rows')) return 'Invalid invite code';
    if (error.contains('duplicate') || error.contains('unique')) return 'You\'re already in this squad';
    return 'Failed to join squad. Please try again.';
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
          'Join Squad',
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),

                // Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: AppTheme.accentGradient,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.accentCyan.withOpacity(0.3),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: const Icon(Iconsax.login, size: 36, color: Colors.white),
                ).animate().scale(curve: Curves.elasticOut),

                const SizedBox(height: 32),

                const Text(
                  'Enter Invite Code',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryDark,
                  ),
                ).animate().fadeIn(delay: 100.ms),

                const SizedBox(height: 8),

                Text(
                  'Ask your squad owner for the 8-character code',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondaryDark.withOpacity(0.8),
                  ),
                ).animate().fadeIn(delay: 150.ms),

                const SizedBox(height: 40),

                // Code input
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.darkCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _error != null
                          ? AppTheme.error.withOpacity(0.5)
                          : AppTheme.darkBorder,
                    ),
                  ),
                  child: TextField(
                    controller: _codeController,
                    textAlign: TextAlign.center,
                    textCapitalization: TextCapitalization.characters,
                    maxLength: 8,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 6,
                      color: AppTheme.textPrimaryDark,
                    ),
                    decoration: InputDecoration(
                      hintText: 'ABCD1234',
                      hintStyle: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 6,
                        color: AppTheme.textSecondaryDark.withOpacity(0.3),
                      ),
                      counterText: '',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    ),
                    onChanged: (_) {
                      if (_error != null) setState(() => _error = null);
                    },
                  ),
                ).animate().fadeIn(delay: 200.ms),

                // Error message
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _error!,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.error,
                    ),
                  ).animate().fadeIn().shake(),
                ],

                const SizedBox(height: 40),

                // Join button
                GradientButton(
                  text: 'Join Squad',
                  onPressed: _joinSquad,
                  isLoading: _isLoading,
                ).animate().fadeIn(delay: 300.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
