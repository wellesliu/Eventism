import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/organizer.dart';
import '../repositories/organizer_repository.dart';

final organizerRepositoryProvider = Provider<OrganizerRepository>((ref) {
  return OrganizerRepository();
});

final organizersProvider = FutureProvider<List<Organizer>>((ref) async {
  final repository = ref.watch(organizerRepositoryProvider);
  return repository.loadOrganizers();
});

final organizerByIdProvider = FutureProvider.family<Organizer?, String>((ref, id) async {
  final repository = ref.watch(organizerRepositoryProvider);
  return repository.getOrganizer(id);
});

final organizerBySlugProvider = FutureProvider.family<Organizer?, String>((ref, slug) async {
  final repository = ref.watch(organizerRepositoryProvider);
  return repository.getOrganizerBySlug(slug);
});

final organizerEventTypesProvider = FutureProvider<List<String>>((ref) async {
  final repository = ref.watch(organizerRepositoryProvider);
  return repository.getAllEventTypes();
});

final organizerLocationsProvider = FutureProvider<List<String>>((ref) async {
  final repository = ref.watch(organizerRepositoryProvider);
  return repository.getAllLocations();
});
