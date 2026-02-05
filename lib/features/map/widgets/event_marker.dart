import 'package:flutter/material.dart';

import '../../../core/theme.dart';
import '../../../data/models/event.dart';

class EventMarker extends StatelessWidget {
  final Event event;
  final bool isSelected;
  final VoidCallback onTap;

  const EventMarker({
    super.key,
    required this.event,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: isSelected ? 44 : 36,
        height: isSelected ? 44 : 36,
        decoration: BoxDecoration(
          color: isSelected ? EventsiaTheme.cta : EventsiaTheme.primary,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(
          Icons.event,
          color: Colors.white,
          size: 18,
        ),
      ),
    );
  }
}
