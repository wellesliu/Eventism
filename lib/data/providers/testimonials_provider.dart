import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/testimonial.dart';
import '../repositories/testimonial_repository.dart';

final testimonialRepositoryProvider = Provider<TestimonialRepository>((ref) {
  return TestimonialRepository();
});

final testimonialsProvider = FutureProvider<List<Testimonial>>((ref) async {
  final repository = ref.watch(testimonialRepositoryProvider);
  return repository.loadTestimonials();
});

final vendorTestimonialsProvider = FutureProvider<List<Testimonial>>((ref) async {
  final repository = ref.watch(testimonialRepositoryProvider);
  return repository.getVendorTestimonials();
});

final organizerTestimonialsProvider = FutureProvider<List<Testimonial>>((ref) async {
  final repository = ref.watch(testimonialRepositoryProvider);
  return repository.getOrganizerTestimonials();
});

final attendeeTestimonialsProvider = FutureProvider<List<Testimonial>>((ref) async {
  final repository = ref.watch(testimonialRepositoryProvider);
  return repository.getAttendeeTestimonials();
});
