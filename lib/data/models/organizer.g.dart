// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organizer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Organizer _$OrganizerFromJson(Map<String, dynamic> json) => Organizer(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      tagline: json['tagline'] as String?,
      description: json['description'] as String?,
      logoUrl: json['logo_url'] as String?,
      bannerUrl: json['banner_url'] as String?,
      eventTypes: (json['event_types'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      eventIds: (json['event_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      location: json['location'] as String?,
      website: json['website'] as String?,
      instagram: json['instagram'] as String?,
      tiktok: json['tiktok'] as String?,
      eventsPerYear: (json['events_per_year'] as num?)?.toInt() ?? 0,
      vendorCount: (json['vendor_count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$OrganizerToJson(Organizer instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'tagline': instance.tagline,
      'description': instance.description,
      'logo_url': instance.logoUrl,
      'banner_url': instance.bannerUrl,
      'event_types': instance.eventTypes,
      'event_ids': instance.eventIds,
      'location': instance.location,
      'website': instance.website,
      'instagram': instance.instagram,
      'tiktok': instance.tiktok,
      'events_per_year': instance.eventsPerYear,
      'vendor_count': instance.vendorCount,
    };
