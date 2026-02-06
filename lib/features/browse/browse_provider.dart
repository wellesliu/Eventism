import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants.dart';
import '../../data/models/event.dart';
import '../../data/providers/events_provider.dart';

enum ViewMode { grid, list }

enum SortOption { date, popularity, relevance }

class BrowseFilters {
  final String? query;
  final List<String> tags;
  final String? city;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool acceptingVendors;
  final String? priceRange;
  final int pageSize;
  final int page;
  final ViewMode viewMode;
  final SortOption sortBy;

  const BrowseFilters({
    this.query,
    this.tags = const [],
    this.city,
    this.startDate,
    this.endDate,
    this.acceptingVendors = false,
    this.priceRange,
    this.pageSize = AppConstants.defaultPageSize,
    this.page = 1,
    this.viewMode = ViewMode.grid,
    this.sortBy = SortOption.date,
  });

  BrowseFilters copyWith({
    String? query,
    List<String>? tags,
    String? city,
    DateTime? startDate,
    DateTime? endDate,
    bool? acceptingVendors,
    String? priceRange,
    int? pageSize,
    int? page,
    ViewMode? viewMode,
    SortOption? sortBy,
    bool clearQuery = false,
    bool clearCity = false,
    bool clearStartDate = false,
    bool clearEndDate = false,
    bool clearPriceRange = false,
  }) {
    return BrowseFilters(
      query: clearQuery ? null : (query ?? this.query),
      tags: tags ?? this.tags,
      city: clearCity ? null : (city ?? this.city),
      startDate: clearStartDate ? null : (startDate ?? this.startDate),
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
      acceptingVendors: acceptingVendors ?? this.acceptingVendors,
      priceRange: clearPriceRange ? null : (priceRange ?? this.priceRange),
      pageSize: pageSize ?? this.pageSize,
      page: page ?? this.page,
      viewMode: viewMode ?? this.viewMode,
      sortBy: sortBy ?? this.sortBy,
    );
  }

  bool get hasFilters =>
      (query != null && query!.isNotEmpty) ||
      tags.isNotEmpty ||
      (city != null && city!.isNotEmpty) ||
      startDate != null ||
      endDate != null ||
      acceptingVendors ||
      priceRange != null;
}

class BrowseStateNotifier extends StateNotifier<BrowseFilters> {
  BrowseStateNotifier() : super(const BrowseFilters());

  void setQuery(String? query) {
    if (query == null || query.isEmpty) {
      state = state.copyWith(clearQuery: true, page: 1);
    } else {
      state = state.copyWith(query: query, page: 1);
    }
  }

  void toggleTag(String tag) {
    final tags = List<String>.from(state.tags);
    if (tags.contains(tag)) {
      tags.remove(tag);
    } else {
      tags.add(tag);
    }
    state = state.copyWith(tags: tags, page: 1);
  }

  void setCity(String? city) {
    if (city == null) {
      state = state.copyWith(clearCity: true, page: 1);
    } else {
      state = state.copyWith(city: city, page: 1);
    }
  }

  void setDateRange(DateTime? start, DateTime? end) {
    state = state.copyWith(
      startDate: start,
      endDate: end,
      clearStartDate: start == null,
      clearEndDate: end == null,
      page: 1,
    );
  }

  void setAcceptingVendors(bool value) {
    state = state.copyWith(acceptingVendors: value, page: 1);
  }

  void setPriceRange(String? priceRange) {
    if (priceRange == null) {
      state = state.copyWith(clearPriceRange: true, page: 1);
    } else {
      state = state.copyWith(priceRange: priceRange, page: 1);
    }
  }

  void setPageSize(int size) {
    state = state.copyWith(pageSize: size, page: 1);
  }

  void setPage(int page) {
    state = state.copyWith(page: page);
  }

  void setViewMode(ViewMode mode) {
    state = state.copyWith(viewMode: mode);
  }

  void setSortBy(SortOption option) {
    state = state.copyWith(sortBy: option, page: 1);
  }

  void clearFilters() {
    state = BrowseFilters(
      pageSize: state.pageSize,
      viewMode: state.viewMode,
      sortBy: state.sortBy,
    );
  }
}

final browseStateProvider = StateNotifierProvider<BrowseStateNotifier, BrowseFilters>((ref) {
  return BrowseStateNotifier();
});

class BrowseResult {
  final List<Event> events;
  final int totalCount;
  final int currentPage;
  final int totalPages;
  final int pageSize;

  const BrowseResult({
    required this.events,
    required this.totalCount,
    required this.currentPage,
    required this.totalPages,
    required this.pageSize,
  });

  bool get hasPrevious => currentPage > 1;
  bool get hasNext => currentPage < totalPages;
}

final browseEventsProvider = FutureProvider<BrowseResult>((ref) async {
  final filters = ref.watch(browseStateProvider);
  final repository = ref.watch(eventRepositoryProvider);

  var allEvents = await repository.filterEvents(
    query: filters.query,
    tags: filters.tags.isNotEmpty ? filters.tags : null,
    city: filters.city,
    startDate: filters.startDate,
    endDate: filters.endDate,
  );

  // Filter by accepting vendors if enabled
  if (filters.acceptingVendors) {
    allEvents = allEvents.where((e) => e.acceptsVendors).toList();
  }

  // Filter by price range if set
  if (filters.priceRange != null) {
    allEvents = allEvents.where((e) => e.priceRange == filters.priceRange).toList();
  }

  // Sort events based on selected option
  switch (filters.sortBy) {
    case SortOption.date:
      allEvents.sort((a, b) {
        final aDate = a.startDateTime ?? DateTime(9999);
        final bDate = b.startDateTime ?? DateTime(9999);
        return aDate.compareTo(bDate);
      });
    case SortOption.popularity:
      allEvents.sort((a, b) {
        return b.interestCount.compareTo(a.interestCount); // Descending
      });
    case SortOption.relevance:
      // For relevance, featured events first, then by date
      allEvents.sort((a, b) {
        if (a.isFeatured && !b.isFeatured) return -1;
        if (!a.isFeatured && b.isFeatured) return 1;
        final aDate = a.startDateTime ?? DateTime(9999);
        final bDate = b.startDateTime ?? DateTime(9999);
        return aDate.compareTo(bDate);
      });
  }

  final totalPages = (allEvents.length / filters.pageSize).ceil();
  final start = (filters.page - 1) * filters.pageSize;
  final end = (start + filters.pageSize).clamp(0, allEvents.length);
  final pageEvents = start < allEvents.length ? allEvents.sublist(start, end) : <Event>[];

  return BrowseResult(
    events: pageEvents,
    totalCount: allEvents.length,
    currentPage: filters.page,
    totalPages: totalPages > 0 ? totalPages : 1,
    pageSize: filters.pageSize,
  );
});
