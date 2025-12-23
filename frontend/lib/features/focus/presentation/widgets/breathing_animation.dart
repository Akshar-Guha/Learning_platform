import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Breathing Animation Widget - Soothing ambient animation for focus sessions
/// Features:
/// - Pulsing concentric circles (breathing effect)
/// - Subtle aurora gradient flow
/// - Minimal floating particles
class BreathingAnimation extends StatefulWidget {
  final bool isActive;
  final Widget? child;

  const BreathingAnimation({
    super.key,
    this.isActive = true,
    this.child,
  });

  @override
  State<BreathingAnimation> createState() => _BreathingAnimationState();
}

class _BreathingAnimationState extends State<BreathingAnimation>
    with TickerProviderStateMixin {
  late AnimationController _breatheController;
  late AnimationController _auroraController;
  late AnimationController _particleController;

  late Animation<double> _breatheAnimation;
  late Animation<double> _auroraAnimation;

  @override
  void initState() {
    super.initState();

    // Breathing animation - 4 second cycle (inhale + exhale)
    _breatheController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _breatheAnimation = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _breatheController, curve: Curves.easeInOut),
    );

    // Aurora gradient animation - slow rotation
    _auroraController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );
    _auroraAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _auroraController, curve: Curves.linear),
    );

    // Particle drift animation
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    );

    if (widget.isActive) {
      _startAnimations();
    }
  }

  void _startAnimations() {
    _breatheController.repeat(reverse: true);
    _auroraController.repeat();
    _particleController.repeat();
  }

  void _stopAnimations() {
    _breatheController.stop();
    _auroraController.stop();
    _particleController.stop();
  }

  @override
  void didUpdateWidget(BreathingAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _startAnimations();
    } else if (!widget.isActive && oldWidget.isActive) {
      _stopAnimations();
    }
  }

  @override
  void dispose() {
    _breatheController.dispose();
    _auroraController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isActive) {
      return widget.child ?? const SizedBox.shrink();
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        // Aurora background
        AnimatedBuilder(
          animation: _auroraAnimation,
          builder: (context, child) {
            return CustomPaint(
              size: Size.infinite,
              painter: _AuroraPainter(
                angle: _auroraAnimation.value,
                colors: [
                  AppTheme.primaryPurple.withOpacity(0.15),
                  AppTheme.accentCyan.withOpacity(0.1),
                  AppTheme.success.withOpacity(0.08),
                ],
              ),
            );
          },
        ),

        // Floating particles
        AnimatedBuilder(
          animation: _particleController,
          builder: (context, child) {
            return CustomPaint(
              size: Size.infinite,
              painter: _ParticlePainter(
                progress: _particleController.value,
              ),
            );
          },
        ),

        // Breathing circles
        AnimatedBuilder(
          animation: _breatheAnimation,
          builder: (context, child) {
            return _buildBreathingCircles(_breatheAnimation.value);
          },
        ),

        // Child content (focus icon, timer, etc.)
        if (widget.child != null) widget.child!,
      ],
    );
  }

  Widget _buildBreathingCircles(double scale) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer ring
        Container(
          width: 200 * scale,
          height: 200 * scale,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppTheme.success.withOpacity(0.1),
              width: 1,
            ),
          ),
        ),
        // Middle ring
        Container(
          width: 160 * scale,
          height: 160 * scale,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppTheme.success.withOpacity(0.2),
              width: 2,
            ),
          ),
        ),
        // Inner ring
        Container(
          width: 120 * scale,
          height: 120 * scale,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.success.withOpacity(0.1),
            border: Border.all(
              color: AppTheme.success.withOpacity(0.3),
              width: 2,
            ),
          ),
        ),
      ],
    );
  }
}

/// Aurora background painter
class _AuroraPainter extends CustomPainter {
  final double angle;
  final List<Color> colors;

  _AuroraPainter({required this.angle, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.8;

    final paint = Paint()
      ..shader = SweepGradient(
        center: Alignment.center,
        startAngle: angle,
        endAngle: angle + 2 * math.pi,
        colors: [...colors, colors.first],
        stops: const [0.0, 0.33, 0.66, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 50);

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant _AuroraPainter oldDelegate) {
    return oldDelegate.angle != angle;
  }
}

/// Floating particles painter
class _ParticlePainter extends CustomPainter {
  final double progress;
  static final List<_Particle> _particles = List.generate(
    15,
    (i) => _Particle(
      x: (i * 0.07) % 1.0,
      y: (i * 0.13) % 1.0,
      size: 2.0 + (i % 3),
      speed: 0.3 + (i % 5) * 0.1,
    ),
  );

  _ParticlePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.3);

    for (final particle in _particles) {
      final x = (particle.x + progress * particle.speed) % 1.0 * size.width;
      final y = (particle.y + progress * particle.speed * 0.5) % 1.0 * size.height;
      canvas.drawCircle(Offset(x, y), particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _Particle {
  final double x;
  final double y;
  final double size;
  final double speed;

  _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
  });
}
