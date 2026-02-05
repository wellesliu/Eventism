import 'package:flutter/material.dart';

import '../../core/constants.dart';
import 'widgets/hero_section.dart';
import 'widgets/category_chips.dart';
import 'widgets/featured_events.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = Breakpoints.isMobile(width);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const HeroSection(),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 16 : 32,
              vertical: 24,
            ),
            child: const CategoryChips(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 16 : 32,
            ),
            child: const FeaturedEvents(),
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }
}
