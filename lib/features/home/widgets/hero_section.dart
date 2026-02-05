import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants.dart';
import '../../../core/theme.dart';
import 'search_bar.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  DateTime? _startDate;
  DateTime? _endDate;
  bool _acceptingVendors = false;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToSearch() {
    final params = <String, String>{};
    if (_searchController.text.isNotEmpty) {
      params['q'] = _searchController.text;
    }
    if (_startDate != null) {
      params['start'] = _startDate!.toIso8601String().split('T')[0];
    }
    if (_endDate != null) {
      params['end'] = _endDate!.toIso8601String().split('T')[0];
    }
    if (_acceptingVendors) {
      params['vendors'] = 'true';
    }

    final queryString = params.entries.map((e) => '${e.key}=${e.value}').join('&');
    context.go('/browse${queryString.isNotEmpty ? '?$queryString' : ''}');
  }

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
            Color(0xFF064E3B), // Dark green
            EventismTheme.primaryDark,
            EventismTheme.primary,
          ],
          stops: [0.0, 0.4, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Subtle pattern overlay
          Positioned.fill(
            child: CustomPaint(
              painter: _DotPatternPainter(),
            ),
          ),
          // Content
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 24 : 64,
              vertical: isMobile ? 40 : 64,
            ),
            child: isMobile
                ? _buildMobileLayout(context)
                : _buildDesktopLayout(context),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Discover\nAmazing Events',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
        ),
        const SizedBox(height: 16),
        Text(
          'Find experiences happening near you',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white.withValues(alpha: 0.85),
              ),
        ),
        const SizedBox(height: 24),
        HomeSearchBar(
          onSearch: (query) {
            if (context.mounted) {
              context.go('/browse?q=$query');
            }
          },
        ),
        const SizedBox(height: 24),
        _buildStats(context),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left side - Text content
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Discover Amazing\nEvents Near You',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      height: 1.15,
                    ),
              ),
              const SizedBox(height: 20),
              Text(
                'Find and explore experiences happening in your community.\nFrom markets to festivals, concerts to conferences.',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontWeight: FontWeight.w400,
                      height: 1.6,
                    ),
              ),
              const SizedBox(height: 32),
              _buildStats(context),
            ],
          ),
        ),
        const SizedBox(width: 48),
        // Right side - Search card
        Expanded(
          flex: 4,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Find Events',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: EventismTheme.textPrimary,
                      ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search events...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: EventismTheme.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: (_) => _navigateToSearch(),
                ),
                const SizedBox(height: 12),
                // Date filters
                Row(
                  children: [
                    Expanded(
                      child: _buildDateButton(
                        context,
                        label: 'Start Date',
                        date: _startDate,
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _startDate ?? DateTime.now(),
                            firstDate: DateTime.now().subtract(const Duration(days: 30)),
                            lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                          );
                          if (date != null) {
                            setState(() => _startDate = date);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildDateButton(
                        context,
                        label: 'End Date',
                        date: _endDate,
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _endDate ?? (_startDate ?? DateTime.now()).add(const Duration(days: 30)),
                            firstDate: _startDate ?? DateTime.now().subtract(const Duration(days: 30)),
                            lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                          );
                          if (date != null) {
                            setState(() => _endDate = date);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Accepting vendors checkbox
                InkWell(
                  onTap: () => setState(() => _acceptingVendors = !_acceptingVendors),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: _acceptingVendors
                          ? EventismTheme.success.withValues(alpha: 0.1)
                          : EventismTheme.background,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: _acceptingVendors
                            ? EventismTheme.success
                            : Colors.transparent,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _acceptingVendors ? Icons.check_box : Icons.check_box_outline_blank,
                          size: 20,
                          color: _acceptingVendors ? EventismTheme.success : EventismTheme.textMuted,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Accepting Vendors',
                          style: TextStyle(
                            color: _acceptingVendors ? EventismTheme.success : EventismTheme.textSecondary,
                            fontWeight: _acceptingVendors ? FontWeight.w500 : FontWeight.w400,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.storefront,
                          size: 18,
                          color: _acceptingVendors ? EventismTheme.success : EventismTheme.textMuted,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _navigateToSearch,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Search Events'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateButton(
    BuildContext context, {
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    final dateFormat = DateFormat('MMM d');
    final hasDate = date != null;

    return Material(
      color: hasDate ? EventismTheme.primary.withValues(alpha: 0.1) : EventismTheme.background,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.calendar_today,
                size: 16,
                color: hasDate ? EventismTheme.primary : EventismTheme.textMuted,
              ),
              const SizedBox(width: 6),
              Text(
                hasDate ? dateFormat.format(date) : label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: hasDate ? EventismTheme.primary : EventismTheme.textSecondary,
                      fontWeight: hasDate ? FontWeight.w500 : FontWeight.w400,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickFilter(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: EventismTheme.background,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: EventismTheme.primary),
              const SizedBox(width: 6),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: EventismTheme.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStats(BuildContext context) {
    return Row(
      children: [
        _buildStatItem(context, '500+', 'Events'),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          width: 1,
          height: 32,
          color: Colors.white.withValues(alpha: 0.3),
        ),
        _buildStatItem(context, '50+', 'Categories'),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          width: 1,
          height: 32,
          color: Colors.white.withValues(alpha: 0.3),
        ),
        _buildStatItem(context, '15+', 'Cities'),
      ],
    );
  }

  Widget _buildStatItem(BuildContext context, String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.75),
              ),
        ),
      ],
    );
  }
}

class _DotPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..style = PaintingStyle.fill;

    const spacing = 40.0;
    const radius = 2.0;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
