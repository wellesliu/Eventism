import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme.dart';
import '../../../data/models/event.dart';
import '../../../data/providers/favorites_provider.dart';
import '../../../shared/widgets/event_interest_dialog.dart';
import '../../../shared/widgets/share_sheet.dart';
import '../../../shared/widgets/toast_service.dart';

class CtaButtons extends ConsumerWidget {
  final Event event;

  const CtaButtons({super.key, required this.event});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(isEventFavoritedProvider(event.id));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Interest count
            if (event.interestCount > 0)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite,
                      size: 18,
                      color: EventismTheme.error.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${event.interestCount} people interested',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: EventismTheme.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),

            // Price info
            if (event.priceRange != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: event.priceRange == 'Free'
                        ? EventismTheme.success.withValues(alpha: 0.1)
                        : EventismTheme.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        event.priceRange == 'Free' ? Icons.celebration : Icons.confirmation_number,
                        size: 20,
                        color: event.priceRange == 'Free'
                            ? EventismTheme.success
                            : EventismTheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        event.priceRange!,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: event.priceRange == 'Free'
                                  ? EventismTheme.success
                                  : EventismTheme.textPrimary,
                            ),
                      ),
                    ],
                  ),
                ),
              ),

            // Get Tickets button
            FilledButton.icon(
              onPressed: () {
                showEventInterestDialog(context, event);
              },
              icon: const Icon(Icons.confirmation_number),
              label: Text(event.priceRange == 'Free' ? 'Register Interest' : 'Get Tickets'),
              style: FilledButton.styleFrom(
                backgroundColor: EventismTheme.cta,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),

            const SizedBox(height: 16),

            // Favorite and Share buttons
            Row(
              children: [
                // Favorite button
                Expanded(
                  child: _FavoriteButton(
                    eventId: event.id,
                    isFavorite: isFavorite,
                  ),
                ),
                const SizedBox(width: 12),
                // Share button
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _shareEvent(context),
                    icon: const Icon(Icons.share, size: 20),
                    label: const Text('Share'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Add to calendar
            OutlinedButton.icon(
              onPressed: () {
                _showComingSoonDialog(context, 'Add to Calendar');
              },
              icon: const Icon(Icons.calendar_today, size: 20),
              label: const Text('Add to Calendar'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _shareEvent(BuildContext context) {
    final eventUrl = 'https://eventism.com/event/${event.id}';
    showShareSheet(
      context,
      title: event.name,
      url: eventUrl,
      description: event.description,
    );
  }

  void _showComingSoonDialog(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Coming Soon'),
        content: Text(
          '$feature functionality will be available soon. '
          'This is a demo version of Eventism.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class _FavoriteButton extends ConsumerWidget {
  final String eventId;
  final bool isFavorite;

  const _FavoriteButton({
    required this.eventId,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: isFavorite
          ? FilledButton.icon(
              onPressed: () {
                ref.read(favoritesProvider.notifier).toggleFavorite(eventId);
                ToastService.info(context, 'Removed from favorites');
              },
              icon: const Icon(Icons.favorite, size: 20),
              label: const Text('Saved'),
              style: FilledButton.styleFrom(
                backgroundColor: EventismTheme.error,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            )
          : OutlinedButton.icon(
              onPressed: () {
                ref.read(favoritesProvider.notifier).toggleFavorite(eventId);
                ToastService.success(context, 'Added to favorites');
              },
              icon: const Icon(Icons.favorite_border, size: 20),
              label: const Text('Save'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
    );
  }
}
