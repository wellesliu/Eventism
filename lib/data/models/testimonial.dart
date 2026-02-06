import 'package:json_annotation/json_annotation.dart';

part 'testimonial.g.dart';

enum TestimonialType { vendor, organizer, attendee }

@JsonSerializable()
class Testimonial {
  final String id;
  final String quote;
  @JsonKey(name: 'author_name')
  final String authorName;
  @JsonKey(name: 'author_role')
  final String authorRole;
  @JsonKey(name: 'author_image_url')
  final String? authorImageUrl;
  final String type; // 'vendor', 'organizer', 'attendee'

  const Testimonial({
    required this.id,
    required this.quote,
    required this.authorName,
    required this.authorRole,
    this.authorImageUrl,
    required this.type,
  });

  factory Testimonial.fromJson(Map<String, dynamic> json) => _$TestimonialFromJson(json);
  Map<String, dynamic> toJson() => _$TestimonialToJson(this);

  bool get isVendor => type == 'vendor';
  bool get isOrganizer => type == 'organizer';
  bool get isAttendee => type == 'attendee';
}
