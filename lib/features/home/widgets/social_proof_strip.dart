import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants.dart';
import '../../../core/theme.dart';
import '../../../data/models/testimonial.dart';
import '../../../data/providers/testimonials_provider.dart';

class SocialProofStrip extends ConsumerWidget {
  const SocialProofStrip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = Breakpoints.isMobile(width);
    final testimonialsAsync = ref.watch(testimonialsProvider);

    return Container(
      color: EventismTheme.surface,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 64,
        vertical: isMobile ? 32 : 48,
      ),
      child: Column(
        children: [
          // Stats row
          _buildStatsRow(context, isMobile),
          const SizedBox(height: 32),
          // Testimonials
          testimonialsAsync.when(
            data: (testimonials) => _buildTestimonials(context, testimonials, isMobile),
            loading: () => const SizedBox(
              height: 120,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context, bool isMobile) {
    final stats = [
      _StatItem(
        value: '10K+',
        label: 'Events Listed',
        icon: Icons.event,
      ),
      _StatItem(
        value: '500+',
        label: 'Active Vendors',
        icon: Icons.storefront,
      ),
      _StatItem(
        value: '200+',
        label: 'Organizers',
        icon: Icons.business,
      ),
      _StatItem(
        value: '50K+',
        label: 'Monthly Visitors',
        icon: Icons.people,
      ),
    ];

    if (isMobile) {
      return Wrap(
        spacing: 24,
        runSpacing: 24,
        alignment: WrapAlignment.center,
        children: stats.map((stat) => _buildStatCard(context, stat, isMobile)).toList(),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: stats.map((stat) => _buildStatCard(context, stat, isMobile)).toList(),
    );
  }

  Widget _buildStatCard(BuildContext context, _StatItem stat, bool isMobile) {
    return SizedBox(
      width: isMobile ? 140 : null,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: EventismTheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              stat.icon,
              color: EventismTheme.primary,
              size: 24,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            stat.value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: EventismTheme.textPrimary,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            stat.label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: EventismTheme.textSecondary,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonials(BuildContext context, List<Testimonial> testimonials, bool isMobile) {
    if (testimonials.isEmpty) return const SizedBox.shrink();

    // Take first 3 testimonials
    final displayTestimonials = testimonials.take(3).toList();

    if (isMobile) {
      return Column(
        children: displayTestimonials
            .map((t) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildTestimonialCard(context, t),
                ))
            .toList(),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: displayTestimonials
          .map((t) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: _buildTestimonialCard(context, t),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildTestimonialCard(BuildContext context, Testimonial testimonial) {
    final typeIcon = switch (testimonial.type) {
      'vendor' => Icons.storefront,
      'organizer' => Icons.business,
      _ => Icons.person,
    };
    final typeLabel = switch (testimonial.type) {
      'vendor' => 'Vendor',
      'organizer' => 'Organizer',
      _ => 'Attendee',
    };

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: EventismTheme.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: EventismTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quote icon
          Icon(
            Icons.format_quote,
            color: EventismTheme.primary.withValues(alpha: 0.3),
            size: 32,
          ),
          const SizedBox(height: 12),
          // Quote text
          Text(
            testimonial.quote,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                  height: 1.6,
                ),
          ),
          const SizedBox(height: 16),
          // Author info
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: EventismTheme.primary.withValues(alpha: 0.1),
                child: Text(
                  testimonial.authorName.substring(0, 1).toUpperCase(),
                  style: TextStyle(
                    color: EventismTheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      testimonial.authorName,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Row(
                      children: [
                        Icon(typeIcon, size: 14, color: EventismTheme.textMuted),
                        const SizedBox(width: 4),
                        Text(
                          typeLabel,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            testimonial.authorRole,
                            style: Theme.of(context).textTheme.bodySmall,
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
        ],
      ),
    );
  }
}

class _StatItem {
  final String value;
  final String label;
  final IconData icon;

  _StatItem({
    required this.value,
    required this.label,
    required this.icon,
  });
}
