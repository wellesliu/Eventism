import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../../core/theme.dart';
import 'footer.dart';
import 'toast_service.dart';

class ShellScaffold extends StatelessWidget {
  final Widget child;

  const ShellScaffold({super.key, required this.child});

  /// Routes that manage their own scrolling (CustomScrollView, Expanded, etc).
  /// These should NOT be wrapped in SingleChildScrollView.
  static const _fullHeightRoutes = [
    '/browse',
    '/map',
    '/calendar',
    '/vendors/directory',
    '/organizers',
    '/event/',      // Event detail pages (have own Scaffold + CustomScrollView)
    '/vendor/',     // Vendor profile pages (have own Scaffold + CustomScrollView)
    '/organizer/',  // Organizer profile pages (have own Scaffold + CustomScrollView)
  ];

  bool _isFullHeightRoute(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;
    return _fullHeightRoutes.any((route) => path.startsWith(route));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = Breakpoints.isMobile(width);
    final isFullHeight = _isFullHeightRoute(context);

    return Scaffold(
      appBar: isMobile ? _buildMobileAppBar(context) : null,
      drawer: isMobile ? _buildDrawer(context) : null,
      body: isMobile
          ? isFullHeight
              ? child
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      child,
                      const Footer(),
                    ],
                  ),
                )
          : Column(
              children: [
                _buildDesktopNav(context),
                Expanded(
                  child: isFullHeight
                      ? child
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              child,
                              const Footer(),
                            ],
                          ),
                        ),
                ),
              ],
            ),
    );
  }

  PreferredSizeWidget _buildMobileAppBar(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLogoIcon(size: 28),
          const SizedBox(width: 8),
          const Text(AppConstants.appName),
        ],
      ),
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
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  EventismTheme.primary,
                  EventismTheme.primaryDark,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    _buildLogoIcon(size: 48, padding: 10),
                    const SizedBox(width: 12),
                    Text(
                      AppConstants.appName,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
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
          _buildExpandableNavItem(
            context,
            title: 'Events',
            icon: Icons.event_outlined,
            children: [
              _DrawerSubItem('Browse All', '/browse'),
              _DrawerSubItem('Map View', '/map'),
              _DrawerSubItem('Calendar', '/calendar'),
            ],
          ),
          _buildExpandableNavItem(
            context,
            title: 'Vendors',
            icon: Icons.storefront_outlined,
            children: [
              _DrawerSubItem('For Vendors', '/vendors'),
              _DrawerSubItem('Find Vendors', '/vendors/directory'),
              _DrawerSubItem('Vendor Opportunities', '/browse?vendors=true'),
            ],
          ),
          _buildNavItem(context, 'Organizers', Icons.business_outlined, '/organizers'),
          _buildNavItem(context, 'About', Icons.info_outline, '/about'),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      context.go('/list-event');
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('List Your Event'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      context.go('/join-vendor');
                    },
                    icon: const Icon(Icons.storefront),
                    label: const Text('Join as Vendor'),
                  ),
                ),
              ],
            ),
          ),
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
        color: isSelected ? EventismTheme.primary : EventismTheme.textSecondary,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? EventismTheme.primary : EventismTheme.textPrimary,
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

  Widget _buildExpandableNavItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<_DrawerSubItem> children,
  }) {
    final currentPath = GoRouterState.of(context).uri.toString();
    final isExpanded = children.any((c) {
      // If path has query params, require exact match
      if (c.path.contains('?')) {
        return currentPath == c.path;
      }
      // Otherwise, use startsWith for nested routes
      return currentPath == c.path || currentPath.startsWith('${c.path}/');
    });

    return ExpansionTile(
      leading: Icon(
        icon,
        color: isExpanded ? EventismTheme.primary : EventismTheme.textSecondary,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isExpanded ? EventismTheme.primary : EventismTheme.textPrimary,
          fontWeight: isExpanded ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
      initiallyExpanded: isExpanded,
      children: children.map((item) {
        final isItemSelected = currentPath == item.path ||
          currentPath.startsWith(item.path.split('?').first);
        return ListTile(
          contentPadding: const EdgeInsets.only(left: 56),
          title: Text(
            item.label,
            style: TextStyle(
              color: isItemSelected ? EventismTheme.primary : EventismTheme.textSecondary,
              fontWeight: isItemSelected ? FontWeight.w500 : FontWeight.w400,
              fontSize: 14,
            ),
          ),
          onTap: () {
            Navigator.pop(context);
            context.go(item.path);
          },
        );
      }).toList(),
    );
  }

  Widget _buildDesktopNav(BuildContext context) {
    return Container(
      color: EventismTheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Row(
        children: [
          // Logo
          InkWell(
            onTap: () => context.go('/'),
            child: Row(
              children: [
                _buildLogoIcon(size: 40, padding: 8),
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
          const SizedBox(width: 48),
          // Nav links
          _buildDesktopNavLink(context, 'Home', '/'),
          _buildDesktopDropdown(
            context,
            label: 'Events',
            items: [
              _DropdownItem('Browse All', '/browse', Icons.grid_view),
              _DropdownItem('Map View', '/map', Icons.map_outlined),
              _DropdownItem('Calendar', '/calendar', Icons.calendar_today_outlined),
            ],
          ),
          _buildDesktopDropdown(
            context,
            label: 'Vendors',
            items: [
              _DropdownItem('For Vendors', '/vendors', Icons.info_outline),
              _DropdownItem('Find Vendors', '/vendors/directory', Icons.search),
              _DropdownItem('Vendor Opportunities', '/browse?vendors=true', Icons.storefront),
            ],
          ),
          _buildDesktopNavLink(context, 'Organizers', '/organizers'),
          _buildDesktopNavLink(context, 'About', '/about'),
          const Spacer(),
          // CTA buttons
          OutlinedButton.icon(
            onPressed: () => context.go('/list-event'),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('List Your Event'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          const SizedBox(width: 12),
          FilledButton.icon(
            onPressed: () => context.go('/join-vendor'),
            icon: const Icon(Icons.storefront, size: 18),
            label: const Text('Join as Vendor'),
            style: FilledButton.styleFrom(
              backgroundColor: EventismTheme.cta,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextButton(
        onPressed: () => context.go(path),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? EventismTheme.primary : EventismTheme.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopDropdown(
    BuildContext context, {
    required String label,
    required List<_DropdownItem> items,
  }) {
    final currentPath = GoRouterState.of(context).uri.toString();
    final isSelected = items.any((item) {
      // If path has query params, require exact match
      if (item.path.contains('?')) {
        return currentPath == item.path;
      }
      // Otherwise, use startsWith for nested routes
      return currentPath == item.path || currentPath.startsWith('${item.path}/');
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: PopupMenuButton<String>(
        offset: const Offset(0, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onSelected: (path) => context.go(path),
        itemBuilder: (context) => items.map((item) {
          return PopupMenuItem<String>(
            value: item.path,
            child: Row(
              children: [
                Icon(
                  item.icon,
                  size: 18,
                  color: EventismTheme.textSecondary,
                ),
                const SizedBox(width: 12),
                Text(item.label),
              ],
            ),
          );
        }).toList(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? EventismTheme.primary : EventismTheme.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 15,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down,
              size: 18,
              color: isSelected ? EventismTheme.primary : EventismTheme.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoIcon({required double size, double padding = 8}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            EventismTheme.primary,
            EventismTheme.primaryDark,
          ],
        ),
        borderRadius: BorderRadius.circular(size * 0.25),
      ),
      padding: EdgeInsets.all(padding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: size * 0.5,
            height: size * 0.1,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Container(
            width: size * 0.35,
            height: size * 0.1,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Container(
            width: size * 0.5,
            height: size * 0.1,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerSubItem {
  final String label;
  final String path;

  const _DrawerSubItem(this.label, this.path);
}

class _DropdownItem {
  final String label;
  final String path;
  final IconData icon;

  const _DropdownItem(this.label, this.path, this.icon);
}
