import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants.dart';
import '../../../core/theme.dart';
import '../../../data/models/event.dart';
import '../../../data/providers/events_provider.dart';

class FeaturedEvents extends ConsumerWidget {
  const FeaturedEvents({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(featuredEventsProvider);
    final width = MediaQuery.sizeOf(context).width;
    final columns = Breakpoints.getGridColumns(width);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Featured Events',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            TextButton(
              onPressed: () => context.go('/browse'),
              child: const Text('View all'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        eventsAsync.when(
          data: (events) {
            if (events.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text('No upcoming events'),
                ),
              );
            }
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              itemCount: events.length,
              itemBuilder: (context, index) {
                return _FeaturedEventCard(event: events[index]);
              },
            );
          },
          loading: () => GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            itemCount: 6,
            itemBuilder: (context, index) => const _SkeletonCard(),
          ),
          error: (error, _) => Center(
            child: Text('Failed to load events: $error'),
          ),
        ),
      ],
    );
  }
}

class _FeaturedEventCard extends StatelessWidget {
  final Event event;

  const _FeaturedEventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat(AppConstants.dateFormat);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.go('/event/${event.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Banner image
            AspectRatio(
              aspectRatio: 16 / 9,
              child: event.bannerUrl != null
                  ? Image.network(
                      event.bannerUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _buildPlaceholder(),
                    )
                  : _buildPlaceholder(),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date badge
                    if (event.startDateTime != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: EventsiaTheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          dateFormat.format(event.startDateTime!),
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: EventsiaTheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    const SizedBox(height: 8),
                    // Title
                    Text(
                      event.name,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    // Location
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: EventsiaTheme.textMuted,
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: EventsiaTheme.primary.withValues(alpha: 0.1),
      child: const Center(
        child: Icon(
          Icons.event,
          size: 40,
          color: EventsiaTheme.primary,
        ),
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              color: EventsiaTheme.border,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 80,
                    height: 20,
                    decoration: BoxDecoration(
                      color: EventsiaTheme.border,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    height: 16,
                    decoration: BoxDecoration(
                      color: EventsiaTheme.border,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 120,
                    height: 16,
                    decoration: BoxDecoration(
                      color: EventsiaTheme.border,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
