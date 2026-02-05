import 'package:go_router/go_router.dart';

import '../features/home/home_page.dart';
import '../features/browse/browse_page.dart';
import '../features/map/map_page.dart';
import '../features/calendar/calendar_page.dart';
import '../features/event_detail/event_detail_page.dart';
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
      ],
    ),
  ],
);
