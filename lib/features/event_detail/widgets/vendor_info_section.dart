import 'package:flutter/material.dart';

import '../../../core/theme.dart';
import '../../../data/models/event.dart';

class VendorInfoSection extends StatelessWidget {
  final Event event;

  const VendorInfoSection({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    if (!event.acceptsVendors) return const SizedBox.shrink();

    final vendorInfo = event.vendorInfo;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: EventismTheme.success.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: EventismTheme.success.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: EventismTheme.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.storefront,
                  color: EventismTheme.success,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vendor Opportunities',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: EventismTheme.success,
                          ),
                    ),
                    Text(
                      'Applications are open for this event',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Stall fee
          if (vendorInfo?.stallFee != null) ...[
            _buildInfoRow(
              context,
              icon: Icons.attach_money,
              label: 'Stall Fee',
              value: vendorInfo!.stallFee!,
            ),
            const SizedBox(height: 12),
          ],

          // Application deadline
          if (event.vendorApplicationDeadline != null) ...[
            _buildInfoRow(
              context,
              icon: Icons.schedule,
              label: 'Application Deadline',
              value: event.vendorApplicationDeadline!,
            ),
            const SizedBox(height: 12),
          ],

          // Expected attendance
          if (event.expectedAttendance != null) ...[
            _buildInfoRow(
              context,
              icon: Icons.people,
              label: 'Expected Attendance',
              value: '${event.expectedAttendance} attendees',
            ),
            const SizedBox(height: 12),
          ],

          // What's included
          if (vendorInfo != null && vendorInfo.includes.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'What\'s Included',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: vendorInfo.includes.map((item) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: EventismTheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: EventismTheme.border),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 16,
                        color: EventismTheme.success,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        item,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],

          // Requirements
          if (vendorInfo != null && vendorInfo.requirements.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'Requirements',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            ...vendorInfo.requirements.map((req) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 16,
                      color: EventismTheme.textMuted,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        req,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],

          const SizedBox(height: 16),

          // Apply button
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {
                _showApplicationDialog(context);
              },
              icon: const Icon(Icons.send),
              label: const Text('Apply as Vendor'),
              style: FilledButton.styleFrom(
                backgroundColor: EventismTheme.success,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: EventismTheme.textMuted),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: EventismTheme.textMuted,
              ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ],
    );
  }

  void _showApplicationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Apply as Vendor'),
        content: const Text(
          'Vendor application functionality will be available soon. '
          'This is a demo version of Eventism.',
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
