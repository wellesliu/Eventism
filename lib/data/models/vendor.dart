import 'package:json_annotation/json_annotation.dart';

part 'vendor.g.dart';

@JsonSerializable()
class Vendor {
  final String id;
  final String name;
  final String slug;
  final String? tagline;
  final String? description;
  @JsonKey(name: 'logo_url')
  final String? logoUrl;
  @JsonKey(name: 'cover_url')
  final String? coverUrl;
  @JsonKey(name: 'gallery_urls')
  final List<String> galleryUrls;
  final List<String> categories;
  final String? location;
  final String? website;
  final String? instagram;
  final String? tiktok;
  @JsonKey(name: 'past_event_ids')
  final List<String> pastEventIds;
  @JsonKey(name: 'is_available')
  final bool isAvailable;

  const Vendor({
    required this.id,
    required this.name,
    required this.slug,
    this.tagline,
    this.description,
    this.logoUrl,
    this.coverUrl,
    this.galleryUrls = const [],
    this.categories = const [],
    this.location,
    this.website,
    this.instagram,
    this.tiktok,
    this.pastEventIds = const [],
    this.isAvailable = true,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) => _$VendorFromJson(json);
  Map<String, dynamic> toJson() => _$VendorToJson(this);

  bool get hasSocialLinks => website != null || instagram != null || tiktok != null;

  bool matchesSearch(String query) {
    final lower = query.toLowerCase();
    return name.toLowerCase().contains(lower) ||
        (tagline?.toLowerCase().contains(lower) ?? false) ||
        (description?.toLowerCase().contains(lower) ?? false) ||
        categories.any((cat) => cat.toLowerCase().contains(lower));
  }

  bool hasCategory(String category) {
    return categories.any((c) => c.toLowerCase() == category.toLowerCase());
  }
}
