import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../data/models/vendor.dart';
import '../../data/providers/vendors_provider.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/skeleton_loader.dart';
import 'widgets/vendor_card.dart';

// Vendor directory state
class VendorDirectoryFilters {
  final String? query;
  final String? category;
  final String? location;
  final bool availableOnly;

  const VendorDirectoryFilters({
    this.query,
    this.category,
    this.location,
    this.availableOnly = false,
  });

  VendorDirectoryFilters copyWith({
    String? query,
    String? category,
    String? location,
    bool? availableOnly,
    bool clearQuery = false,
    bool clearCategory = false,
    bool clearLocation = false,
  }) {
    return VendorDirectoryFilters(
      query: clearQuery ? null : (query ?? this.query),
      category: clearCategory ? null : (category ?? this.category),
      location: clearLocation ? null : (location ?? this.location),
      availableOnly: availableOnly ?? this.availableOnly,
    );
  }

  bool get hasFilters =>
      (query != null && query!.isNotEmpty) ||
      category != null ||
      location != null ||
      availableOnly;
}

class VendorDirectoryNotifier extends StateNotifier<VendorDirectoryFilters> {
  VendorDirectoryNotifier() : super(const VendorDirectoryFilters());

  void setQuery(String? query) {
    if (query == null || query.isEmpty) {
      state = state.copyWith(clearQuery: true);
    } else {
      state = state.copyWith(query: query);
    }
  }

  void setCategory(String? category) {
    if (category == null) {
      state = state.copyWith(clearCategory: true);
    } else {
      state = state.copyWith(category: category);
    }
  }

  void setLocation(String? location) {
    if (location == null) {
      state = state.copyWith(clearLocation: true);
    } else {
      state = state.copyWith(location: location);
    }
  }

  void setAvailableOnly(bool value) {
    state = state.copyWith(availableOnly: value);
  }

  void clearFilters() {
    state = const VendorDirectoryFilters();
  }
}

final vendorDirectoryFiltersProvider =
    StateNotifierProvider<VendorDirectoryNotifier, VendorDirectoryFilters>((ref) {
  return VendorDirectoryNotifier();
});

final filteredVendorsProvider = FutureProvider<List<Vendor>>((ref) async {
  final filters = ref.watch(vendorDirectoryFiltersProvider);
  final vendors = await ref.watch(vendorsProvider.future);

  var filtered = vendors.toList();

  // Apply search query
  if (filters.query != null && filters.query!.isNotEmpty) {
    filtered = filtered.where((v) => v.matchesSearch(filters.query!)).toList();
  }

  // Apply category filter
  if (filters.category != null) {
    filtered = filtered.where((v) => v.hasCategory(filters.category!)).toList();
  }

  // Apply location filter
  if (filters.location != null) {
    filtered = filtered
        .where((v) =>
            v.location?.toLowerCase().contains(filters.location!.toLowerCase()) ?? false)
        .toList();
  }

  // Apply availability filter
  if (filters.availableOnly) {
    filtered = filtered.where((v) => v.isAvailable).toList();
  }

  return filtered;
});

class VendorDirectoryPage extends ConsumerStatefulWidget {
  const VendorDirectoryPage({super.key});

  @override
  ConsumerState<VendorDirectoryPage> createState() => _VendorDirectoryPageState();
}

class _VendorDirectoryPageState extends ConsumerState<VendorDirectoryPage> {
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
    final filters = ref.watch(vendorDirectoryFiltersProvider);
    final vendorsAsync = ref.watch(filteredVendorsProvider);
    final categoriesAsync = ref.watch(vendorCategoriesProvider);
    final locationsAsync = ref.watch(vendorLocationsProvider);
    final columns = Breakpoints.getGridColumns(width);

