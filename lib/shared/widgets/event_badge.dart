import 'package:flutter/material.dart';

enum EventBadgeType {
  featured,
  popular,
  vendorsWelcome,
  free,
  soldOut,
}

class EventBadge extends StatelessWidget {
  final EventBadgeType type;
  final bool small;

  const EventBadge({
    super.key,
    required this.type,
    this.small = false,
  });

  factory EventBadge.featured({bool small = false}) =>
      EventBadge(type: EventBadgeType.featured, small: small);

  factory EventBadge.popular({bool small = false}) =>
      EventBadge(type: EventBadgeType.popular, small: small);

  factory EventBadge.vendorsWelcome({bool small = false}) =>
      EventBadge(type: EventBadgeType.vendorsWelcome, small: small);

  factory EventBadge.free({bool small = false}) =>
      EventBadge(type: EventBadgeType.free, small: small);

  factory EventBadge.soldOut({bool small = false}) =>
      EventBadge(type: EventBadgeType.soldOut, small: small);

  @override
  Widget build(BuildContext context) {
    final config = _getBadgeConfig();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 6 : 8,
        vertical: small ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(small ? 4 : 6),
        border: Border.all(
          color: config.borderColor,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (config.icon != null) ...[
            Icon(
              config.icon,
              size: small ? 10 : 12,
              color: config.textColor,
            ),
            SizedBox(width: small ? 2 : 4),
          ],
          Text(
            config.label,
            style: TextStyle(
              fontSize: small ? 10 : 11,
              fontWeight: FontWeight.w600,
              color: config.textColor,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  _BadgeConfig _getBadgeConfig() {
    switch (type) {
      case EventBadgeType.featured:
        return _BadgeConfig(
          label: 'Featured',
          icon: Icons.star,
          backgroundColor: const Color(0xFFFEF3C7),
          borderColor: const Color(0xFFFCD34D),
          textColor: const Color(0xFFB45309),
        );
      case EventBadgeType.popular:
        return _BadgeConfig(
          label: 'Popular',
          icon: Icons.local_fire_department,
          backgroundColor: const Color(0xFFFFE4E6),
          borderColor: const Color(0xFFFDA4AF),
          textColor: const Color(0xFFBE123C),
        );
      case EventBadgeType.vendorsWelcome:
        return _BadgeConfig(
          label: 'Vendors Welcome',
          icon: Icons.storefront,
          backgroundColor: const Color(0xFFD1FAE5),
          borderColor: const Color(0xFF6EE7B7),
          textColor: const Color(0xFF047857),
        );
      case EventBadgeType.free:
        return _BadgeConfig(
          label: 'Free',
          icon: null,
          backgroundColor: const Color(0xFFDBEAFE),
          borderColor: const Color(0xFF93C5FD),
          textColor: const Color(0xFF1D4ED8),
        );
      case EventBadgeType.soldOut:
        return _BadgeConfig(
          label: 'Sold Out',
          icon: null,
          backgroundColor: const Color(0xFFF3F4F6),
          borderColor: const Color(0xFFD1D5DB),
          textColor: const Color(0xFF6B7280),
        );
    }
  }
}

class _BadgeConfig {
  final String label;
  final IconData? icon;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;

  const _BadgeConfig({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
  });
}

class BadgeRow extends StatelessWidget {
  final bool isFeatured;
  final bool isPopular;
  final bool acceptsVendors;
  final bool isFree;
  final bool isSoldOut;
  final bool small;

  const BadgeRow({
    super.key,
    this.isFeatured = false,
    this.isPopular = false,
    this.acceptsVendors = false,
    this.isFree = false,
    this.isSoldOut = false,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    final badges = <Widget>[];

    if (isFeatured) badges.add(EventBadge.featured(small: small));
    if (isPopular) badges.add(EventBadge.popular(small: small));
    if (acceptsVendors) badges.add(EventBadge.vendorsWelcome(small: small));
    if (isFree) badges.add(EventBadge.free(small: small));
    if (isSoldOut) badges.add(EventBadge.soldOut(small: small));

    if (badges.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: badges,
    );
  }
}
