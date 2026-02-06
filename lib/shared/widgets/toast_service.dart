import 'package:flutter/material.dart';

import '../../core/theme.dart';

class ToastService {
  static void show(
    BuildContext context,
    String message, {
    IconData? icon,
    Duration duration = const Duration(seconds: 2),
    ToastType type = ToastType.info,
  }) {
    final config = _getToastConfig(type);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: config.iconColor,
                size: 20,
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: config.textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: config.backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(16),
        duration: duration,
        dismissDirection: DismissDirection.horizontal,
      ),
    );
  }

  static void success(BuildContext context, String message, {IconData? icon}) {
    show(
      context,
      message,
      icon: icon ?? Icons.check_circle,
      type: ToastType.success,
    );
  }

  static void error(BuildContext context, String message, {IconData? icon}) {
    show(
      context,
      message,
      icon: icon ?? Icons.error,
      type: ToastType.error,
      duration: const Duration(seconds: 4),
    );
  }

  static void warning(BuildContext context, String message, {IconData? icon}) {
    show(
      context,
      message,
      icon: icon ?? Icons.warning,
      type: ToastType.warning,
    );
  }

  static void info(BuildContext context, String message, {IconData? icon}) {
    show(
      context,
      message,
      icon: icon ?? Icons.info,
      type: ToastType.info,
    );
  }

  static _ToastConfig _getToastConfig(ToastType type) {
    switch (type) {
      case ToastType.success:
        return _ToastConfig(
          backgroundColor: EventismTheme.success,
          textColor: Colors.white,
          iconColor: Colors.white,
        );
      case ToastType.error:
        return _ToastConfig(
          backgroundColor: EventismTheme.error,
          textColor: Colors.white,
          iconColor: Colors.white,
        );
      case ToastType.warning:
        return _ToastConfig(
          backgroundColor: EventismTheme.warning,
          textColor: Colors.white,
          iconColor: Colors.white,
        );
      case ToastType.info:
        return _ToastConfig(
          backgroundColor: EventismTheme.textPrimary,
          textColor: Colors.white,
          iconColor: Colors.white,
        );
    }
  }
}

enum ToastType { success, error, warning, info }

class _ToastConfig {
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;

  const _ToastConfig({
    required this.backgroundColor,
    required this.textColor,
    required this.iconColor,
  });
}
