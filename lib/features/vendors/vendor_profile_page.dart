import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../data/models/vendor.dart';
import '../../data/providers/vendors_provider.dart';
import '../../data/providers/events_provider.dart';
import '../../shared/widgets/breadcrumbs.dart';
import '../../shared/widgets/contact_dialog.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/image_gallery.dart';
import '../../shared/widgets/social_links.dart';
import '../browse/widgets/event_card.dart';

class VendorProfilePage extends ConsumerWidget {
  final String vendorId;

  const VendorProfilePage({super.key, required this.vendorId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vendorAsync = ref.watch(vendorByIdProvider(vendorId));
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = Breakpoints.isMobile(width);

    return vendorAsync.when(
      data: (vendor) {
        if (vendor == null) {
          return _buildNotFound(context);
        }
        return _buildProfile(context, ref, vendor, isMobile);
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/vendors/directory'),
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
          onPressed: () => context.go('/vendors/directory'),
        ),
      ),
      body: Center(
        child: EmptyState(
          icon: Icons.storefront_outlined,
          title: 'Vendor not found',
          subtitle: 'This vendor may have been removed',
          customAction: FilledButton(
            onPressed: () => context.go('/vendors/directory'),
            child: const Text('Browse Vendors'),
          ),
        ),
      ),
    );
  }

  Widget _buildProfile(
    BuildContext context,
    WidgetRef ref,
    Vendor vendor,
    bool isMobile,
  ) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App bar with cover image
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
                      context.canPop() ? context.pop() : context.go('/vendors/directory'),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: _buildCoverSection(vendor),
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
                  BreadcrumbItem(label: 'Vendors', path: '/vendors/directory'),
                  BreadcrumbItem(label: vendor.name),
                ],
              ),
            ),
          ),
          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(isMobile ? 16 : 32),
              child: isMobile
                  ? _buildMobileLayout(context, ref, vendor)
                  : _buildDesktopLayout(context, ref, vendor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoverSection(Vendor vendor) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Cover image
        if (vendor.coverUrl != null)
          Image.network(
            vendor.coverUrl!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _buildCoverPlaceholder(),
          )
        else
          _buildCoverPlaceholder(),
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
        // Availability badge
        if (vendor.isAvailable)
          Positioned(
            top: 80,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: EventismTheme.success,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, size: 16, color: Colors.white),
                  SizedBox(width: 6),
                  Text(
                    'Available for Booking',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCoverPlaceholder() {
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
          Icons.storefront,
          size: 80,
          color: Colors.white24,
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, WidgetRef ref, Vendor vendor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildVendorHeader(context, vendor),
        const SizedBox(height: 24),
        _buildContactCard(context, vendor),
        const SizedBox(height: 24),
        _buildAboutSection(context, vendor),
        if (vendor.galleryUrls.isNotEmpty) ...[
          const SizedBox(height: 32),
          _buildGallerySection(context, vendor),
        ],
        const SizedBox(height: 32),
        _buildPastEventsSection(context, ref, vendor),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context, WidgetRef ref, Vendor vendor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main content
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildVendorHeader(context, vendor),
              const SizedBox(height: 32),
              _buildAboutSection(context, vendor),
              if (vendor.galleryUrls.isNotEmpty) ...[
                const SizedBox(height: 32),
                _buildGallerySection(context, vendor),
              ],
              const SizedBox(height: 32),
              _buildPastEventsSection(context, ref, vendor),
            ],
          ),
        ),
        const SizedBox(width: 32),
        // Sidebar
        SizedBox(
          width: 340,
          child: _buildContactCard(context, vendor),
        ),
      ],
    );
  }

  Widget _buildVendorHeader(BuildContext context, Vendor vendor) {
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
          child: vendor.logoUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                    vendor.logoUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildLogoPlaceholder(vendor.name),
                  ),
                )
              : _buildLogoPlaceholder(vendor.name),
        ),
        const SizedBox(width: 20),
        // Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                vendor.name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              if (vendor.tagline != null) ...[
                const SizedBox(height: 4),
                Text(
                  vendor.tagline!,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: EventismTheme.textSecondary,
                      ),
                ),
              ],
              if (vendor.location != null) ...[
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
                      vendor.location!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
              // Categories
              if (vendor.categories.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: vendor.categories.map((cat) {
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
                        cat,
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
        name.isNotEmpty ? name[0].toUpperCase() : 'V',
        style: const TextStyle(
          color: EventismTheme.primary,
          fontWeight: FontWeight.w700,
          fontSize: 32,
        ),
      ),
    );
  }

  Widget _buildContactCard(BuildContext context, Vendor vendor) {
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
                  recipientName: vendor.name,
                  recipientType: 'vendor',
                  logoUrl: vendor.logoUrl,
                );
              },
              icon: const Icon(Icons.mail_outline),
              label: const Text('Send Message'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
            // Social links
            if (vendor.hasSocialLinks) ...[
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
                website: vendor.website,
                instagram: vendor.instagram,
                tiktok: vendor.tiktok,
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
                    value: '${vendor.pastEventIds.length}',
                    label: 'Events',
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
                    icon: Icons.photo_library,
                    value: '${vendor.galleryUrls.length}',
                    label: 'Photos',
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

  Widget _buildAboutSection(BuildContext context, Vendor vendor) {
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
        if (vendor.description != null && vendor.description!.isNotEmpty)
          SelectableText(
            vendor.description!,
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

  Widget _buildGallerySection(BuildContext context, Vendor vendor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gallery',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 16),
        ImageGallery(
          imageUrls: vendor.galleryUrls,
          height: 200,
        ),
      ],
    );
  }

  Widget _buildPastEventsSection(BuildContext context, WidgetRef ref, Vendor vendor) {
    if (vendor.pastEventIds.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Past Events',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 16),
        // Fetch and display past events
        ...vendor.pastEventIds.take(3).map((eventId) {
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
