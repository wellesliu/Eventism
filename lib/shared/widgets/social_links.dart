import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme.dart';

class SocialLinks extends StatelessWidget {
  final String? website;
  final String? instagram;
  final String? tiktok;
  final double iconSize;
  final Color? iconColor;
  final double spacing;

  const SocialLinks({
    super.key,
    this.website,
    this.instagram,
    this.tiktok,
    this.iconSize = 20,
    this.iconColor,
    this.spacing = 8,
  });

  bool get hasLinks => website != null || instagram != null || tiktok != null;

  @override
  Widget build(BuildContext context) {
    if (!hasLinks) return const SizedBox.shrink();

    final color = iconColor ?? EventismTheme.textSecondary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (website != null) ...[
          _SocialIconButton(
            icon: Icons.language,
            url: website!,
            tooltip: 'Website',
            size: iconSize,
            color: color,
          ),
          if (instagram != null || tiktok != null) SizedBox(width: spacing),
        ],
        if (instagram != null) ...[
          _SocialIconButton(
            icon: Icons.camera_alt_outlined,
            url: 'https://instagram.com/$instagram',
            tooltip: '@$instagram',
            size: iconSize,
            color: color,
          ),
          if (tiktok != null) SizedBox(width: spacing),
        ],
        if (tiktok != null)
          _SocialIconButton(
            icon: Icons.music_note_outlined,
            url: 'https://tiktok.com/@$tiktok',
            tooltip: '@$tiktok',
            size: iconSize,
            color: color,
          ),
      ],
    );
  }
}

class _SocialIconButton extends StatelessWidget {
  final IconData icon;
  final String url;
  final String tooltip;
  final double size;
  final Color color;

  const _SocialIconButton({
    required this.icon,
    required this.url,
    required this.tooltip,
    required this.size,
    required this.color,
  });

  Future<void> _launchUrl() async {
    final uri = Uri.parse(url.startsWith('http') ? url : 'https://$url');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: _launchUrl,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(
            icon,
            size: size,
            color: color,
          ),
        ),
      ),
    );
  }
}

class SocialLinksRow extends StatelessWidget {
  final String? website;
  final String? instagram;
  final String? tiktok;

  const SocialLinksRow({
    super.key,
    this.website,
    this.instagram,
    this.tiktok,
  });

  @override
  Widget build(BuildContext context) {
    final links = <Widget>[];

    if (website != null) {
      links.add(_SocialChip(
        icon: Icons.language,
        label: 'Website',
        url: website!,
      ));
    }
    if (instagram != null) {
      links.add(_SocialChip(
        icon: Icons.camera_alt_outlined,
        label: '@$instagram',
        url: 'https://instagram.com/$instagram',
      ));
    }
    if (tiktok != null) {
      links.add(_SocialChip(
        icon: Icons.music_note_outlined,
        label: '@$tiktok',
        url: 'https://tiktok.com/@$tiktok',
      ));
    }

    if (links.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: links,
    );
  }
}

class _SocialChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String url;

  const _SocialChip({
    required this.icon,
    required this.label,
    required this.url,
  });

  Future<void> _launchUrl() async {
    final uri = Uri.parse(url.startsWith('http') ? url : 'https://$url');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(icon, size: 16),
      label: Text(label),
      onPressed: _launchUrl,
    );
  }
}
