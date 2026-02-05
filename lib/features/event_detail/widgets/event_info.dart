import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/constants.dart';
import '../../../core/theme.dart';
import '../../../data/models/event.dart';

class EventInfo extends StatelessWidget {
  final Event event;

  const EventInfo({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat(AppConstants.dateTimeFormat);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Quick info cards
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            // Date & Time
            if (event.startDateTime != null)
              _InfoCard(
                icon: Icons.calendar_today,
                title: 'Date & Time',
                content: dateFormat.format(event.startDateTime!),
                subtitle: event.endDateTime != null
                    ? 'Until ${dateFormat.format(event.endDateTime!)}'
                    : null,
              ),
            // Location
            _InfoCard(
              icon: Icons.location_on,
              title: 'Location',
              content: event.locationShort,
              subtitle: event.location,
            ),
            // Vendors
            if (event.acceptsVendors)
              _InfoCard(
                icon: Icons.store,
                title: 'Vendors',
                content: 'Applications Open',
                subtitle: event.vendorApplicationDeadline != null
                    ? 'Deadline: ${event.vendorApplicationDeadline}'
                    : null,
                accentColor: EventsiaTheme.success,
              ),
          ],
        ),
        const SizedBox(height: 32),

        // Description
        Text(
          'About This Event',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        if (event.description != null && event.description!.isNotEmpty)
          SelectableText(
            event.description!,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.7,
                ),
          )
        else
          Text(
            'No description available.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: EventsiaTheme.textMuted,
                  fontStyle: FontStyle.italic,
                ),
          ),

        // Tags
        if (event.tags.isNotEmpty) ...[
          const SizedBox(height: 32),
          Text(
            'Tags',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: event.tags.map((tag) {
              return Chip(
                label: Text(tag),
                backgroundColor: EventsiaTheme.primary.withValues(alpha: 0.1),
                labelStyle: const TextStyle(
                  color: EventsiaTheme.primary,
                ),
                side: BorderSide.none,
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  final String? subtitle;
  final Color? accentColor;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.content,
    this.subtitle,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? EventsiaTheme.primary;

    return Container(
      constraints: const BoxConstraints(minWidth: 200, maxWidth: 300),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: EventsiaTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: EventsiaTheme.border),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: EventsiaTheme.textMuted,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  content,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
