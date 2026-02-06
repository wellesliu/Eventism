import 'package:flutter/material.dart';

import '../../core/theme.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Widget? customAction;
  final double iconSize;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
    this.customAction,
    this.iconSize = 64,
  });

  factory EmptyState.noResults({
    String title = 'No results found',
    String? subtitle = 'Try adjusting your filters or search terms',
    String? actionLabel = 'Clear filters',
    VoidCallback? onAction,
  }) =>
      EmptyState(
        icon: Icons.search_off,
        title: title,
        subtitle: subtitle,
        actionLabel: actionLabel,
        onAction: onAction,
      );

  factory EmptyState.noEvents({
    String title = 'No events yet',
    String? subtitle = 'Check back later for upcoming events',
    VoidCallback? onAction,
  }) =>
      EmptyState(
        icon: Icons.event_busy,
        title: title,
        subtitle: subtitle,
        onAction: onAction,
      );

  factory EmptyState.noFavorites({
    String title = 'No favorites yet',
    String? subtitle = 'Events you favorite will appear here',
    String? actionLabel = 'Browse events',
    VoidCallback? onAction,
  }) =>
      EmptyState(
        icon: Icons.favorite_border,
        title: title,
        subtitle: subtitle,
        actionLabel: actionLabel,
        onAction: onAction,
      );

  factory EmptyState.noVendors({
    String title = 'No vendors found',
    String? subtitle = 'Try adjusting your filters',
    String? actionLabel = 'Clear filters',
    VoidCallback? onAction,
  }) =>
      EmptyState(
        icon: Icons.storefront_outlined,
        title: title,
        subtitle: subtitle,
        actionLabel: actionLabel,
        onAction: onAction,
      );

  factory EmptyState.noOrganizers({
    String title = 'No organizers found',
    String? subtitle = 'Try adjusting your filters',
    String? actionLabel = 'Clear filters',
    VoidCallback? onAction,
  }) =>
      EmptyState(
        icon: Icons.business_outlined,
        title: title,
        subtitle: subtitle,
        actionLabel: actionLabel,
        onAction: onAction,
      );

  factory EmptyState.error({
    String title = 'Something went wrong',
    String? subtitle = 'Please try again later',
    String? actionLabel = 'Retry',
    VoidCallback? onAction,
  }) =>
      EmptyState(
        icon: Icons.error_outline,
        title: title,
        subtitle: subtitle,
        actionLabel: actionLabel,
        onAction: onAction,
      );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: EventismTheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: iconSize,
                color: EventismTheme.primary.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
            if (actionLabel != null || customAction != null) ...[
              const SizedBox(height: 24),
              customAction ??
                  FilledButton(
                    onPressed: onAction,
                    child: Text(actionLabel!),
                  ),
            ],
          ],
        ),
      ),
    );
  }
}

class EmptyStateCompact extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;

  const EmptyStateCompact({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Icon(
            icon,
            size: 32,
            color: EventismTheme.textMuted,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: EventismTheme.textMuted,
                      ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
