import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme.dart';
import 'toast_service.dart';

/// Shows a share bottom sheet with multiple sharing options.
void showShareSheet(
  BuildContext context, {
  required String title,
  required String url,
  String? description,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => ShareSheet(
      title: title,
      url: url,
      description: description,
    ),
  );
}

class ShareSheet extends StatelessWidget {
  final String title;
  final String url;
  final String? description;

  const ShareSheet({
    super.key,
    required this.title,
    required this.url,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: EventismTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: EventismTheme.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'Share',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: EventismTheme.textSecondary,
                        ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Share options
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ShareOption(
                    icon: Icons.copy,
                    label: 'Copy Link',
                    color: EventismTheme.textPrimary,
                    onTap: () => _copyLink(context),
                  ),
                  _ShareOption(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    color: const Color(0xFFEA4335),
                    onTap: () => _shareViaEmail(context),
                  ),
                  _ShareOption(
                    icon: Icons.messenger_outline,
                    label: 'Facebook',
                    color: const Color(0xFF1877F2),
                    onTap: () => _shareToFacebook(context),
                  ),
                  _ShareOption(
                    icon: Icons.alternate_email,
                    label: 'X',
                    color: Colors.black,
                    onTap: () => _shareToTwitter(context),
                  ),
                ],
              ),
            ),
            // URL preview
            Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: EventismTheme.background,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.link,
                    size: 18,
                    color: EventismTheme.textMuted,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      url,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: EventismTheme.textSecondary,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    onPressed: () => _copyLink(context),
                    icon: const Icon(Icons.copy, size: 18),
                    color: EventismTheme.primary,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _copyLink(BuildContext context) {
    Clipboard.setData(ClipboardData(text: url));
    Navigator.pop(context);
    ToastService.success(context, 'Link copied to clipboard');
  }

  void _shareViaEmail(BuildContext context) async {
    final subject = Uri.encodeComponent(title);
    final body = Uri.encodeComponent(
      description != null ? '$description\n\n$url' : url,
    );
    final emailUrl = Uri.parse('mailto:?subject=$subject&body=$body');

    if (await canLaunchUrl(emailUrl)) {
      await launchUrl(emailUrl);
    }
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  void _shareToFacebook(BuildContext context) async {
    final facebookUrl = Uri.parse(
      'https://www.facebook.com/sharer/sharer.php?u=${Uri.encodeComponent(url)}',
    );

    if (await canLaunchUrl(facebookUrl)) {
      await launchUrl(facebookUrl, mode: LaunchMode.externalApplication);
    }
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  void _shareToTwitter(BuildContext context) async {
    final text = Uri.encodeComponent('$title\n$url');
    final twitterUrl = Uri.parse('https://twitter.com/intent/tweet?text=$text');

    if (await canLaunchUrl(twitterUrl)) {
      await launchUrl(twitterUrl, mode: LaunchMode.externalApplication);
    }
    if (context.mounted) {
      Navigator.pop(context);
    }
  }
}

class _ShareOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ShareOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }
}
