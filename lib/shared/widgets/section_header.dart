import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final String? actionPath;
  final VoidCallback? onActionTap;
  final Widget? trailing;
  final EdgeInsets padding;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.actionPath,
    this.onActionTap,
    this.trailing,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) trailing!,
          if (actionLabel != null) _buildAction(context),
        ],
      ),
    );
  }

  Widget _buildAction(BuildContext context) {
    return TextButton(
      onPressed: onActionTap ?? (actionPath != null ? () => context.go(actionPath!) : null),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(actionLabel!),
          const SizedBox(width: 4),
          const Icon(Icons.arrow_forward, size: 16),
        ],
      ),
    );
  }
}

class SectionDivider extends StatelessWidget {
  final EdgeInsets margin;

  const SectionDivider({
    super.key,
    this.margin = const EdgeInsets.symmetric(vertical: 24),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      height: 1,
      color: EventismTheme.border,
    );
  }
}

class SectionContainer extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final String? actionPath;
  final VoidCallback? onActionTap;
  final Widget child;
  final Color? backgroundColor;
  final EdgeInsets contentPadding;

  const SectionContainer({
    super.key,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.actionPath,
    this.onActionTap,
    required this.child,
    this.backgroundColor,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 24),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: title,
            subtitle: subtitle,
            actionLabel: actionLabel,
            actionPath: actionPath,
            onActionTap: onActionTap,
          ),
          Padding(
            padding: contentPadding,
            child: child,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
