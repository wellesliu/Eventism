import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../../core/theme.dart';

class ShellScaffold extends StatelessWidget {
  final Widget child;

  const ShellScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = Breakpoints.isMobile(width);

    return Scaffold(
      appBar: isMobile ? _buildMobileAppBar(context) : null,
      drawer: isMobile ? _buildDrawer(context) : null,
      body: isMobile
          ? child
          : Column(
              children: [
                _buildDesktopNav(context),
                Expanded(child: child),
              ],
            ),
    );
  }

  PreferredSizeWidget _buildMobileAppBar(BuildContext context) {
    return AppBar(
      title: const Text(AppConstants.appName),
      centerTitle: true,
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: EventsiaTheme.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  AppConstants.appName,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppConstants.appTagline,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                ),
              ],
            ),
          ),
          _buildNavItem(context, 'Home', Icons.home_outlined, '/'),
          _buildNavItem(context, 'Browse', Icons.search, '/browse'),
          _buildNavItem(context, 'Map', Icons.map_outlined, '/map'),
          _buildNavItem(context, 'Calendar', Icons.calendar_today_outlined, '/calendar'),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String label, IconData icon, String path) {
    final currentPath = GoRouterState.of(context).uri.toString();
    final isSelected = currentPath == path || (path != '/' && currentPath.startsWith(path));

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? EventsiaTheme.primary : EventsiaTheme.textSecondary,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? EventsiaTheme.primary : EventsiaTheme.textPrimary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
      selected: isSelected,
      onTap: () {
        Navigator.pop(context);
        context.go(path);
      },
    );
  }

  Widget _buildDesktopNav(BuildContext context) {
    return Container(
      color: EventsiaTheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Row(
        children: [
          // Logo
          InkWell(
            onTap: () => context.go('/'),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: EventsiaTheme.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.event,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  AppConstants.appName,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
          ),
          const Spacer(),
          // Nav links
          _buildDesktopNavLink(context, 'Home', '/'),
          _buildDesktopNavLink(context, 'Browse', '/browse'),
          _buildDesktopNavLink(context, 'Map', '/map'),
          _buildDesktopNavLink(context, 'Calendar', '/calendar'),
          const SizedBox(width: 24),
          // CTA button
          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add, size: 20),
            label: const Text('Create Event'),
            style: FilledButton.styleFrom(
              backgroundColor: EventsiaTheme.cta,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopNavLink(BuildContext context, String label, String path) {
    final currentPath = GoRouterState.of(context).uri.toString();
    final isSelected = currentPath == path || (path != '/' && currentPath.startsWith(path));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextButton(
        onPressed: () => context.go(path),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? EventsiaTheme.primary : EventsiaTheme.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
