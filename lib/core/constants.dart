class AppConstants {
  static const appName = 'Eventism';
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
  static const vendorsJsonPath = 'assets/data/vendors.json';
  static const organizersJsonPath = 'assets/data/organizers.json';
  static const testimonialsJsonPath = 'assets/data/testimonials.json';

  // Date formats
  static const dateFormat = 'MMM d, yyyy';
  static const timeFormat = 'h:mm a';
  static const dateTimeFormat = 'MMM d, yyyy h:mm a';

  // Vendor categories
  static const vendorCategories = [
    'Food & Beverage',
    'Handmade Crafts',
    'Art & Photography',
    'Fashion & Accessories',
    'Health & Beauty',
    'Home & Garden',
    'Kids & Family',
    'Collectibles',
    'Pop Culture',
    'Other',
  ];

  // Organizer event types
  static const organizerEventTypes = [
    'Markets',
    'Food Festivals',
    'Artisan Fairs',
    'Conventions',
    'Gaming Expos',
    'Pop Culture',
    'Music Festivals',
    'Concerts',
    'Live Entertainment',
    'Workshops',
    'Festivals',
    'Anime',
  ];

  // Price range options
  static const priceRangeOptions = [
    'Free',
    'Under \$20',
    '\$20 - \$50',
    '\$50 - \$100',
    '\$100+',
  ];

  // Event size options
  static const eventSizeOptions = [
    'Intimate (< 100)',
    'Medium (100 - 500)',
    'Large (500 - 1000)',
    'Major (1000+)',
  ];

  // Australian cities for filtering
  static const australianCities = [
    'Sydney',
    'Melbourne',
    'Brisbane',
    'Perth',
    'Adelaide',
    'Gold Coast',
    'Newcastle',
    'Canberra',
    'Hobart',
    'Darwin',
    'Wollongong',
    'Geelong',
    'Townsville',
    'Cairns',
    'Toowoomba',
  ];
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
