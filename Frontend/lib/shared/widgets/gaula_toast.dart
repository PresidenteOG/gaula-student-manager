import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../core/constants/app_colors.dart';
import '../../router/app_router.dart';

enum GaulaToastType { success, error, info, warning }

class _ToastData {
  final String id;
  final String message;
  final String? title;
  final GaulaToastType type;
  final Duration duration;

  _ToastData({
    required this.id,
    required this.message,
    this.title,
    required this.type,
    required this.duration,
  });
}

class GaulaToast {
  static final List<_ToastData> _notifications = [];
  static OverlayEntry? _overlayEntry;

  static void show(
    BuildContext? context, {
    required String message,
    String? title,
    GaulaToastType type = GaulaToastType.info,
    Duration duration = const Duration(seconds: 4),
  }) {
    final String id = DateTime.now().millisecondsSinceEpoch.toString();
    final newToast = _ToastData(
      id: id,
      message: message,
      title: title,
      type: type,
      duration: duration,
    );

    _notifications.insert(0, newToast);
    if (_notifications.length > 3) {
      _notifications.removeLast();
    }

    _updateOverlay(context);

    Future.delayed(duration, () {
      _removeToast(id);
    });
  }

  static void _removeToast(String id) {
    _notifications.removeWhere((t) => t.id == id);
    if (_notifications.isEmpty) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    } else {
      _overlayEntry?.markNeedsBuild();
    }
  }

  static void _updateOverlay(BuildContext? context) {
    if (_overlayEntry == null) {
      _overlayEntry = OverlayEntry(
        builder: (_) => _GaulaToastQueue(
          notifications: _notifications,
          onDismiss: (id) => _removeToast(id),
        ),
      );
      
      OverlayState? overlay;
      if (context != null) {
        overlay = Overlay.of(context, rootOverlay: true);
      } else {
        overlay = rootNavigatorKey.currentState?.overlay;
      }

      if (overlay != null) {
        overlay.insert(_overlayEntry!);
      } else {
        debugPrint('⚠️ [GAULA] No se pudo encontrar el Overlay para mostrar el Toast.');
      }
    } else {
      _overlayEntry!.markNeedsBuild();
    }
  }
}

class _GaulaToastQueue extends StatelessWidget {
  final List<_ToastData> notifications;
  final Function(String) onDismiss;

  const _GaulaToastQueue({
    required this.notifications,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: notifications.map((toast) => Padding(
            key: ValueKey(toast.id),
            padding: const EdgeInsets.only(bottom: 12),
            child: _GaulaToastWidget(
              message: toast.message,
              title: toast.title,
              type: toast.type,
              onDismiss: () => onDismiss(toast.id),
            ),
          )).toList(),
        ),
      ),
    );
  }
}

class _GaulaToastWidget extends StatelessWidget {
  final String message;
  final String? title;
  final GaulaToastType type;
  final VoidCallback onDismiss;

  const _GaulaToastWidget({
    required this.message,
    this.title,
    required this.type,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    Color color;
    IconData icon;
    switch (type) {
      case GaulaToastType.success:
        color = AppColors.success;
        icon = Icons.check_circle_rounded;
        break;
      case GaulaToastType.error:
        color = AppColors.error;
        icon = Icons.error_rounded;
        break;
      case GaulaToastType.warning:
        color = AppColors.warning;
        icon = Icons.warning_rounded;
        break;
      case GaulaToastType.info:
        color = AppColors.primary;
        icon = Icons.info_rounded;
        break;
    }

    return FadeInRight(
      duration: const Duration(milliseconds: 400),
      child: Container(
        width: 380,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.1),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title != null)
                    Text(
                      title!.toUpperCase(),
                      style: TextStyle(
                        color: color,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: TextStyle(
                      color: isDark ? Colors.white : AppColors.textDark,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            IconButton(
              icon: const Icon(Icons.close_rounded, size: 18),
              onPressed: onDismiss,
              color: isDark ? Colors.white38 : Colors.black26,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }
}

