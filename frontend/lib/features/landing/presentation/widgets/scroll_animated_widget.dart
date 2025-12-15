import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Wrapper widget that animates children when they scroll into view
/// Uses visibility detection to trigger animations
class ScrollAnimatedWidget extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final Offset slideOffset;
  final bool fadeIn;
  final bool slideIn;
  final bool scaleIn;
  final Curve curve;

  const ScrollAnimatedWidget({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 600),
    this.slideOffset = const Offset(0, 30),
    this.fadeIn = true,
    this.slideIn = true,
    this.scaleIn = false,
    this.curve = Curves.easeOutCubic,
  });

  @override
  State<ScrollAnimatedWidget> createState() => _ScrollAnimatedWidgetState();
}

class _ScrollAnimatedWidgetState extends State<ScrollAnimatedWidget> {
  bool _isVisible = false;
  final GlobalKey _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Delay check to ensure widget is mounted
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkVisibility();
    });
  }

  void _checkVisibility() {
    if (!mounted) return;
    
    final RenderObject? renderObject = _key.currentContext?.findRenderObject();
    if (renderObject is RenderBox) {
      final position = renderObject.localToGlobal(Offset.zero);
      final screenHeight = MediaQuery.of(context).size.height;
      
      // Trigger when widget is 80% into view
      if (position.dy < screenHeight * 0.9 && position.dy > -renderObject.size.height) {
        if (!_isVisible) {
          setState(() => _isVisible = true);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        _checkVisibility();
        return false;
      },
      child: Container(
        key: _key,
        child: _isVisible
            ? _buildAnimatedChild()
            : Opacity(opacity: 0, child: widget.child),
      ),
    );
  }

  Widget _buildAnimatedChild() {
    Widget animatedChild = widget.child;

    if (widget.fadeIn) {
      animatedChild = animatedChild
          .animate(delay: widget.delay)
          .fadeIn(duration: widget.duration, curve: widget.curve);
    }

    if (widget.slideIn) {
      animatedChild = animatedChild.animate(delay: widget.delay).move(
            begin: widget.slideOffset,
            end: Offset.zero,
            duration: widget.duration,
            curve: widget.curve,
          );
    }

    if (widget.scaleIn) {
      animatedChild = animatedChild.animate(delay: widget.delay).scale(
            begin: const Offset(0.8, 0.8),
            end: const Offset(1, 1),
            duration: widget.duration,
            curve: widget.curve,
          );
    }

    return animatedChild;
  }
}

/// Simple fade-slide animation without visibility detection (for immediate use)
class AnimatedSection extends StatelessWidget {
  final Widget child;
  final int index;
  final Duration baseDelay;

  const AnimatedSection({
    super.key,
    required this.child,
    this.index = 0,
    this.baseDelay = const Duration(milliseconds: 100),
  });

  @override
  Widget build(BuildContext context) {
    return child
        .animate()
        .fadeIn(
          duration: 600.ms,
          delay: Duration(milliseconds: baseDelay.inMilliseconds * index),
        )
        .slideY(
          begin: 0.1,
          end: 0,
          duration: 600.ms,
          delay: Duration(milliseconds: baseDelay.inMilliseconds * index),
          curve: Curves.easeOutCubic,
        );
  }
}
