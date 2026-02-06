import 'package:flutter/material.dart';

import '../../core/constants.dart';
import 'widgets/hero_section.dart';
import 'widgets/category_chips.dart';
import 'widgets/entry_points.dart';
import 'widgets/featured_events.dart';
import 'widgets/how_it_works.dart';
import 'widgets/social_proof_strip.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = Breakpoints.isMobile(width);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const HeroSection(),
        // Entry points for different user types
        const EntryPoints(),
        // Social proof strip with stats and testimonials
        const SocialProofStrip(),
        // Category chips
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 32,
            vertical: 24,
          ),
          child: const CategoryChips(),
        ),
        // Featured events
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 32,
          ),
          child: const FeaturedEvents(),
        ),
        // How it works section
        const HowItWorks(),
        const SizedBox(height: 48),
      ],
    );
  }
}
