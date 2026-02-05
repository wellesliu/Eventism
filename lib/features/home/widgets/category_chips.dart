import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme.dart';
import '../../../data/providers/events_provider.dart';

class CategoryChips extends ConsumerWidget {
  const CategoryChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tagsAsync = ref.watch(allTagsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Browse by Category',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            TextButton(
              onPressed: () => context.go('/browse'),
              child: const Text('View all'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        tagsAsync.when(
          data: (tags) {
            // Show top 12 tags
            final displayTags = tags.take(12).toList();
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: displayTags.map((tag) {
                return ActionChip(
                  label: Text(tag),
                  backgroundColor: EventsiaTheme.surface,
                  side: const BorderSide(color: EventsiaTheme.border),
                  labelStyle: const TextStyle(
                    color: EventsiaTheme.textPrimary,
                  ),
                  onPressed: () {
                    context.go('/browse?tag=${Uri.encodeComponent(tag)}');
                  },
                );
              }).toList(),
            );
          },
          loading: () => const Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _SkeletonChip(),
              _SkeletonChip(),
              _SkeletonChip(),
              _SkeletonChip(),
              _SkeletonChip(),
              _SkeletonChip(),
            ],
          ),
          error: (_, __) => const Text('Failed to load categories'),
        ),
      ],
    );
  }
}

class _SkeletonChip extends StatelessWidget {
  const _SkeletonChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 36,
      decoration: BoxDecoration(
        color: EventsiaTheme.border,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
