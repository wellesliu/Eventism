// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Vendor _$VendorFromJson(Map<String, dynamic> json) => Vendor(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      tagline: json['tagline'] as String?,
      description: json['description'] as String?,
      logoUrl: json['logo_url'] as String?,
      coverUrl: json['cover_url'] as String?,
      galleryUrls: (json['gallery_urls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      categories: (json['categories'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      location: json['location'] as String?,
      website: json['website'] as String?,
      instagram: json['instagram'] as String?,
      tiktok: json['tiktok'] as String?,
      pastEventIds: (json['past_event_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isAvailable: json['is_available'] as bool? ?? true,
    );

Map<String, dynamic> _$VendorToJson(Vendor instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'tagline': instance.tagline,
      'description': instance.description,
      'logo_url': instance.logoUrl,
      'cover_url': instance.coverUrl,
      'gallery_urls': instance.galleryUrls,
      'categories': instance.categories,
      'location': instance.location,
      'website': instance.website,
      'instagram': instance.instagram,
      'tiktok': instance.tiktok,
      'past_event_ids': instance.pastEventIds,
      'is_available': instance.isAvailable,
    };
