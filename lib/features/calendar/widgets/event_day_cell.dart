import 'package:flutter/material.dart';

import '../../../core/theme.dart';

class EventDayCell extends StatelessWidget {
  final DateTime day;
  final int eventCount;
  final bool isSelected;
  final bool isToday;

  const EventDayCell({
    super.key,
    required this.day,
    required this.eventCount,
    this.isSelected = false,
    this.isToday = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isSelected
            ? EventismTheme.primary
            : isToday
                ? EventismTheme.primary.withValues(alpha: 0.1)
                : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${day.day}',
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : isToday
                      ? EventismTheme.primary
                      : EventismTheme.textPrimary,
              fontWeight: isToday || isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          if (eventCount > 0)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                eventCount.clamp(0, 3),
                (index) => Container(
                  width: 4,
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : EventismTheme.cta,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
