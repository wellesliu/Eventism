class AppConstants {
  static const appName = 'Eventsia';
  static const appTagline = 'Discover Amazing Events Near You';

  // Pagination
  static const defaultPageSize = 20;
  static const pageSizeOptions = [20, 50, 100];

  // Map defaults (centered on Australia)
  static const defaultLatitude = -25.2744;
  static const defaultLongitude = 133.7751;
  static const defaultZoom = 4.0;
  static const markerZoom = 12.0;

  // Responsive breakpoints
  static const mobileBreakpoint = 375.0;
  static const tabletBreakpoint = 768.0;
  static const desktopBreakpoint = 1024.0;
  static const largeDesktopBreakpoint = 1440.0;

  // Asset paths
  static const eventsJsonPath = 'assets/events.json';

  // Date formats
  static const dateFormat = 'MMM d, yyyy';
  static const timeFormat = 'h:mm a';
  static const dateTimeFormat = 'MMM d, yyyy h:mm a';
}

class Breakpoints {
  static bool isMobile(double width) => width < AppConstants.tabletBreakpoint;
  static bool isTablet(double width) =>
      width >= AppConstants.tabletBreakpoint && width < AppConstants.desktopBreakpoint;
  static bool isDesktop(double width) =>
      width >= AppConstants.desktopBreakpoint && width < AppConstants.largeDesktopBreakpoint;
  static bool isLargeDesktop(double width) => width >= AppConstants.largeDesktopBreakpoint;

  static int getGridColumns(double width) {
    if (width < AppConstants.tabletBreakpoint) return 1;
    if (width < AppConstants.desktopBreakpoint) return 2;
    if (width < AppConstants.largeDesktopBreakpoint) return 3;
    return 4;
  }
}