    return Row(
      children: [
        // Filter sidebar (desktop)
        if (isDesktop)
          SizedBox(
            width: 280,
            child: _buildFilterPanel(
              context,
              categoriesAsync,
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
                      'Find Vendors',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Discover talented vendors for your next event',
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
                              hintText: 'Search vendors...',
                              prefixIcon: const Icon(Icons.search),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        _searchController.clear();
                                        ref
                                            .read(vendorDirectoryFiltersProvider.notifier)
                                            .setQuery(null);
                                      },
                                    )
                                  : null,
                            ),
                            onSubmitted: (value) {
                              ref
                                  .read(vendorDirectoryFiltersProvider.notifier)
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
                          categoriesAsync,
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
                child: vendorsAsync.when(
                  data: (vendors) {
                    if (vendors.isEmpty) {
                      return Center(
                        child: EmptyState(
                          icon: Icons.storefront_outlined,
                          title: 'No vendors found',
                          subtitle: 'Try adjusting your search or filters',
                          customAction: filters.hasFilters
                              ? TextButton(
                                  onPressed: () {
                                    ref
                                        .read(vendorDirectoryFiltersProvider.notifier)
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
                                '${vendors.length} vendors found',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        // Vendor grid
                        Expanded(
                          child: GridView.builder(
                            padding: EdgeInsets.symmetric(
                              horizontal: isMobile ? 16 : 24,
                            ),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: isDesktop ? columns - 1 : columns,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              childAspectRatio: isDesktop ? 1.6 : 1.0,
                            ),
                            itemCount: vendors.length,
                            itemBuilder: (context, index) {
                              return VendorCard(vendor: vendors[index]);
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
                      childAspectRatio: isDesktop ? 1.6 : 1.0,
                    ),
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return const VendorCardSkeleton();
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
    AsyncValue<List<String>> categoriesAsync,
    AsyncValue<List<String>> locationsAsync,
    VendorDirectoryFilters filters, {
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
                    ref.read(vendorDirectoryFiltersProvider.notifier).clearFilters();
                    _searchController.clear();
                  },
                  child: const Text('Clear all'),
                ),
            ],
          ),
          const SizedBox(height: 20),

          // Available only toggle
          InkWell(
            onTap: () {
              ref
                  .read(vendorDirectoryFiltersProvider.notifier)
                  .setAvailableOnly(!filters.availableOnly);
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: filters.availableOnly
                    ? EventismTheme.success.withValues(alpha: 0.1)
                    : EventismTheme.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: filters.availableOnly
                      ? EventismTheme.success
                      : EventismTheme.border,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    filters.availableOnly
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    size: 20,
                    color: filters.availableOnly
                        ? EventismTheme.success
                        : EventismTheme.textMuted,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Available for booking',
                    style: TextStyle(
                      color: filters.availableOnly
                          ? EventismTheme.success
                          : EventismTheme.textSecondary,
                      fontWeight:
                          filters.availableOnly ? FontWeight.w500 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Categories
          Text(
            'Categories',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 12),
          categoriesAsync.when(
            data: (categories) {
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: categories.map((cat) {
                  final isSelected = filters.category == cat;
                  return FilterChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (_) {
                      if (isSelected) {
                        ref
                            .read(vendorDirectoryFiltersProvider.notifier)
                            .setCategory(null);
                      } else {
                        ref
                            .read(vendorDirectoryFiltersProvider.notifier)
                            .setCategory(cat);
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
            error: (_, __) => const Text('Failed to load categories'),
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
                      .read(vendorDirectoryFiltersProvider.notifier)
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

  Widget _buildActiveFilters(VendorDirectoryFilters filters) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (filters.query != null && filters.query!.isNotEmpty)
          Chip(
            label: Text('Search: ${filters.query}'),
            onDeleted: () {
              _searchController.clear();
              ref.read(vendorDirectoryFiltersProvider.notifier).setQuery(null);
            },
          ),
        if (filters.category != null)
          Chip(
            label: Text(filters.category!),
            onDeleted: () {
              ref.read(vendorDirectoryFiltersProvider.notifier).setCategory(null);
            },
          ),
        if (filters.location != null)
          Chip(
            label: Text(filters.location!),
            onDeleted: () {
              ref.read(vendorDirectoryFiltersProvider.notifier).setLocation(null);
            },
          ),
        if (filters.availableOnly)
          Chip(
            label: const Text('Available'),
            onDeleted: () {
              ref.read(vendorDirectoryFiltersProvider.notifier).setAvailableOnly(false);
            },
          ),
      ],
    );
  }
}
