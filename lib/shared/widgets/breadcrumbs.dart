import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme.dart';

class BreadcrumbItem {
  final String label;
  final String? path;

  const BreadcrumbItem({
    required this.label,
    this.path,
  });
}

class Breadcrumbs extends StatelessWidget {
  final List<BreadcrumbItem> items;
  final double fontSize;

  const Breadcrumbs({
    super.key,
    required this.items,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < items.length; i++) ...[
          if (i > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Icon(
                Icons.chevron_right,
                size: fontSize + 2,
                color: EventismTheme.textMuted,
              ),
            ),
          _BreadcrumbChip(
            item: items[i],
            isLast: i == items.length - 1,
            fontSize: fontSize,
          ),
        ],
      ],
    );
  }
}

class _BreadcrumbChip extends StatelessWidget {
  final BreadcrumbItem item;
  final bool isLast;
  final double fontSize;

  const _BreadcrumbChip({
    required this.item,
    required this.isLast,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: fontSize,
      color: isLast ? EventismTheme.textPrimary : EventismTheme.textSecondary,
      fontWeight: isLast ? FontWeight.w500 : FontWeight.w400,
    );

    if (item.path == null || isLast) {
      return Text(
        item.label,
        style: textStyle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    return InkWell(
      onTap: () => context.go(item.path!),
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Text(
          item.label,
          style: textStyle.copyWith(
            decoration: TextDecoration.underline,
            decorationColor: EventismTheme.textMuted,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class PageBreadcrumbs extends StatelessWidget {
  final List<BreadcrumbItem> items;

  const PageBreadcrumbs({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: const BoxDecoration(
        color: EventismTheme.surface,
        border: Border(
          bottom: BorderSide(color: EventismTheme.border),
        ),
      ),
      child: Breadcrumbs(items: items),
    );
  }
}
