import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants.dart';
import '../../../core/theme.dart';
import '../../../data/models/event.dart';
import '../../../shared/widgets/event_badge.dart';

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat(AppConstants.dateFormat);
    final timeFormat = DateFormat(AppConstants.timeFormat);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.go('/event/${event.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Banner
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  event.bannerUrl != null
                      ? Image.network(
                          event.bannerUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _buildPlaceholder(),
                        )
                      : _buildPlaceholder(),
                  // Badges overlay
                  Positioned(
                    top: 8,
                    left: 8,
                    right: 8,
                    child: Row(
                      children: [
                        if (event.isFeatured) ...[
                          const EventBadge(type: EventBadgeType.featured),
                          const SizedBox(width: 6),
                        ],
                        if (event.tags.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: EventismTheme.primary,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              event.tags.first,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        const Spacer(),
                        if (event.priceRange == 'Free')
                          const EventBadge(type: EventBadgeType.free),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Content - compact, no extra spacing after location
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Date
                  if (event.startDateTime != null)
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: EventismTheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          dateFormat.format(event.startDateTime!),
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: EventismTheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: EventismTheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          timeFormat.format(event.startDateTime!),
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: EventismTheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 8),
                  // Title
                  Text(
                    event.name,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Location
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: EventismTheme.textMuted,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          event.locationShort,
                          style: Theme.of(context).textTheme.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: EventismTheme.primary.withValues(alpha: 0.1),
      child: const Center(
        child: Icon(
          Icons.event,
          size: 40,
          color: EventismTheme.primary,
        ),
      ),
    );
  }
}
