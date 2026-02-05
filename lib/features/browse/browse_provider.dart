import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants.dart';
import '../../data/models/event.dart';
import '../../data/providers/events_provider.dart';

class BrowseFilters {
  final String? query;
  final List<String> tags;
  final String? city;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool acceptingVendors;
  final int pageSize;
  final int page;

  const BrowseFilters({
    this.query,
    this.tags = const [],
    this.city,
    this.startDate,
    this.endDate,
    this.acceptingVendors = false,
    this.pageSize = AppConstants.defaultPageSize,
    this.page = 1,
  });

  BrowseFilters copyWith({
    String? query,
    List<String>? tags,
    String? city,
    DateTime? startDate,
    DateTime? endDate,
    bool? acceptingVendors,
    int? pageSize,
    int? page,
  }) {
    return BrowseFilters(
      query: query ?? this.query,
      tags: tags ?? this.tags,
      city: city ?? this.city,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      acceptingVendors: acceptingVendors ?? this.acceptingVendors,
      pageSize: pageSize ?? this.pageSize,
      page: page ?? this.page,
    );
  }

  bool get hasFilters =>
      (query != null && query!.isNotEmpty) ||
      tags.isNotEmpty ||
      (city != null && city!.isNotEmpty) ||
      startDate != null ||
      endDate != null ||
      acceptingVendors;
}

class BrowseStateNotifier extends StateNotifier<BrowseFilters> {
  BrowseStateNotifier() : super(const BrowseFilters());

  void setQuery(String? query) {
    state = state.copyWith(query: query, page: 1);
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
    state = state.copyWith(city: city, page: 1);
  }

  void setDateRange(DateTime? start, DateTime? end) {
    state = state.copyWith(startDate: start, endDate: end, page: 1);
  }

  void setAcceptingVendors(bool value) {
    state = state.copyWith(acceptingVendors: value, page: 1);
  }

  void setPageSize(int size) {
    state = state.copyWith(pageSize: size, page: 1);
  }

  void setPage(int page) {
    state = state.copyWith(page: page);
  }

  void clearFilters() {
    state = BrowseFilters(pageSize: state.pageSize);
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
