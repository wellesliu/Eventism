import 'package:flutter/material.dart';

import '../../../core/theme.dart';
import '../../../data/models/event.dart';

class CtaButtons extends StatelessWidget {
  final Event event;

  const CtaButtons({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Get Tickets button
            FilledButton.icon(
              onPressed: () {
                _showComingSoonDialog(context, 'Get Tickets');
              },
              icon: const Icon(Icons.confirmation_number),
              label: const Text('Get Tickets'),
              style: FilledButton.styleFrom(
                backgroundColor: EventsiaTheme.cta,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 12),

            // Create Event button
            OutlinedButton.icon(
              onPressed: () {
                _showComingSoonDialog(context, 'Create Event');
              },
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('Create Event'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),

            // Apply as Vendor button (if accepts vendors)
            if (event.acceptsVendors) ...[
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () {
                  _showComingSoonDialog(context, 'Vendor Application');
                },
                icon: const Icon(Icons.store),
                label: const Text('Apply as Vendor'),
                style: FilledButton.styleFrom(
                  backgroundColor: EventsiaTheme.success,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],

            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 16),

            // Share and save buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _showComingSoonDialog(context, 'Share');
                    },
                    icon: const Icon(Icons.share, size: 20),
                    label: const Text('Share'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _showComingSoonDialog(context, 'Save');
                    },
                    icon: const Icon(Icons.bookmark_border, size: 20),
                    label: const Text('Save'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Organizer info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: EventsiaTheme.background,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: EventsiaTheme.primary.withValues(alpha: 0.1),
                    child: const Icon(
                      Icons.business,
                      color: EventsiaTheme.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Organized by',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: EventsiaTheme.textMuted,
                              ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Event Organizer',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _showComingSoonDialog(context, 'Contact');
                    },
                    child: const Text('Contact'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoonDialog(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Coming Soon'),
        content: Text(
          '$feature functionality will be available soon. '
          'This is a demo version of Eventsia.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
