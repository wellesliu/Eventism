import 'package:flutter/material.dart';

import '../../core/theme.dart';
import 'toast_service.dart';

/// Shows a contact form dialog for reaching out to vendors or organizers.
void showContactDialog(
  BuildContext context, {
  required String recipientName,
  required String recipientType, // 'vendor' or 'organizer'
  String? logoUrl,
}) {
  showDialog(
    context: context,
    builder: (context) => ContactDialog(
      recipientName: recipientName,
      recipientType: recipientType,
      logoUrl: logoUrl,
    ),
  );
}

class ContactDialog extends StatefulWidget {
  final String recipientName;
  final String recipientType;
  final String? logoUrl;

  const ContactDialog({
    super.key,
    required this.recipientName,
    required this.recipientType,
    this.logoUrl,
  });

  @override
  State<ContactDialog> createState() => _ContactDialogState();
}

class _ContactDialogState extends State<ContactDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  String? _selectedInquiryType;
  bool _isSubmitting = false;

  final List<String> _inquiryTypes = [
    'General Inquiry',
    'Booking Request',
    'Collaboration',
    'Pricing Information',
    'Other',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width > 600;

    return Dialog(
      backgroundColor: EventismTheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: isDesktop ? 500 : double.infinity,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.85,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            _buildHeader(context),
            // Form
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Recipient info
                      _buildRecipientInfo(context),
                      const SizedBox(height: 24),
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
                        textInputAction: TextInputAction.next,
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
                      // Inquiry type dropdown
                      DropdownButtonFormField<String>(
                        value: _selectedInquiryType,
                        decoration: const InputDecoration(
                          labelText: 'Inquiry Type',
                          prefixIcon: Icon(Icons.category_outlined),
                        ),
                        items: _inquiryTypes.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => _selectedInquiryType = value);
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select an inquiry type';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Message field
                      TextFormField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          labelText: 'Message',
                          hintText: 'Tell us about your inquiry...',
                          alignLabelWithHint: true,
                        ),
                        maxLines: 4,
                        textInputAction: TextInputAction.done,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a message';
                          }
                          if (value.trim().length < 10) {
                            return 'Message must be at least 10 characters';
                          }
                          return null;
                        },
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
                                'This is a demo. Messages are not actually sent.',
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
                            : const Text('Send Message'),
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
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: EventismTheme.border),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.mail_outline, color: EventismTheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Contact ${widget.recipientType == 'vendor' ? 'Vendor' : 'Organizer'}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
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

  Widget _buildRecipientInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: EventismTheme.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Logo
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: EventismTheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: widget.logoUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      widget.logoUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _buildLogoPlaceholder(),
                    ),
                  )
                : _buildLogoPlaceholder(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.recipientName,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  widget.recipientType == 'vendor' ? 'Vendor' : 'Event Organizer',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: EventismTheme.textMuted,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoPlaceholder() {
    return Center(
      child: Text(
        widget.recipientName.isNotEmpty
            ? widget.recipientName[0].toUpperCase()
            : widget.recipientType == 'vendor' ? 'V' : 'O',
        style: const TextStyle(
          color: EventismTheme.primary,
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
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
      'Message sent to ${widget.recipientName}!',
    );
  }
}
