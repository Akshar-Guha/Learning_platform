import 'dart:async';
import 'package:flutter/foundation.dart';

// Web-specific imports for Wake Lock API
import 'dart:js' as js if (dart.library.io) 'dart:io';
import 'dart:js_util' as js_util if (dart.library.io) 'dart:io';

/// Wake Lock Service - Keeps screen awake during focus sessions
/// Uses the Screen Wake Lock API on web browsers
class WakeLockService {
  dynamic _wakeLock;
  bool _isActive = false;

  bool get isActive => _isActive;

  /// Request wake lock to keep screen awake
  Future<bool> requestWakeLock() async {
    if (!kIsWeb) {
      // On mobile native, this would use platform-specific code
      // For Flutter web, we use Screen Wake Lock API
      return false;
    }

    try {
      final navigator = js.context['navigator'];
      if (navigator == null) return false;

      final wakeLock = navigator['wakeLock'];
      if (wakeLock == null) {
        debugPrint('Wake Lock API not supported');
        return false;
      }

      // Request screen wake lock
      final promise = js_util.callMethod(wakeLock, 'request', ['screen']);
      _wakeLock = await js_util.promiseToFuture(promise);
      _isActive = true;
      
      debugPrint('✓ Wake lock acquired - screen will stay on');
      return true;
    } catch (e) {
      debugPrint('Wake lock failed: $e');
      return false;
    }
  }

  /// Release wake lock to allow screen to sleep
  Future<void> releaseWakeLock() async {
    if (_wakeLock == null) return;

    try {
      await js_util.promiseToFuture(
        js_util.callMethod(_wakeLock, 'release', []),
      );
      _wakeLock = null;
      _isActive = false;
      debugPrint('✓ Wake lock released - screen can sleep');
    } catch (e) {
      debugPrint('Wake lock release failed: $e');
    }
  }

  void dispose() {
    releaseWakeLock();
  }
}
