import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_theme.dart';

/// Focus Button - Start/Stop toggle with animated states
class FocusButton extends StatelessWidget {
  final bool isFocusing;
  final bool isLoading;
  final VoidCallback onPressed;

  const FocusButton({
    super.key,
    required this.isFocusing,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: isFocusing
              ? const LinearGradient(
                  colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                )
              : AppTheme.primaryGradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: (isFocusing ? const Color(0xFFEF4444) : AppTheme.primaryPurple)
                  .withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: isLoading
            ? const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isFocusing ? Iconsax.stop : Iconsax.play,
                    color: Colors.white,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    isFocusing ? 'Stop Focus' : 'Start Focus',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
      ),
    ).animate(target: isFocusing ? 1 : 0).shake(hz: 2, duration: 500.ms);
  }
}

/// Active Member Indicator - Green pulsing ring around avatar
class ActiveMemberIndicator extends StatefulWidget {
  final Widget child;
  final bool isActive;
  final double size;

  const ActiveMemberIndicator({
    super.key,
    required this.child,
    required this.isActive,
    this.size = 48,
  });

  @override
  State<ActiveMemberIndicator> createState() => _ActiveMemberIndicatorState();
}

class _ActiveMemberIndicatorState extends State<ActiveMemberIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    if (widget.isActive) _controller.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(ActiveMemberIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _controller.repeat(reverse: true);
    } else if (!widget.isActive && oldWidget.isActive) {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size + 8,
      height: widget.size + 8,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (widget.isActive)
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Container(
                  width: widget.size * _animation.value,
                  height: widget.size * _animation.value,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.success.withOpacity(0.6 * (1.5 - _animation.value)),
                      width: 3,
                    ),
                  ),
                );
              },
            ),
          Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: widget.isActive
                  ? Border.all(color: AppTheme.success, width: 2.5)
                  : null,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(widget.size / 2),
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}

/// Focus Timer - Shows elapsed time with live updates
class FocusTimer extends StatefulWidget {
  final DateTime startedAt;
  final TextStyle? style;

  const FocusTimer({
    super.key,
    required this.startedAt,
    this.style,
  });

  @override
  State<FocusTimer> createState() => _FocusTimerState();
}

class _FocusTimerState extends State<FocusTimer> {
  late Timer _timer;
  Duration _elapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    _updateElapsed();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateElapsed());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateElapsed() {
    setState(() {
      _elapsed = DateTime.now().toUtc().difference(widget.startedAt.toUtc());
    });
  }

  String _formatDuration(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);
    
    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _formatDuration(_elapsed),
      style: widget.style ?? const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppTheme.textPrimaryDark,
        letterSpacing: 1,
      ),
    );
  }
}

/// Squad Presence List - Shows members with focus status
class SquadPresenceList extends StatelessWidget {
  final List<PresenceItem> members;
  final String currentUserId;

  const SquadPresenceList({
    super.key,
    required this.members,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.success,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${members.where((m) => m.isFocusing).length} Focusing Now',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondaryDark.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
        ...members.map((member) => _buildMemberTile(member)),
      ],
    );
  }

  Widget _buildMemberTile(PresenceItem member) {
    final isCurrentUser = member.userId == currentUserId;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.darkCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: member.isFocusing
              ? AppTheme.success.withOpacity(0.4)
              : AppTheme.darkBorder.withOpacity(0.5),
        ),
      ),
      child: Row(
        children: [
          ActiveMemberIndicator(
            isActive: member.isFocusing,
            size: 40,
            child: Container(
              color: AppTheme.primaryPurple.withOpacity(0.3),
              child: Center(
                child: Text(
                  member.displayName.isNotEmpty 
                      ? member.displayName[0].toUpperCase() 
                      : '?',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      member.displayName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimaryDark,
                      ),
                    ),
                    if (isCurrentUser) ...[
                      const SizedBox(width: 6),
                      Text(
                        '(You)',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondaryDark.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  member.isFocusing 
                      ? 'Focusing for ${member.durationMinutes}m' 
                      : 'Offline',
                  style: TextStyle(
                    fontSize: 12,
                    color: member.isFocusing 
                        ? AppTheme.success 
                        : AppTheme.textSecondaryDark.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          if (member.isFocusing)
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.success,
              ),
            ).animate(onPlay: (c) => c.repeat(reverse: true))
              .fadeIn(duration: 800.ms)
              .fadeOut(duration: 800.ms),
        ],
      ),
    );
  }
}

/// Presence item data class
class PresenceItem {
  final String userId;
  final String displayName;
  final String? avatarUrl;
  final bool isFocusing;
  final int durationMinutes;

  const PresenceItem({
    required this.userId,
    required this.displayName,
    this.avatarUrl,
    required this.isFocusing,
    this.durationMinutes = 0,
  });
}
