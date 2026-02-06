import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/theme.dart';

class HowItWorks extends StatefulWidget {
  const HowItWorks({super.key});

  @override
  State<HowItWorks> createState() => _HowItWorksState();
}

class _HowItWorksState extends State<HowItWorks> {
  int _selectedTab = 0;

  static const _tabs = ['Attendees', 'Vendors', 'Organizers'];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = Breakpoints.isMobile(width);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 64,
        vertical: isMobile ? 40 : 64,
      ),
      child: Column(
        children: [
          // Section header
          Text(
            'How It Works',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Simple steps to get started',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          // Tab selector
          _buildTabSelector(context, isMobile),
          const SizedBox(height: 40),
          // Steps for selected tab
          _buildSteps(context, isMobile),
        ],
      ),
    );
  }

  Widget _buildTabSelector(BuildContext context, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: EventismTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: EventismTheme.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(_tabs.length, (index) {
          final isSelected = _selectedTab == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedTab = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 24,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: isSelected ? EventismTheme.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getTabIcon(index),
                    size: 18,
                    color: isSelected ? Colors.white : EventismTheme.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _tabs[index],
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: isSelected ? Colors.white : EventismTheme.textSecondary,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  IconData _getTabIcon(int index) {
    return switch (index) {
      0 => Icons.person,
      1 => Icons.storefront,
      2 => Icons.business,
      _ => Icons.help,
    };
  }

  Widget _buildSteps(BuildContext context, bool isMobile) {
    final steps = _getStepsForTab(_selectedTab);

    if (isMobile) {
      return Column(
        children: List.generate(steps.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: _buildStepCard(context, steps[index], index + 1, isMobile),
          );
        }),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(steps.length, (index) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildStepCard(context, steps[index], index + 1, isMobile),
          ),
        );
      }),
    );
  }

  List<_Step> _getStepsForTab(int tab) {
    return switch (tab) {
      0 => [
          _Step(
            icon: Icons.search,
            title: 'Browse Events',
            description: 'Search by location, date, category, or keyword to find events that match your interests.',
            action: 'Browse Events',
            route: '/browse',
          ),
          _Step(
            icon: Icons.favorite_border,
            title: 'Save Favorites',
            description: 'Heart events you love to build your personal calendar and never miss out.',
            action: null,
            route: null,
          ),
          _Step(
            icon: Icons.calendar_today,
            title: 'Plan & Attend',
            description: 'View event details, get directions, and enjoy amazing experiences.',
            action: 'View Calendar',
            route: '/calendar',
          ),
        ],
      1 => [
          _Step(
            icon: Icons.app_registration,
            title: 'Create Profile',
            description: 'Showcase your products, services, and past event photos to attract organizers.',
            action: 'Get Started',
            route: '/vendors',
          ),
          _Step(
            icon: Icons.event_available,
            title: 'Find Opportunities',
            description: 'Browse events accepting vendors and filter by location, size, and category.',
            action: 'Find Events',
            route: '/browse?vendors=true',
          ),
          _Step(
            icon: Icons.handshake,
            title: 'Connect & Book',
            description: 'Contact organizers directly through their profiles to secure your spot.',
            action: null,
            route: null,
          ),
        ],
      2 => [
          _Step(
            icon: Icons.add_business,
            title: 'List Your Events',
            description: 'Create detailed event listings with dates, venues, and vendor requirements.',
            action: 'Get Started',
            route: '/organizers',
          ),
          _Step(
            icon: Icons.storefront,
            title: 'Find Vendors',
            description: 'Browse our vendor directory to find the perfect fit for your events.',
            action: 'Find Vendors',
            route: '/vendors/directory',
          ),
          _Step(
            icon: Icons.trending_up,
            title: 'Grow Your Reach',
            description: 'Get discovered by thousands of attendees and vendors searching for events.',
            action: null,
            route: null,
          ),
        ],
      _ => [],
    };
  }

  Widget _buildStepCard(BuildContext context, _Step step, int number, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: EventismTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: EventismTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step number and icon
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: EventismTheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '$number',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: EventismTheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  step.icon,
                  color: EventismTheme.primary,
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Title
          Text(
            step.title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          // Description
          Text(
            step.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.6,
                ),
          ),
          if (step.action != null && step.route != null) ...[
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => context.go(step.route!),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(step.action!),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward, size: 16),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Step {
  final IconData icon;
  final String title;
  final String description;
  final String? action;
  final String? route;

  _Step({
    required this.icon,
    required this.title,
    required this.description,
    this.action,
    this.route,
  });
}
