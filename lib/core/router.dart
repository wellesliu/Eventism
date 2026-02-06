import 'package:go_router/go_router.dart';

import '../features/home/home_page.dart';
import '../features/browse/browse_page.dart';
import '../features/map/map_page.dart';
import '../features/calendar/calendar_page.dart';
import '../features/event_detail/event_detail_page.dart';
import '../features/about/about_page.dart';
import '../features/vendors/vendors_landing_page.dart';
import '../features/vendors/vendor_directory_page.dart';
import '../features/vendors/vendor_profile_page.dart';
import '../features/organizers/organizer_directory_page.dart';
import '../features/organizers/organizer_profile_page.dart';
import '../features/list_event/list_event_page.dart';
import '../features/join_vendor/join_vendor_page.dart';
import '../shared/widgets/shell_scaffold.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => ShellScaffold(child: child),
      routes: [
        GoRoute(
          path: '/',
          name: 'home',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: HomePage(),
          ),
        ),
        GoRoute(
          path: '/browse',
          name: 'browse',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: BrowsePage(),
          ),
        ),
        GoRoute(
          path: '/map',
          name: 'map',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: MapPage(),
          ),
        ),
        GoRoute(
          path: '/calendar',
          name: 'calendar',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: CalendarPage(),
          ),
        ),
        GoRoute(
          path: '/event/:id',
          name: 'eventDetail',
          pageBuilder: (context, state) => NoTransitionPage(
            child: EventDetailPage(
              eventId: state.pathParameters['id']!,
            ),
          ),
        ),
        GoRoute(
          path: '/about',
          name: 'about',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: AboutPage(),
          ),
        ),
        // Vendor routes
        GoRoute(
          path: '/vendors',
          name: 'vendorsLanding',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: VendorsLandingPage(),
          ),
        ),
        GoRoute(
          path: '/vendors/directory',
          name: 'vendorDirectory',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: VendorDirectoryPage(),
          ),
        ),
        GoRoute(
          path: '/vendor/:id',
          name: 'vendorProfile',
          pageBuilder: (context, state) => NoTransitionPage(
            child: VendorProfilePage(
              vendorId: state.pathParameters['id']!,
            ),
          ),
        ),
        // Organizer routes
        GoRoute(
          path: '/organizers',
          name: 'organizerDirectory',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: OrganizerDirectoryPage(),
          ),
        ),
        GoRoute(
          path: '/organizer/:id',
          name: 'organizerProfile',
          pageBuilder: (context, state) => NoTransitionPage(
            child: OrganizerProfilePage(
              organizerId: state.pathParameters['id']!,
            ),
          ),
        ),
        // CTA routes
        GoRoute(
          path: '/list-event',
          name: 'listEvent',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ListEventPage(),
          ),
        ),
        GoRoute(
          path: '/join-vendor',
          name: 'joinVendor',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: JoinVendorPage(),
          ),
        ),
      ],
    ),
  ],
);
