import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/theme.dart';
import 'search_bar.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  // Accent colors for mesh gradient effect
  static const _tealAccent = Color(0xFF22D3D1);
  static const _blueAccent = Color(0xFF0EA5E9);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = Breakpoints.isMobile(width);

    return ClipRect(
      child: Stack(
        children: [
          // Base gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  EventismTheme.primary,
                  EventismTheme.primaryDark,
                  Color(0xFF065F46), // Darker green
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),
          // Mesh gradient overlay - top right blob
          Positioned(
            top: -80,
            right: -60,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    _tealAccent.withValues(alpha: 0.4),
                    _tealAccent.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          // Mesh gradient overlay - bottom left blob
          Positioned(
            bottom: -100,
            left: -80,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    _blueAccent.withValues(alpha: 0.3),
                    _blueAccent.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          // Mesh gradient overlay - center-right small blob
          Positioned(
            top: 120,
            right: isMobile ? 20 : 200,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    EventismTheme.primaryLight.withValues(alpha: 0.5),
                    EventismTheme.primaryLight.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          // Floating decorative shapes
          if (!isMobile) ...[
            // Large ring - top left
            Positioned(
              top: 40,
              left: 60,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.15),
                    width: 2,
                  ),
                ),
              ),
            ),
            // Small filled circle - bottom right
            Positioned(
              bottom: 60,
              right: 120,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),
            // Medium ring - right side
            Positioned(
              top: 180,
              right: 80,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                    width: 1.5,
                  ),
                ),
              ),
            ),
            // Dot cluster - left side
            Positioned(
              bottom: 120,
              left: 150,
              child: Row(
                children: List.generate(
                  3,
                  (i) => Container(
                    margin: const EdgeInsets.only(right: 8),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.15 - (i * 0.04)),
                    ),
                  ),
                ),
              ),
            ),
          ],
          // Content
          Padding(
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
                const SizedBox(height: 32),
                // Stats with glass effect
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStat(context, '500+', 'Events'),
                      _buildDivider(),
                      _buildStat(context, '50+', 'Categories'),
                      _buildDivider(),
                      _buildStat(context, '15+', 'Cities'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      width: 1,
      height: 40,
      color: Colors.white.withValues(alpha: 0.2),
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
