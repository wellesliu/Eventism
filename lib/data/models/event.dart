import 'package:json_annotation/json_annotation.dart';

part 'event.g.dart';

@JsonSerializable()
class Event {
  final String id;
  @JsonKey(name: 'organiser_id')
  final String? organiserId;
  final String name;
  final String? description;
  @JsonKey(name: 'banner_url')
  final String? bannerUrl;
  final String? location;
  final List<String> tags;
  @JsonKey(name: 'start_date')
  final String? startDate;
  @JsonKey(name: 'end_date')
  final String? endDate;
  @JsonKey(name: 'accepts_vendors')
  final bool acceptsVendors;
  @JsonKey(name: 'vendor_application_deadline')
  final String? vendorApplicationDeadline;
  final String status;
  final double? latitude;
  final double? longitude;

  const Event({
    required this.id,
    this.organiserId,
    required this.name,
    this.description,
    this.bannerUrl,
    this.location,
    this.tags = const [],
    this.startDate,
    this.endDate,
    this.acceptsVendors = false,
    this.vendorApplicationDeadline,
    this.status = 'published',
    this.latitude,
    this.longitude,
  });

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
  Map<String, dynamic> toJson() => _$EventToJson(this);

  DateTime? get startDateTime => startDate != null ? DateTime.tryParse(startDate!) : null;
  DateTime? get endDateTime => endDate != null ? DateTime.tryParse(endDate!) : null;

  bool get hasCoordinates => latitude != null && longitude != null;

  String get locationShort {
    if (location == null || location!.isEmpty) return 'Unknown location';
    final parts = location!.split(',');
    if (parts.length >= 2) {
      return '${parts[0].trim()}, ${parts[1].trim()}';
    }
    return parts[0].trim();
  }

  String get cityName {
    if (location == null || location!.isEmpty) return 'Unknown';
    final parts = location!.split(',');
    for (final part in parts) {
      final trimmed = part.trim();
      if (_isCity(trimmed)) return trimmed;
    }
    return parts.length > 1 ? parts[1].trim() : parts[0].trim();
  }

  bool _isCity(String text) {
    final cities = [
      'Sydney',
      'Melbourne',
      'Brisbane',
      'Perth',
      'Adelaide',
      'Gold Coast',
      'Canberra',
      'Hobart',
      'Darwin',
      'Newcastle',
      'Wollongong',
      'Geelong',
      'Townsville',
      'Cairns',
      'Toowoomba',
    ];
    return cities.any((city) => text.contains(city));
  }

  bool matchesSearch(String query) {
    final lower = query.toLowerCase();
    return name.toLowerCase().contains(lower) ||
        (description?.toLowerCase().contains(lower) ?? false) ||
        (location?.toLowerCase().contains(lower) ?? false) ||
        tags.any((tag) => tag.toLowerCase().contains(lower));
  }

  bool hasTag(String tag) {
    return tags.any((t) => t.toLowerCase() == tag.toLowerCase());
  }
}
