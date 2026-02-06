import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../data/models/organizer.dart';
import '../../data/providers/organizers_provider.dart';
import '../../shared/widgets/empty_state.dart';
import 'widgets/organizer_card.dart';

// Organizer directory state
class OrganizerDirectoryFilters {
  final String? query;
  final String? eventType;
  final String? location;

  const OrganizerDirectoryFilters({
    this.query,
    this.eventType,
    this.location,
  });

  OrganizerDirectoryFilters copyWith({
    String? query,
    String? eventType,
    String? location,
    bool clearQuery = false,
    bool clearEventType = false,
    bool clearLocation = false,
  }) {
    return OrganizerDirectoryFilters(
      query: clearQuery ? null : (query ?? this.query),
      eventType: clearEventType ? null : (eventType ?? this.eventType),
      location: clearLocation ? null : (location ?? this.location),
    );
  }

  bool get hasFilters =>
      (query != null && query!.isNotEmpty) ||
      eventType != null ||
      location != null;
}

class OrganizerDirectoryNotifier extends StateNotifier<OrganizerDirectoryFilters> {
  OrganizerDirectoryNotifier() : super(const OrganizerDirectoryFilters());

  void setQuery(String? query) {
    if (query == null || query.isEmpty) {
      state = state.copyWith(clearQuery: true);
    } else {
      state = state.copyWith(query: query);
    }
  }

  void setEventType(String? eventType) {
    if (eventType == null) {
      state = state.copyWith(clearEventType: true);
    } else {
      state = state.copyWith(eventType: eventType);
    }
  }

  void setLocation(String? location) {
    if (location == null) {
      state = state.copyWith(clearLocation: true);
    } else {
      state = state.copyWith(location: location);
    }
  }

  void clearFilters() {
    state = const OrganizerDirectoryFilters();
  }
}

final organizerDirectoryFiltersProvider =
    StateNotifierProvider<OrganizerDirectoryNotifier, OrganizerDirectoryFilters>((ref) {
  return OrganizerDirectoryNotifier();
});

final filteredOrganizersProvider = FutureProvider<List<Organizer>>((ref) async {
  final filters = ref.watch(organizerDirectoryFiltersProvider);
  final organizers = await ref.watch(organizersProvider.future);

  var filtered = organizers.toList();

  // Apply search query
  if (filters.query != null && filters.query!.isNotEmpty) {
    filtered = filtered.where((o) => o.matchesSearch(filters.query!)).toList();
  }

  // Apply event type filter
  if (filters.eventType != null) {
    filtered = filtered.where((o) => o.hasEventType(filters.eventType!)).toList();
  }

  // Apply location filter
  if (filters.location != null) {
    filtered = filtered
        .where((o) =>
            o.location?.toLowerCase().contains(filters.location!.toLowerCase()) ?? false)
        .toList();
  }

  return filtered;
});

class OrganizerDirectoryPage extends ConsumerStatefulWidget {
  const OrganizerDirectoryPage({super.key});

  @override
  ConsumerState<OrganizerDirectoryPage> createState() => _OrganizerDirectoryPageState();
}

class _OrganizerDirectoryPageState extends ConsumerState<OrganizerDirectoryPage> {
  final _searchController = TextEditingController();
  bool _showFilters = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = Breakpoints.isMobile(width);
    final isDesktop = Breakpoints.isDesktop(width) || Breakpoints.isLargeDesktop(width);
    final filters = ref.watch(organizerDirectoryFiltersProvider);
    final organizersAsync = ref.watch(filteredOrganizersProvider);
    final eventTypesAsync = ref.watch(organizerEventTypesProvider);
    final locationsAsync = ref.watch(organizerLocationsProvider);
    final columns = Breakpoints.getGridColumns(width);

