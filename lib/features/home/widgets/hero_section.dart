import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/theme.dart';
import 'search_bar.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = Breakpoints.isMobile(width);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            EventsiaTheme.primary,
            EventsiaTheme.primaryDark,
          ],
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 64,
        vertical: isMobile ? 48 : 80,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Discover Amazing Events',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                  fontSize: isMobile ? 32 : 48,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Find and explore events happening near you',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w400,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: HomeSearchBar(
              onSearch: (query) {
                context.go('/browse?q=$query');
              },
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStat(context, '500+', 'Events'),
              const SizedBox(width: 32),
              _buildStat(context, '50+', 'Categories'),
              const SizedBox(width: 32),
              _buildStat(context, '15+', 'Cities'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
              ),
        ),
      ],
    );
  }
}
