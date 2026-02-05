import 'package:flutter/material.dart';

import '../../../core/theme.dart';
import '../../../data/models/event.dart';

class EventHeader extends StatelessWidget {
  final Event event;

  const EventHeader({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Banner image
        if (event.bannerUrl != null)
          Image.network(
            event.bannerUrl!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _buildPlaceholder(),
          )
        else
          _buildPlaceholder(),
        // Gradient overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withValues(alpha: 0.7),
              ],
            ),
          ),
        ),
        // Title
        Positioned(
          left: 16,
          right: 16,
          bottom: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tags
              if (event.tags.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: event.tags.take(3).map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              const SizedBox(height: 8),
              // Event name
              Text(
                event.name,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            EventsiaTheme.primary,
            EventsiaTheme.primaryDark,
          ],
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.event,
          size: 80,
          color: Colors.white24,
        ),
      ),
    );
  }
}
