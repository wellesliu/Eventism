import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../../core/theme.dart';

class VendorsLandingPage extends StatelessWidget {
  const VendorsLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = Breakpoints.isMobile(width);

    return SingleChildScrollView(
      child: Column(
        children: [
          // Hero section
          _buildHeroSection(context, isMobile),
          // Value props
          _buildValueProps(context, isMobile),
          // How it works
          _buildHowItWorks(context, isMobile),
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
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF064E3B),
            EventismTheme.primaryDark,
            EventismTheme.primary,
          ],
          stops: [0.0, 0.4, 1.0],
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.storefront,
            size: isMobile ? 48 : 64,
            color: Colors.white.withValues(alpha: 0.9),
          ),
          const SizedBox(height: 24),
          Text(
            'Find Your Next Market',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: isMobile ? 32 : 48,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Text(
              'Connect with event organizers across Australia and grow your business at amazing events.',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 16,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              FilledButton.icon(
                onPressed: () => context.go('/browse?vendors=true'),
                icon: const Icon(Icons.search),
                label: const Text('Browse Opportunities'),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: EventismTheme.primaryDark,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                ),
              ),
              OutlinedButton.icon(
                onPressed: () => context.go('/vendors/directory'),
                icon: const Icon(Icons.people),
                label: const Text('Find Vendors'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white, width: 2),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildValueProps(BuildContext context, bool isMobile) {
    final props = [
      _ValueProp(
        icon: Icons.attach_money,
        title: 'Low Application Fees',
        description: 'Apply to events with competitive stall fees and transparent pricing.',
      ),
      _ValueProp(
        icon: Icons.chat_bubble_outline,
        title: 'Direct Contact',
        description: 'Connect directly with event organizers without intermediaries.',
      ),
      _ValueProp(
        icon: Icons.calendar_month,
        title: 'Manage Your Calendar',
        description: 'Track applications, upcoming events, and deadlines in one place.',
      ),
      _ValueProp(
        icon: Icons.star_outline,
        title: 'Build Your Reputation',
        description: 'Grow your vendor profile and get discovered by more organizers.',
      ),
    ];

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 64,
        vertical: isMobile ? 48 : 80,
      ),
      color: EventismTheme.surface,
      child: Column(
        children: [
          Text(
            'Why Vendors Love Eventism',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: props.map((prop) => _buildPropCard(context, prop, isMobile)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPropCard(BuildContext context, _ValueProp prop, bool isMobile) {
    return Container(
      width: isMobile ? double.infinity : 260,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: EventismTheme.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: EventismTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: EventismTheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              prop.icon,
              color: EventismTheme.primary,
              size: 24,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            prop.title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            prop.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildHowItWorks(BuildContext context, bool isMobile) {
    final steps = [
      _Step('1', 'Browse Events', 'Find events accepting vendors that match your products.'),
      _Step('2', 'Apply Online', 'Submit your application with photos and product details.'),
      _Step('3', 'Get Accepted', 'Organizers review and approve your application.'),
      _Step('4', 'Sell & Grow', 'Set up your stall and connect with customers.'),
    ];

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 64,
        vertical: isMobile ? 48 : 80,
      ),
      color: EventismTheme.background,
      child: Column(
        children: [
          Text(
            'How It Works',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          isMobile
              ? Column(
                  children: steps.map((step) => _buildStepCard(context, step)).toList(),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: steps.map((step) => Expanded(child: _buildStepCard(context, step))).toList(),
                ),
        ],
      ),
    );
  }

  Widget _buildStepCard(BuildContext context, _Step step) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: EventismTheme.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                step.number,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            step.title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            step.description,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCtaSection(BuildContext context, bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 64,
        vertical: isMobile ? 48 : 80,
      ),
      color: EventismTheme.surface,
      child: Column(
        children: [
          Text(
            'Ready to Get Started?',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Browse events accepting vendors and apply today.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: () => context.go('/browse?vendors=true'),
            icon: const Icon(Icons.search),
            label: const Text('Browse Vendor Opportunities'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class _ValueProp {
  final IconData icon;
  final String title;
  final String description;

  const _ValueProp({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class _Step {
  final String number;
  final String title;
  final String description;

  const _Step(this.number, this.title, this.description);
}
