// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VendorInfo _$VendorInfoFromJson(Map<String, dynamic> json) => VendorInfo(
      stallFee: json['stall_fee'] as String?,
      includes: (json['includes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      requirements: (json['requirements'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$VendorInfoToJson(VendorInfo instance) =>
    <String, dynamic>{
      'stall_fee': instance.stallFee,
      'includes': instance.includes,
      'requirements': instance.requirements,
    };

Event _$EventFromJson(Map<String, dynamic> json) => Event(
      id: json['id'] as String,
      organiserId: json['organiser_id'] as String?,
      name: json['name'] as String,
      description: json['description'] as String?,
      bannerUrl: json['banner_url'] as String?,
      location: json['location'] as String?,
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      startDate: json['start_date'] as String?,
      endDate: json['end_date'] as String?,
      acceptsVendors: json['accepts_vendors'] as bool? ?? false,
      vendorApplicationDeadline: json['vendor_application_deadline'] as String?,
      status: json['status'] as String? ?? 'published',
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      expectedAttendance: (json['expected_attendance'] as num?)?.toInt(),
      priceRange: json['price_range'] as String?,
      interestCount: (json['interest_count'] as num?)?.toInt() ?? 0,
      vendorInfo: json['vendor_info'] == null
          ? null
          : VendorInfo.fromJson(json['vendor_info'] as Map<String, dynamic>),
      isFeatured: json['is_featured'] as bool? ?? false,
    );

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'id': instance.id,
      'organiser_id': instance.organiserId,
      'name': instance.name,
      'description': instance.description,
      'banner_url': instance.bannerUrl,
      'location': instance.location,
      'tags': instance.tags,
      'start_date': instance.startDate,
      'end_date': instance.endDate,
      'accepts_vendors': instance.acceptsVendors,
      'vendor_application_deadline': instance.vendorApplicationDeadline,
      'status': instance.status,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'expected_attendance': instance.expectedAttendance,
      'price_range': instance.priceRange,
      'interest_count': instance.interestCount,
      'vendor_info': instance.vendorInfo?.toJson(),
      'is_featured': instance.isFeatured,
    };
