import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_theme.dart';

/// Invite Code Widget - Displays code with copy and share functionality
class InviteCodeWidget extends StatefulWidget {
  final String inviteCode;
  final VoidCallback? onRegenerate;
  final bool isOwner;

  const InviteCodeWidget({
    super.key,
    required this.inviteCode,
    this.onRegenerate,
    this.isOwner = false,
  });

  @override
  State<InviteCodeWidget> createState() => _InviteCodeWidgetState();
}

class _InviteCodeWidgetState extends State<InviteCodeWidget> {
  bool _copied = false;

  void _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: widget.inviteCode));
    setState(() => _copied = true);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Invite code copied!'),
        backgroundColor: AppTheme.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 2),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.darkCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryPurple.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Iconsax.key,
                size: 18,
                color: AppTheme.primaryPurple.withOpacity(0.8),
              ),
              const SizedBox(width: 8),
              const Text(
                'Invite Code',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textSecondaryDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Code display
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.darkBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppTheme.darkBorder),
                  ),
                  child: Text(
                    widget.inviteCode,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 3,
                      color: AppTheme.textPrimaryDark,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              
              // Copy button
              _ActionButton(
                icon: _copied ? Icons.check : Iconsax.copy,
                onTap: _copyToClipboard,
                color: _copied ? AppTheme.success : AppTheme.primaryPurple,
              ),
            ],
          ),
          
          // Regenerate button (owner only)
          if (widget.isOwner && widget.onRegenerate != null) ...[
            const SizedBox(height: 12),
            GestureDetector(
              onTap: widget.onRegenerate,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Iconsax.refresh,
                    size: 14,
                    color: AppTheme.textSecondaryDark.withOpacity(0.7),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Generate new code',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondaryDark.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  const _ActionButton({
    required this.icon,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
    );
  }
}
