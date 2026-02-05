import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../core/theme.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = Breakpoints.isMobile(width);

    return SingleChildScrollView(
      child: Column(
        children: [
          // Hero section
          _buildHeroSection(context, isMobile),
          // Mission section
          _buildMissionSection(context, isMobile),
          // Features section
          _buildFeaturesSection(context, isMobile),
          // Stats section
          _buildStatsSection(context, isMobile),
          // Team section
          _buildTeamSection(context, isMobile),
          // CTA section
          _buildCtaSection(context, isMobile),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 64,
        vertical: isMobile ? 48 : 80,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            EventismTheme.primary,
            EventismTheme.primaryDark,
            const Color(0xFF065F46),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: Column(
        children: [
          Text(
            'About Eventism',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                  fontSize: isMobile ? 32 : 48,
                  fontWeight: FontWeight.w700,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Text(
              'Connecting communities, one experience at a time',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w400,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionSection(BuildContext context, bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 64,
        vertical: isMobile ? 48 : 80,
      ),
      color: EventismTheme.surface,
      child: Column(
        children: [
          Text(
            'Our Mission',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Text(
              'We believe that great events bring people together and create lasting memories. '
              'Eventism is built to make event discovery seamless, helping attendees find amazing '
              'experiences, empowering organisers to reach their audience, and connecting vendors '
              'with opportunities to grow their business.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.8,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection(BuildContext context, bool isMobile) {
    final features = [
      _FeatureItem(
        icon: Icons.people_outline,
        title: 'Three-Way Connection',
        description:
            'We connect organisers, vendors, and attendees in one seamless platform, '
            'creating a thriving ecosystem for events of all sizes.',
      ),
      _FeatureItem(
        icon: Icons.map_outlined,
        title: 'Interactive Maps',
        description:
            'Discover events near you with our interactive map feature. '
            'Find venues, get directions, and explore what\'s happening in your area.',
      ),
      _FeatureItem(
        icon: Icons.attach_money,
        title: 'Lowest Fees',
        description:
            'We offer the world\'s lowest ticketing fees at just 2% + \$0.50 per ticket, '
            'so more of your money goes to creating great experiences.',
      ),
      _FeatureItem(
        icon: Icons.calendar_month_outlined,
        title: 'Easy Discovery',
        description:
            'Browse by category, date, or location. Our smart filters help you find '
            'exactly what you\'re looking for, from music festivals to craft markets.',
      ),
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 64,
        vertical: isMobile ? 48 : 80,
      ),
      color: EventismTheme.background,
      child: Column(
        children: [
          Text(
            'Why Eventism?',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Wrap(
              spacing: 24,
              runSpacing: 24,
              alignment: WrapAlignment.center,
              children: features
                  .map((f) => _buildFeatureCard(context, f, isMobile))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
      BuildContext context, _FeatureItem feature, bool isMobile) {
    return Container(
      width: isMobile ? double.infinity : 280,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: EventismTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: EventismTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: EventismTheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              feature.icon,
              size: 28,
              color: EventismTheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            feature.title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            feature.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context, bool isMobile) {
    final stats = [
      ('500+', 'Events Listed'),
      ('50+', 'Categories'),
      ('15+', 'Cities'),
      ('2%', 'Low Fees'),
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 64,
        vertical: isMobile ? 48 : 80,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            EventismTheme.primary,
            EventismTheme.primaryDark,
          ],
        ),
      ),
      child: Wrap(
        spacing: isMobile ? 32 : 64,
        runSpacing: 32,
        alignment: WrapAlignment.center,
        children: stats.map((stat) {
          return SizedBox(
            width: isMobile ? 140 : 180,
            child: Column(
              children: [
                Text(
                  stat.$1,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  stat.$2,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTeamSection(BuildContext context, bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 64,
        vertical: isMobile ? 48 : 80,
      ),
      color: EventismTheme.surface,
      child: Column(
        children: [
          Text(
            'Built for the Community',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Text(
              'Eventism was created by event enthusiasts who saw the need for a better way '
              'to discover local experiences. We\'re passionate about bringing communities '
              'together and supporting local organisers and vendors.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.8,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildValueChip(context, 'Community First'),
              const SizedBox(width: 12),
              _buildValueChip(context, 'Transparent Pricing'),
              const SizedBox(width: 12),
              _buildValueChip(context, 'Local Focus'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildValueChip(BuildContext context, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: EventismTheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: EventismTheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: EventismTheme.primary,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }

  Widget _buildCtaSection(BuildContext context, bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 64,
        vertical: isMobile ? 48 : 80,
      ),
      color: EventismTheme.background,
      child: Column(
        children: [
          Text(
            'Ready to Discover?',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Start exploring amazing events happening near you.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.search),
                label: const Text('Browse Events'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.map_outlined),
                label: const Text('View Map'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeatureItem {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });
}
