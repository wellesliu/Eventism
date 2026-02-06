// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'testimonial.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Testimonial _$TestimonialFromJson(Map<String, dynamic> json) => Testimonial(
      id: json['id'] as String,
      quote: json['quote'] as String,
      authorName: json['author_name'] as String,
      authorRole: json['author_role'] as String,
      authorImageUrl: json['author_image_url'] as String?,
      type: json['type'] as String,
    );

Map<String, dynamic> _$TestimonialToJson(Testimonial instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quote': instance.quote,
      'author_name': instance.authorName,
      'author_role': instance.authorRole,
      'author_image_url': instance.authorImageUrl,
      'type': instance.type,
    };
