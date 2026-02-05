import 'package:flutter/material.dart';

import '../../../core/theme.dart';

class PaginationControls extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;

  const PaginationControls({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Previous button
        IconButton(
          onPressed: currentPage > 1
              ? () => onPageChanged(currentPage - 1)
              : null,
          icon: const Icon(Icons.chevron_left),
        ),
        // Page numbers
        ..._buildPageNumbers(),
        // Next button
        IconButton(
          onPressed: currentPage < totalPages
              ? () => onPageChanged(currentPage + 1)
              : null,
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }

  List<Widget> _buildPageNumbers() {
    final pages = <Widget>[];
    final start = (currentPage - 2).clamp(1, totalPages);
    final end = (currentPage + 2).clamp(1, totalPages);

    // First page
    if (start > 1) {
      pages.add(_PageButton(
        page: 1,
        isSelected: currentPage == 1,
        onTap: () => onPageChanged(1),
      ));
      if (start > 2) {
        pages.add(const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text('...'),
        ));
      }
    }

    // Middle pages
    for (int i = start; i <= end; i++) {
      pages.add(_PageButton(
        page: i,
        isSelected: currentPage == i,
        onTap: () => onPageChanged(i),
      ));
    }

    // Last page
    if (end < totalPages) {
      if (end < totalPages - 1) {
        pages.add(const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text('...'),
        ));
      }
      pages.add(_PageButton(
        page: totalPages,
        isSelected: currentPage == totalPages,
        onTap: () => onPageChanged(totalPages),
      ));
    }

    return pages;
  }
}

class _PageButton extends StatelessWidget {
  final int page;
  final bool isSelected;
  final VoidCallback onTap;

  const _PageButton({
    required this.page,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        color: isSelected ? EventismTheme.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: isSelected ? null : onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            child: Text(
              '$page',
              style: TextStyle(
                color: isSelected ? Colors.white : EventismTheme.textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
