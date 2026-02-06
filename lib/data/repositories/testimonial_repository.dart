import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/testimonial.dart';

class TestimonialRepository {
  List<Testimonial>? _cachedTestimonials;

  Future<List<Testimonial>> loadTestimonials() async {
    if (_cachedTestimonials != null) return _cachedTestimonials!;

    final jsonString = await rootBundle.loadString('assets/data/testimonials.json');
    final List<dynamic> jsonList = json.decode(jsonString);

    _cachedTestimonials = jsonList
        .map((json) => Testimonial.fromJson(json as Map<String, dynamic>))
        .toList();

    return _cachedTestimonials!;
  }

  Future<List<Testimonial>> getTestimonialsByType(String type) async {
    final testimonials = await loadTestimonials();
    return testimonials.where((t) => t.type == type).toList();
  }

  Future<List<Testimonial>> getVendorTestimonials() async {
    return getTestimonialsByType('vendor');
  }

  Future<List<Testimonial>> getOrganizerTestimonials() async {
    return getTestimonialsByType('organizer');
  }

  Future<List<Testimonial>> getAttendeeTestimonials() async {
    return getTestimonialsByType('attendee');
  }
}
