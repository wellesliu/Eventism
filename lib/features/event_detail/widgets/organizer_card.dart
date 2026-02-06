import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme.dart';
import '../../../data/models/organizer.dart';
import '../../../data/providers/organizers_provider.dart';
import '../../../shared/widgets/social_links.dart';

class OrganizerCard extends ConsumerWidget {
  final String? organizerId;

  const OrganizerCard({super.key, this.organizerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (organizerId == null) {
      return _buildPlaceholderCard(context);
    }

    final organizerAsync = ref.watch(organizerByIdProvider(organizerId!));

    return organizerAsync.when(
      data: (organizer) {
        if (organizer == null) {
          return _buildPlaceholderCard(context);
        }
        return _buildOrganizerCard(context, organizer);
      },
      loading: () => _buildLoadingCard(context),
      error: (_, __) => _buildPlaceholderCard(context),
    );
  }

  Widget _buildOrganizerCard(BuildContext context, Organizer organizer) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: EventismTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: EventismTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Event Organizer',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: EventismTheme.textMuted,
                ),
          ),
          const SizedBox(height: 12),

          // Organizer info
          Row(
            children: [
              // Logo
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: EventismTheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: organizer.logoUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          organizer.logoUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _buildLogoPlaceholder(organizer.name),
                        ),
                      )
                    : _buildLogoPlaceholder(organizer.name),
              ),
              const SizedBox(width: 12),
              // Name and tagline
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      organizer.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    if (organizer.tagline != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        organizer.tagline!,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          // Stats
          if (organizer.eventsPerYear > 0 || organizer.vendorCount > 0) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                if (organizer.eventsPerYear > 0)
                  _buildStat(
                    context,
                    value: '${organizer.eventsPerYear}',
                    label: 'Events/Year',
                  ),
                if (organizer.eventsPerYear > 0 && organizer.vendorCount > 0)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    width: 1,
                    height: 24,
                    color: EventismTheme.border,
                  ),
                if (organizer.vendorCount > 0)
                  _buildStat(
                    context,
                    value: '${organizer.vendorCount}',
                    label: 'Vendors',
                  ),
              ],
            ),
          ],

          // Social links
          if (organizer.hasSocialLinks) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            SocialLinksRow(
              website: organizer.website,
              instagram: organizer.instagram,
              tiktok: organizer.tiktok,
            ),
          ],

          // View profile button
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                context.go('/organizer/${organizer.id}');
              },
              child: const Text('View Profile'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(BuildContext context, {required String value, required String label}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: EventismTheme.primary,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildLogoPlaceholder(String name) {
    return Center(
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : 'O',
        style: const TextStyle(
          color: EventismTheme.primary,
          fontWeight: FontWeight.w700,
          fontSize: 24,
        ),
      ),
    );
  }

  Widget _buildPlaceholderCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: EventismTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: EventismTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Event Organizer',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: EventismTheme.textMuted,
                ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: EventismTheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.business,
                  color: EventismTheme.primary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Event Organizer',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Organizer details coming soon',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: null,
              child: const Text('View Profile'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: EventismTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: EventismTheme.border),
      ),
      child: const Center(
        child: SizedBox(
          height: 100,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
