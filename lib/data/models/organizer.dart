import 'package:json_annotation/json_annotation.dart';

part 'organizer.g.dart';

@JsonSerializable()
class Organizer {
  final String id;
  final String name;
  final String slug;
  final String? tagline;
  final String? description;
  @JsonKey(name: 'logo_url')
  final String? logoUrl;
  @JsonKey(name: 'banner_url')
  final String? bannerUrl;
  @JsonKey(name: 'event_types')
  final List<String> eventTypes;
  @JsonKey(name: 'event_ids')
  final List<String> eventIds;
  final String? location;
  final String? website;
  final String? instagram;
  final String? tiktok;
  @JsonKey(name: 'events_per_year')
  final int eventsPerYear;
  @JsonKey(name: 'vendor_count')
  final int vendorCount;

  const Organizer({
    required this.id,
    required this.name,
    required this.slug,
    this.tagline,
    this.description,
    this.logoUrl,
    this.bannerUrl,
    this.eventTypes = const [],
    this.eventIds = const [],
    this.location,
    this.website,
    this.instagram,
    this.tiktok,
    this.eventsPerYear = 0,
    this.vendorCount = 0,
  });

  factory Organizer.fromJson(Map<String, dynamic> json) => _$OrganizerFromJson(json);
  Map<String, dynamic> toJson() => _$OrganizerToJson(this);

  bool get hasSocialLinks => website != null || instagram != null || tiktok != null;

  bool matchesSearch(String query) {
    final lower = query.toLowerCase();
    return name.toLowerCase().contains(lower) ||
        (tagline?.toLowerCase().contains(lower) ?? false) ||
        (description?.toLowerCase().contains(lower) ?? false) ||
        eventTypes.any((type) => type.toLowerCase().contains(lower));
  }

  bool hasEventType(String type) {
    return eventTypes.any((t) => t.toLowerCase() == type.toLowerCase());
  }
}
