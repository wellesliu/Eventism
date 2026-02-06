import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../data/models/event.dart';
import 'toast_service.dart';

/// Shows an event interest/registration dialog.
void showEventInterestDialog(BuildContext context, Event event) {
  showDialog(
    context: context,
    builder: (context) => EventInterestDialog(event: event),
  );
}

class EventInterestDialog extends StatefulWidget {
  final Event event;

  const EventInterestDialog({super.key, required this.event});

  @override
  State<EventInterestDialog> createState() => _EventInterestDialogState();
}

class _EventInterestDialogState extends State<EventInterestDialog> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  bool _receiveUpdates = true;
  bool _isSubmitting = false;
  int _ticketCount = 1;

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width > 600;
    final isFreeEvent = widget.event.priceRange == 'Free';

    return Dialog(
      backgroundColor: EventismTheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: isDesktop ? 480 : double.infinity,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.85,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with event info
            _buildHeader(context),
            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Event summary
                      _buildEventSummary(context),
                      const SizedBox(height: 24),
                      // Ticket selection (if not free)
                      if (!isFreeEvent) ...[
                        _buildTicketSelector(context),
                        const SizedBox(height: 24),
                      ],
                      // Name field
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Your Name',
                          hintText: 'Enter your full name',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Email field
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email Address',
                          hintText: 'your@email.com',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@') || !value.contains('.')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Updates checkbox
                      InkWell(
                        onTap: () {
                          setState(() => _receiveUpdates = !_receiveUpdates);
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              Checkbox(
                                value: _receiveUpdates,
                                onChanged: (value) {
                                  setState(() => _receiveUpdates = value ?? true);
                                },
                              ),
                              Expanded(
                                child: Text(
                                  'Receive event updates and reminders',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Demo notice
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: EventismTheme.warning.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: EventismTheme.warning.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 20,
                              color: EventismTheme.warning,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'This is a demo. No actual registration will occur.',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: EventismTheme.textSecondary,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Submit button
                      FilledButton(
                        onPressed: _isSubmitting ? null : _handleSubmit,
                        style: FilledButton.styleFrom(
                          backgroundColor: EventismTheme.cta,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: _isSubmitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(isFreeEvent ? 'Register Interest' : 'Continue to Payment'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: EventismTheme.cta.withValues(alpha: 0.1),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: EventismTheme.cta,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.confirmation_number,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.event.priceRange == 'Free' ? 'Register Interest' : 'Get Tickets',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  widget.event.name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: EventismTheme.textSecondary,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'Date TBA';
    final date = DateTime.tryParse(dateStr);
    if (date == null) return dateStr;

    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return '${weekdays[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Widget _buildEventSummary(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: EventismTheme.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Date
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: EventismTheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: EventismTheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _formatDate(widget.event.startDate),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
          if (widget.event.location != null) ...[
            const SizedBox(height: 12),
            // Location
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: EventismTheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.location_on,
                    size: 20,
                    color: EventismTheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.event.location!,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
          // Price
          if (widget.event.priceRange != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: widget.event.priceRange == 'Free'
                        ? EventismTheme.success.withValues(alpha: 0.1)
                        : EventismTheme.cta.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    widget.event.priceRange == 'Free'
                        ? Icons.celebration
                        : Icons.confirmation_number,
                    size: 20,
                    color: widget.event.priceRange == 'Free'
                        ? EventismTheme.success
                        : EventismTheme.cta,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  widget.event.priceRange!,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: widget.event.priceRange == 'Free'
                            ? EventismTheme.success
                            : EventismTheme.textPrimary,
                      ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTicketSelector(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: EventismTheme.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Number of Tickets',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  'Select how many tickets you need',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: EventismTheme.textMuted,
                      ),
                ),
              ],
            ),
          ),
          // Quantity selector
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: EventismTheme.border),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: _ticketCount > 1
                      ? () => setState(() => _ticketCount--)
                      : null,
                  icon: const Icon(Icons.remove, size: 20),
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                ),
                Container(
                  width: 40,
                  alignment: Alignment.center,
                  child: Text(
                    '$_ticketCount',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                IconButton(
                  onPressed: _ticketCount < 10
                      ? () => setState(() => _ticketCount++)
                      : null,
                  icon: const Icon(Icons.add, size: 20),
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSubmitting = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    Navigator.pop(context);
    ToastService.success(
      context,
      widget.event.priceRange == 'Free'
          ? 'You\'re registered for ${widget.event.name}!'
          : 'Tickets reserved! Check your email for confirmation.',
    );
  }
}
