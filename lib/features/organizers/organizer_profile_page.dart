import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../data/models/organizer.dart';
import '../../data/providers/organizers_provider.dart';
import '../../data/providers/events_provider.dart';
import '../../shared/widgets/breadcrumbs.dart';
import '../../shared/widgets/contact_dialog.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/social_links.dart';
import '../browse/widgets/event_card.dart';

class OrganizerProfilePage extends ConsumerWidget {
  final String organizerId;

  const OrganizerProfilePage({super.key, required this.organizerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final organizerAsync = ref.watch(organizerByIdProvider(organizerId));
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = Breakpoints.isMobile(width);

    return organizerAsync.when(
      data: (organizer) {
        if (organizer == null) {
          return _buildNotFound(context);
        }
        return _buildProfile(context, ref, organizer, isMobile);
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/organizers/directory'),
          ),
        ),
        body: Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildNotFound(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/organizers/directory'),
        ),
      ),
      body: Center(
        child: EmptyState(
          icon: Icons.business_outlined,
          title: 'Organizer not found',
          subtitle: 'This organizer may have been removed',
          customAction: FilledButton(
            onPressed: () => context.go('/organizers/directory'),
            child: const Text('Browse Organizers'),
          ),
        ),
      ),
    );
  }

  Widget _buildProfile(
    BuildContext context,
    WidgetRef ref,
    Organizer organizer,
    bool isMobile,
  ) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App bar with banner image
          SliverAppBar(
            expandedHeight: isMobile ? 200 : 280,
            pinned: true,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () =>
                      context.canPop() ? context.pop() : context.go('/organizers/directory'),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: _buildBannerSection(organizer),
            ),
          ),
          // Breadcrumbs
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(
                left: isMobile ? 16 : 32,
                right: isMobile ? 16 : 32,
                top: 16,
              ),
              child: Breadcrumbs(
                items: [
                  BreadcrumbItem(label: 'Home', path: '/'),
                  BreadcrumbItem(label: 'Organizers', path: '/organizers/directory'),
                  BreadcrumbItem(label: organizer.name),
                ],
              ),
            ),
          ),
          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(isMobile ? 16 : 32),
              child: isMobile
                  ? _buildMobileLayout(context, ref, organizer)
                  : _buildDesktopLayout(context, ref, organizer),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerSection(Organizer organizer) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Banner image
        if (organizer.bannerUrl != null)
          Image.network(
            organizer.bannerUrl!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _buildBannerPlaceholder(),
          )
        else
          _buildBannerPlaceholder(),
        // Gradient overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.3),
                Colors.transparent,
                Colors.black.withValues(alpha: 0.7),
              ],
              stops: const [0.0, 0.4, 1.0],
            ),
          ),
        ),
        // Stats badges
        Positioned(
          top: 80,
          right: 16,
          child: Row(
            children: [
              if (organizer.eventsPerYear > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: EventismTheme.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.event, size: 16, color: Colors.white),
                      const SizedBox(width: 6),
                      Text(
                        '${organizer.eventsPerYear} events/year',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              if (organizer.eventsPerYear > 0 && organizer.vendorCount > 0)
                const SizedBox(width: 8),
              if (organizer.vendorCount > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: EventismTheme.cta,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.storefront, size: 16, color: Colors.white),
                      const SizedBox(width: 6),
                      Text(
                        '${organizer.vendorCount} vendors',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBannerPlaceholder() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            EventismTheme.primary,
            EventismTheme.primaryDark,
          ],
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.business,
          size: 80,
          color: Colors.white24,
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, WidgetRef ref, Organizer organizer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildOrganizerHeader(context, organizer),
        const SizedBox(height: 24),
        _buildContactCard(context, organizer),
        const SizedBox(height: 24),
        _buildAboutSection(context, organizer),
        const SizedBox(height: 32),
        _buildEventsSection(context, ref, organizer),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context, WidgetRef ref, Organizer organizer) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main content
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOrganizerHeader(context, organizer),
              const SizedBox(height: 32),
              _buildAboutSection(context, organizer),
              const SizedBox(height: 32),
              _buildEventsSection(context, ref, organizer),
            ],
          ),
        ),
        const SizedBox(width: 32),
        // Sidebar
        SizedBox(
          width: 340,
          child: _buildContactCard(context, organizer),
        ),
      ],
    );
  }

  Widget _buildOrganizerHeader(BuildContext context, Organizer organizer) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: EventismTheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: EventismTheme.border, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: organizer.logoUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                    organizer.logoUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildLogoPlaceholder(organizer.name),
                  ),
                )
              : _buildLogoPlaceholder(organizer.name),
        ),
        const SizedBox(width: 20),
        // Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                organizer.name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              if (organizer.tagline != null) ...[
                const SizedBox(height: 4),
                Text(
                  organizer.tagline!,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: EventismTheme.textSecondary,
                      ),
                ),
              ],
              if (organizer.location != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 16,
                      color: EventismTheme.textMuted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      organizer.location!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
              // Event types
              if (organizer.eventTypes.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: organizer.eventTypes.map((type) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: EventismTheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        type,
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: EventismTheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
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
          fontSize: 32,
        ),
      ),
    );
  }

  Widget _buildContactCard(BuildContext context, Organizer organizer) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Contact',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 16),
            // Contact button
            FilledButton.icon(
              onPressed: () {
                showContactDialog(
                  context,
                  recipientName: organizer.name,
                  recipientType: 'organizer',
                  logoUrl: organizer.logoUrl,
                );
              },
              icon: const Icon(Icons.mail_outline),
              label: const Text('Send Message'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
            // Social links
            if (organizer.hasSocialLinks) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 12),
              Text(
                'Find us online',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: EventismTheme.textMuted,
                    ),
              ),
              const SizedBox(height: 12),
              SocialLinksRow(
                website: organizer.website,
                instagram: organizer.instagram,
                tiktok: organizer.tiktok,
              ),
            ],
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            // Stats
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    icon: Icons.event,
                    value: '${organizer.eventsPerYear}',
                    label: 'Events/Year',
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: EventismTheme.border,
                ),
                Expanded(
                  child: _buildStatItem(
                    context,
                    icon: Icons.storefront,
                    value: '${organizer.vendorCount}',
                    label: 'Vendors',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, color: EventismTheme.primary, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context, Organizer organizer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 16),
        if (organizer.description != null && organizer.description!.isNotEmpty)
          SelectableText(
            organizer.description!,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.7,
                ),
          )
        else
          Text(
            'No description available.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: EventismTheme.textMuted,
                  fontStyle: FontStyle.italic,
                ),
          ),
      ],
    );
  }

  Widget _buildEventsSection(BuildContext context, WidgetRef ref, Organizer organizer) {
    if (organizer.eventIds.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Events',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            'No events yet.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: EventismTheme.textMuted,
                  fontStyle: FontStyle.italic,
                ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Events',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            if (organizer.eventIds.length > 3)
              TextButton(
                onPressed: () {
                  // Could navigate to filtered events view
                },
                child: Text('View all (${organizer.eventIds.length})'),
              ),
          ],
        ),
        const SizedBox(height: 16),
        // Fetch and display events
        ...organizer.eventIds.take(3).map((eventId) {
          final eventAsync = ref.watch(eventByIdProvider(eventId));
          return eventAsync.when(
            data: (event) {
              if (event == null) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: SizedBox(
                  height: 280,
                  child: EventCard(event: event),
                ),
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: SizedBox(
                height: 100,
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
            error: (_, __) => const SizedBox.shrink(),
          );
        }),
      ],
    );
  }

}