    return Row(
      children: [
        // Filter sidebar (desktop)
        if (isDesktop)
          SizedBox(
            width: 280,
            child: _buildFilterPanel(
              context,
              eventTypesAsync,
              locationsAsync,
              filters,
              compact: false,
            ),
          ),
        // Main content
        Expanded(
          child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 16 : 24,
                  vertical: isMobile ? 24 : 32,
                ),
                color: EventismTheme.surface,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Find Organizers',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Connect with event organizers across Australia',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 20),
                    // Search bar
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search organizers...',
                              prefixIcon: const Icon(Icons.search),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        _searchController.clear();
                                        ref
                                            .read(organizerDirectoryFiltersProvider.notifier)
                                            .setQuery(null);
                                      },
                                    )
                                  : null,
                            ),
                            onSubmitted: (value) {
                              ref
                                  .read(organizerDirectoryFiltersProvider.notifier)
                                  .setQuery(value);
                            },
                          ),
                        ),
                        if (!isDesktop) ...[
                          const SizedBox(width: 12),
                          IconButton.filled(
                            onPressed: () {
                              setState(() => _showFilters = !_showFilters);
                            },
                            icon: Badge(
                              isLabelVisible: filters.hasFilters,
                              child: const Icon(Icons.tune),
                            ),
                          ),
                        ],
                      ],
                    ),
                    // Mobile filter panel
                    if (!isDesktop && _showFilters)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: _buildFilterPanel(
                          context,
                          eventTypesAsync,
                          locationsAsync,
                          filters,
                          compact: true,
                        ),
                      ),
                    // Active filters
                    if (filters.hasFilters)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: _buildActiveFilters(filters),
                      ),
                  ],
                ),
              ),
              // Results
              Expanded(
                child: organizersAsync.when(
                  data: (organizers) {
                    if (organizers.isEmpty) {
                      return Center(
                        child: EmptyState(
                          icon: Icons.business_outlined,
                          title: 'No organizers found',
                          subtitle: 'Try adjusting your search or filters',
                          customAction: filters.hasFilters
                              ? TextButton(
                                  onPressed: () {
                                    ref
                                        .read(organizerDirectoryFiltersProvider.notifier)
                                        .clearFilters();
                                    _searchController.clear();
                                  },
                                  child: const Text('Clear filters'),
                                )
                              : null,
                        ),
                      );
                    }

                    return Column(
                      children: [
                        // Results count
                        Padding(
                          padding: EdgeInsets.all(isMobile ? 16 : 24),
                          child: Row(
                            children: [
                              Text(
                                '${organizers.length} organizers found',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        // Organizer grid
                        Expanded(
                          child: GridView.builder(
                            padding: EdgeInsets.symmetric(
                              horizontal: isMobile ? 16 : 24,
                            ),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: isDesktop ? columns - 1 : columns,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              childAspectRatio: isDesktop ? 1.1 : 0.85,
                            ),
                            itemCount: organizers.length,
                            itemBuilder: (context, index) {
                              return OrganizerCard(organizer: organizers[index]);
                            },
                          ),
                        ),
                      ],
                    );
                  },
                  loading: () => GridView.builder(
                    padding: EdgeInsets.all(isMobile ? 16 : 24),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isDesktop ? columns - 1 : columns,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: isDesktop ? 1.1 : 0.85,
                    ),
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return const OrganizerCardSkeleton();
                    },
                  ),
                  error: (error, _) => Center(
                    child: Text('Error: $error'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterPanel(
    BuildContext context,
    AsyncValue<List<String>> eventTypesAsync,
    AsyncValue<List<String>> locationsAsync,
    OrganizerDirectoryFilters filters, {
    required bool compact,
  }) {
    final content = SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filters',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (filters.hasFilters)
                TextButton(
                  onPressed: () {
                    ref.read(organizerDirectoryFiltersProvider.notifier).clearFilters();
                    _searchController.clear();
                  },
                  child: const Text('Clear all'),
                ),
            ],
          ),
          const SizedBox(height: 20),

          // Event Types
          Text(
            'Event Types',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 12),
          eventTypesAsync.when(
            data: (eventTypes) {
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: eventTypes.map((type) {
                  final isSelected = filters.eventType == type;
                  return FilterChip(
                    label: Text(type),
                    selected: isSelected,
                    onSelected: (_) {
                      if (isSelected) {
                        ref
                            .read(organizerDirectoryFiltersProvider.notifier)
                            .setEventType(null);
                      } else {
                        ref
                            .read(organizerDirectoryFiltersProvider.notifier)
                            .setEventType(type);
                      }
                    },
                    selectedColor: EventismTheme.primary.withValues(alpha: 0.2),
                    checkmarkColor: EventismTheme.primary,
                    labelStyle: TextStyle(
                      color:
                          isSelected ? EventismTheme.primary : EventismTheme.textPrimary,
                      fontSize: 13,
                    ),
                  );
                }).toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const Text('Failed to load event types'),
          ),
          const SizedBox(height: 20),

          // Location
          Text(
            'Location',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 12),
          locationsAsync.when(
            data: (locations) {
              return DropdownButtonFormField<String>(
                value: filters.location,
                decoration: const InputDecoration(
                  hintText: 'Select location',
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('All locations'),
                  ),
                  ...locations.map((loc) => DropdownMenuItem(
                        value: loc,
                        child: Text(loc),
                      )),
                ],
                onChanged: (value) {
                  ref
                      .read(organizerDirectoryFiltersProvider.notifier)
                      .setLocation(value);
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const Text('Failed to load locations'),
          ),
        ],
      ),
    );

    if (compact) {
      return Container(
        decoration: BoxDecoration(
          color: EventismTheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: EventismTheme.border),
        ),
        child: content,
      );
    }

    return Container(
      decoration: const BoxDecoration(
        color: EventismTheme.surface,
        border: Border(
          right: BorderSide(color: EventismTheme.border),
        ),
      ),
      child: content,
    );
  }

  Widget _buildActiveFilters(OrganizerDirectoryFilters filters) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (filters.query != null && filters.query!.isNotEmpty)
          Chip(
            label: Text('Search: ${filters.query}'),
            onDeleted: () {
              _searchController.clear();
              ref.read(organizerDirectoryFiltersProvider.notifier).setQuery(null);
            },
          ),
        if (filters.eventType != null)
          Chip(
            label: Text(filters.eventType!),
            onDeleted: () {
              ref.read(organizerDirectoryFiltersProvider.notifier).setEventType(null);
            },
          ),
        if (filters.location != null)
          Chip(
            label: Text(filters.location!),
            onDeleted: () {
              ref.read(organizerDirectoryFiltersProvider.notifier).setLocation(null);
            },
          ),
      ],
    );
  }
}
