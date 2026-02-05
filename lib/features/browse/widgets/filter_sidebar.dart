import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme.dart';
import '../../../data/providers/events_provider.dart';
import '../browse_provider.dart';

class FilterSidebar extends ConsumerWidget {
  final VoidCallback onClose;
  final bool compact;

  const FilterSidebar({
    super.key,
    required this.onClose,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tagsAsync = ref.watch(allTagsProvider);
    final citiesAsync = ref.watch(allCitiesProvider);
    final filters = ref.watch(browseStateProvider);

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
                    ref.read(browseStateProvider.notifier).clearFilters();
                  },
                  child: const Text('Clear all'),
                ),
            ],
          ),
          const SizedBox(height: 24),

          // Categories
          Text(
            'Categories',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 12),
          tagsAsync.when(
            data: (tags) {
              final displayTags = tags.take(20).toList();
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: displayTags.map((tag) {
                  final isSelected = filters.tags.contains(tag);
                  return FilterChip(
                    label: Text(tag),
                    selected: isSelected,
                    onSelected: (_) {
                      ref.read(browseStateProvider.notifier).toggleTag(tag);
                    },
                    selectedColor: EventsiaTheme.primary.withValues(alpha: 0.2),
                    checkmarkColor: EventsiaTheme.primary,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? EventsiaTheme.primary
                          : EventsiaTheme.textPrimary,
                      fontSize: 13,
                    ),
                  );
                }).toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const Text('Failed to load categories'),
          ),
          const SizedBox(height: 24),

          // Cities
          Text(
            'Location',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 12),
          citiesAsync.when(
            data: (cities) {
              return DropdownButtonFormField<String>(
                initialValue: filters.city,
                decoration: const InputDecoration(
                  hintText: 'Select city',
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('All cities'),
                  ),
                  ...cities.map((city) => DropdownMenuItem(
                        value: city,
                        child: Text(city),
                      )),
                ],
                onChanged: (value) {
                  ref.read(browseStateProvider.notifier).setCity(value);
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const Text('Failed to load cities'),
          ),
          const SizedBox(height: 24),

          // Date range
          Text(
            'Date Range',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: filters.startDate ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                    );
                    if (date != null) {
                      ref.read(browseStateProvider.notifier).setDateRange(
                            date,
                            filters.endDate,
                          );
                    }
                  },
                  icon: const Icon(Icons.calendar_today, size: 16),
                  label: Text(
                    filters.startDate != null
                        ? '${filters.startDate!.month}/${filters.startDate!.day}'
                        : 'From',
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text('-'),
              ),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: filters.endDate ??
                          (filters.startDate ?? DateTime.now())
                              .add(const Duration(days: 30)),
                      firstDate: filters.startDate ?? DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                    );
                    if (date != null) {
                      ref.read(browseStateProvider.notifier).setDateRange(
                            filters.startDate,
                            date,
                          );
                    }
                  },
                  icon: const Icon(Icons.calendar_today, size: 16),
                  label: Text(
                    filters.endDate != null
                        ? '${filters.endDate!.month}/${filters.endDate!.day}'
                        : 'To',
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
          if (filters.startDate != null || filters.endDate != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: TextButton(
                onPressed: () {
                  ref.read(browseStateProvider.notifier).setDateRange(null, null);
                },
                child: const Text('Clear dates'),
              ),
            ),
        ],
      ),
    );

    if (compact) {
      return Container(
        decoration: BoxDecoration(
          color: EventsiaTheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: EventsiaTheme.border),
        ),
        child: content,
      );
    }

    return Container(
      decoration: const BoxDecoration(
        color: EventsiaTheme.surface,
        border: Border(
          right: BorderSide(color: EventsiaTheme.border),
        ),
      ),
      child: content,
    );
  }
}
