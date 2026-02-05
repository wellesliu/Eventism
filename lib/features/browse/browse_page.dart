import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/constants.dart';
import '../../core/theme.dart';
import 'browse_provider.dart';
import 'widgets/event_card.dart';
import 'widgets/filter_sidebar.dart';
import 'widgets/pagination_controls.dart';

class BrowsePage extends ConsumerStatefulWidget {
  const BrowsePage({super.key});

  @override
  ConsumerState<BrowsePage> createState() => _BrowsePageState();
}

class _BrowsePageState extends ConsumerState<BrowsePage> {
  final _searchController = TextEditingController();
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    // Check for query params
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final uri = GoRouterState.of(context).uri;
      final query = uri.queryParameters['q'];
      final tag = uri.queryParameters['tag'];

      if (query != null) {
        _searchController.text = query;
        ref.read(browseStateProvider.notifier).setQuery(query);
      }
      if (tag != null) {
        ref.read(browseStateProvider.notifier).toggleTag(tag);
      }
    });
  }

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
    final browseResult = ref.watch(browseEventsProvider);
    final filters = ref.watch(browseStateProvider);
    final columns = Breakpoints.getGridColumns(width);

    return Row(
      children: [
        // Sidebar for desktop
        if (isDesktop)
          SizedBox(
            width: 280,
            child: FilterSidebar(
              onClose: () {},
            ),
          ),
        // Main content
        Expanded(
          child: Column(
            children: [
              // Search and filter bar
              Container(
                padding: EdgeInsets.all(isMobile ? 16 : 24),
                decoration: const BoxDecoration(
                  color: EventismTheme.surface,
                  border: Border(
                    bottom: BorderSide(color: EventismTheme.border),
                  ),
                ),
                child: Column(
                  children: [
                    // Main search row with date filters
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        // Search field
                        SizedBox(
                          width: isMobile ? double.infinity : 400,
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search events...',
                              prefixIcon: const Icon(Icons.search),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        _searchController.clear();
                                        ref.read(browseStateProvider.notifier).setQuery(null);
                                      },
                                    )
                                  : null,
                            ),
                            onSubmitted: (value) {
                              ref.read(browseStateProvider.notifier).setQuery(value);
                            },
                          ),
                        ),
                        // Date range pickers
                        _buildDateButton(
                          context,
                          ref,
                          label: 'From',
                          date: filters.startDate,
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: filters.startDate ?? DateTime.now(),
                              firstDate: DateTime.now().subtract(const Duration(days: 30)),
                              lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                            );
                            if (date != null) {
                              ref.read(browseStateProvider.notifier).setDateRange(
                                    date,
                                    filters.endDate,
                                  );
                            }
                          },
                          onClear: filters.startDate != null
                              ? () => ref.read(browseStateProvider.notifier).setDateRange(null, filters.endDate)
                              : null,
                        ),
                        _buildDateButton(
                          context,
                          ref,
                          label: 'To',
                          date: filters.endDate,
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: filters.endDate ??
                                  (filters.startDate ?? DateTime.now()).add(const Duration(days: 30)),
                              firstDate: filters.startDate ?? DateTime.now().subtract(const Duration(days: 30)),
                              lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                            );
                            if (date != null) {
                              ref.read(browseStateProvider.notifier).setDateRange(
                                    filters.startDate,
                                    date,
                                  );
                            }
                          },
                          onClear: filters.endDate != null
                              ? () => ref.read(browseStateProvider.notifier).setDateRange(filters.startDate, null)
                              : null,
                        ),
                        // Accepting vendors checkbox
                        Container(
                          decoration: BoxDecoration(
                            color: filters.acceptingVendors
                                ? EventismTheme.success.withValues(alpha: 0.1)
                                : EventismTheme.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: filters.acceptingVendors
                                  ? EventismTheme.success
                                  : EventismTheme.border,
                            ),
                          ),
                          child: InkWell(
                            onTap: () {
                              ref.read(browseStateProvider.notifier)
                                  .setAcceptingVendors(!filters.acceptingVendors);
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    filters.acceptingVendors
                                        ? Icons.check_box
                                        : Icons.check_box_outline_blank,
                                    size: 20,
                                    color: filters.acceptingVendors
                                        ? EventismTheme.success
                                        : EventismTheme.textMuted,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Accepting Vendors',
                                    style: TextStyle(
                                      color: filters.acceptingVendors
                                          ? EventismTheme.success
                                          : EventismTheme.textSecondary,
                                      fontWeight: filters.acceptingVendors
                                          ? FontWeight.w500
                                          : FontWeight.w400,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // More filters button (mobile)
                        if (!isDesktop)
                          IconButton.filled(
                            onPressed: () {
                              setState(() => _showFilters = !_showFilters);
                            },
                            icon: Badge(
                              isLabelVisible: filters.tags.isNotEmpty || filters.city != null,
                              child: const Icon(Icons.tune),
                            ),
                          ),
                      ],
                    ),
                    // Mobile filter panel
                    if (!isDesktop && _showFilters)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: FilterSidebar(
                          onClose: () => setState(() => _showFilters = false),
                          compact: true,
                        ),
                      ),
                    // Active filters chips
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
                child: browseResult.when(
                  data: (result) {
                    if (result.events.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: EventismTheme.textMuted,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No events found',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Try adjusting your filters',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: () {
                                ref.read(browseStateProvider.notifier).clearFilters();
                                _searchController.clear();
                              },
                              child: const Text('Clear filters'),
                            ),
                          ],
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
                                '${result.totalCount} events found',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const Spacer(),
                              // Page size selector
                              DropdownButton<int>(
                                value: result.pageSize,
                                items: AppConstants.pageSizeOptions.map((size) {
                                  return DropdownMenuItem(
                                    value: size,
                                    child: Text('$size per page'),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    ref.read(browseStateProvider.notifier).setPageSize(value);
                                  }
                                },
                                underline: const SizedBox(),
                              ),
                            ],
                          ),
                        ),
                        // Event grid
                        Expanded(
                          child: GridView.builder(
                            padding: EdgeInsets.symmetric(
                              horizontal: isMobile ? 16 : 24,
                            ),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: isDesktop ? columns - 1 : columns,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              childAspectRatio: 1.0,
                            ),
                            itemCount: result.events.length,
                            itemBuilder: (context, index) {
                              return EventCard(event: result.events[index]);
                            },
                          ),
                        ),
                        // Pagination
                        if (result.totalPages > 1)
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: PaginationControls(
                              currentPage: result.currentPage,
                              totalPages: result.totalPages,
                              onPageChanged: (page) {
                                ref.read(browseStateProvider.notifier).setPage(page);
                              },
                            ),
                          ),
                      ],
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
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

  Widget _buildDateButton(
    BuildContext context,
    WidgetRef ref, {
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
    VoidCallback? onClear,
  }) {
    final dateFormat = DateFormat('MMM d, y');
    final hasDate = date != null;

    return Container(
      constraints: const BoxConstraints(minWidth: 140),
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          side: BorderSide(
            color: hasDate ? EventismTheme.primary : EventismTheme.border,
          ),
          backgroundColor: hasDate ? EventismTheme.primary.withValues(alpha: 0.05) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_today,
              size: 16,
              color: hasDate ? EventismTheme.primary : EventismTheme.textMuted,
            ),
            const SizedBox(width: 8),
            Text(
              hasDate ? dateFormat.format(date) : label,
              style: TextStyle(
                color: hasDate ? EventismTheme.primary : EventismTheme.textSecondary,
                fontWeight: hasDate ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
            if (onClear != null) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onClear,
                child: Icon(
                  Icons.close,
                  size: 16,
                  color: EventismTheme.textMuted,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActiveFilters(BrowseFilters filters) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (filters.query != null && filters.query!.isNotEmpty)
          Chip(
            label: Text('Search: ${filters.query}'),
            onDeleted: () {
              _searchController.clear();
              ref.read(browseStateProvider.notifier).setQuery(null);
            },
          ),
        ...filters.tags.map((tag) => Chip(
              label: Text(tag),
              onDeleted: () {
                ref.read(browseStateProvider.notifier).toggleTag(tag);
              },
            )),
        if (filters.city != null && filters.city!.isNotEmpty)
          Chip(
            label: Text(filters.city!),
            onDeleted: () {
              ref.read(browseStateProvider.notifier).setCity(null);
            },
          ),
        if (filters.startDate != null || filters.endDate != null)
          Chip(
            label: const Text('Date range'),
            onDeleted: () {
              ref.read(browseStateProvider.notifier).setDateRange(null, null);
            },
          ),
      ],
    );
  }
}
