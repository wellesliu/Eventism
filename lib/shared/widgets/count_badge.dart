import 'package:flutter/material.dart';

import '../../core/theme.dart';

/// A badge that displays a count value, typically used on tabs or icons.
class CountBadge extends StatelessWidget {
  final int count;
  final Color? backgroundColor;
  final Color? textColor;
  final double size;
  final bool showZero;

  const CountBadge({
    super.key,
    required this.count,
    this.backgroundColor,
    this.textColor,
    this.size = 20,
    this.showZero = false,
  });

  @override
  Widget build(BuildContext context) {
    if (count == 0 && !showZero) {
      return const SizedBox.shrink();
    }

    final displayText = count > 99 ? '99+' : count.toString();

    return Container(
      constraints: BoxConstraints(
        minWidth: size,
        minHeight: size,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: count > 9 ? 6 : 0,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? EventismTheme.error,
        borderRadius: BorderRadius.circular(size / 2),
      ),
      child: Center(
        child: Text(
          displayText,
          style: TextStyle(
            color: textColor ?? Colors.white,
            fontSize: size * 0.6,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/// A widget with an optional count badge overlay.
class WithCountBadge extends StatelessWidget {
  final Widget child;
  final int count;
  final Color? badgeColor;
  final Alignment alignment;
  final Offset offset;
  final bool showZero;

  const WithCountBadge({
    super.key,
    required this.child,
    required this.count,
    this.badgeColor,
    this.alignment = Alignment.topRight,
    this.offset = const Offset(8, -8),
    this.showZero = false,
  });

  @override
  Widget build(BuildContext context) {
    if (count == 0 && !showZero) {
      return child;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          top: alignment == Alignment.topRight || alignment == Alignment.topLeft
              ? offset.dy
              : null,
          bottom: alignment == Alignment.bottomRight || alignment == Alignment.bottomLeft
              ? offset.dy
              : null,
          right: alignment == Alignment.topRight || alignment == Alignment.bottomRight
              ? offset.dx
              : null,
          left: alignment == Alignment.topLeft || alignment == Alignment.bottomLeft
              ? offset.dx
              : null,
          child: CountBadge(
            count: count,
            backgroundColor: badgeColor,
          ),
        ),
      ],
    );
  }
}

/// A chip that displays a label with an optional count.
class CountChip extends StatelessWidget {
  final String label;
  final int? count;
  final bool selected;
  final VoidCallback? onTap;
  final IconData? icon;

  const CountChip({
    super.key,
    required this.label,
    this.count,
    this.selected = false,
    this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? EventismTheme.primary.withValues(alpha: 0.15)
          : EventismTheme.background,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(
              color: selected ? EventismTheme.primary : EventismTheme.border,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 16,
                  color: selected ? EventismTheme.primary : EventismTheme.textSecondary,
                ),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: TextStyle(
                  color: selected ? EventismTheme.primary : EventismTheme.textPrimary,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 14,
                ),
              ),
              if (count != null && count! > 0) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: selected
                        ? EventismTheme.primary
                        : EventismTheme.textMuted.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    count! > 99 ? '99+' : count.toString(),
                    style: TextStyle(
                      color: selected ? Colors.white : EventismTheme.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
