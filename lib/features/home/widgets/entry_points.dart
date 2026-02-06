import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/theme.dart';

class EntryPoints extends StatelessWidget {
  const EntryPoints({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = Breakpoints.isMobile(width);

    final entries = [
      _EntryPoint(
        icon: Icons.event,
        title: 'Find Events',
        description: 'Discover markets, festivals, and experiences happening near you',
        action: 'Browse Events',
        route: '/browse',
        color: EventismTheme.primary,
      ),
      _EntryPoint(
        icon: Icons.storefront,
        title: 'Vendor Opportunities',
        description: 'Find events accepting vendors and grow your business',
        action: 'Find Opportunities',
        route: '/browse?vendors=true',
        color: EventismTheme.cta,
      ),
      _EntryPoint(
        icon: Icons.business,
        title: 'For Organizers',
        description: 'List your events and connect with vendors',
        action: 'Get Started',
        route: '/organizers',
        color: EventismTheme.warning,
      ),
    ];

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 64,
        vertical: isMobile ? 32 : 48,
      ),
      child: isMobile
          ? Column(
              children: entries
                  .map((e) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildEntryCard(context, e, isMobile),
                      ))
                  .toList(),
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: entries
                  .map((e) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: _buildEntryCard(context, e, isMobile),
                        ),
                      ))
                  .toList(),
            ),
    );
  }

  Widget _buildEntryCard(BuildContext context, _EntryPoint entry, bool isMobile) {
    return Material(
      color: EventismTheme.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () => context.go(entry.route),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: EventismTheme.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: entry.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  entry.icon,
                  color: entry.color,
                  size: 28,
                ),
              ),
              const SizedBox(height: 16),
              // Title
              Text(
                entry.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              // Description
              Text(
                entry.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              // Action button
              Row(
                children: [
                  Text(
                    entry.action,
                    style: TextStyle(
                      color: entry.color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: entry.color,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EntryPoint {
  final IconData icon;
  final String title;
  final String description;
  final String action;
  final String route;
  final Color color;

  _EntryPoint({
    required this.icon,
    required this.title,
    required this.description,
    required this.action,
    required this.route,
    required this.color,
  });
}
