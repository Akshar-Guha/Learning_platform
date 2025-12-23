import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Web-specific imports
import 'dart:html' as html if (dart.library.io) 'dart:io';

/// Focus Visibility Service - Tracks page visibility for accurate focus time
/// Uses the Page Visibility API on web to detect tab switches
class FocusVisibilityService extends ChangeNotifier {
  bool _isPageVisible = true;
  bool _isFocusPageActive = false;
  final _visibilityController = StreamController<bool>.broadcast();

  bool get isPageVisible => _isPageVisible;
  bool get isFocusPageActive => _isFocusPageActive;
  Stream<bool> get visibilityStream => _visibilityController.stream;

  FocusVisibilityService() {
    _initVisibilityListener();
  }

  void _initVisibilityListener() {
    if (kIsWeb) {
      // Web: Use Page Visibility API
      _setupWebVisibilityListener();
    }
    // On mobile, visibility is handled by WidgetsBindingObserver in the screen
  }

  void _setupWebVisibilityListener() {
    // Listen to visibility change events
    html.document.addEventListener('visibilitychange', (event) {
      final isVisible = html.document.visibilityState == 'visible';
      _updateVisibility(isVisible);
    });

    // Also listen to page focus/blur
    html.window.addEventListener('focus', (event) {
      _updateVisibility(true);
    });

    html.window.addEventListener('blur', (event) {
      _updateVisibility(false);
    });
  }

  void _updateVisibility(bool isVisible) {
    if (_isPageVisible != isVisible) {
      _isPageVisible = isVisible;
      _visibilityController.add(isVisible);
      notifyListeners();
    }
  }

  /// Call when entering the Focus page
  void enterFocusPage() {
    _isFocusPageActive = true;
    notifyListeners();
  }

  /// Call when leaving the Focus page
  void leaveFocusPage() {
    _isFocusPageActive = false;
    notifyListeners();
  }

  /// Check if focus tracking should be active
  bool get shouldTrackFocus => _isPageVisible && _isFocusPageActive;

  @override
  void dispose() {
    _visibilityController.close();
    super.dispose();
  }
}

/// Provider for the Focus Visibility Service
final focusVisibilityServiceProvider = ChangeNotifierProvider<FocusVisibilityService>((ref) {
  return FocusVisibilityService();
});

/// Provider for the current visibility state
final isPageVisibleProvider = Provider<bool>((ref) {
  return ref.watch(focusVisibilityServiceProvider).isPageVisible;
});

/// Provider for the visibility stream
final visibilityStreamProvider = StreamProvider<bool>((ref) {
  return ref.watch(focusVisibilityServiceProvider).visibilityStream;
});
