import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/event.dart';
import '../repositories/event_repository.dart';

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  return EventRepository();
});

final eventsProvider = FutureProvider<List<Event>>((ref) async {
  final repository = ref.watch(eventRepositoryProvider);
  return repository.loadEvents();
});

final allTagsProvider = FutureProvider<List<String>>((ref) async {
  final repository = ref.watch(eventRepositoryProvider);
  return repository.getAllTags();
});

final allCitiesProvider = FutureProvider<List<String>>((ref) async {
  final repository = ref.watch(eventRepositoryProvider);
  return repository.getAllCities();
});

final eventByIdProvider = FutureProvider.family<Event?, String>((ref, id) async {
  final repository = ref.watch(eventRepositoryProvider);
  return repository.getEvent(id);
});

final featuredEventsProvider = FutureProvider<List<Event>>((ref) async {
  final repository = ref.watch(eventRepositoryProvider);
  return repository.getFeaturedEvents();
});

final eventsWithCoordinatesProvider = FutureProvider<List<Event>>((ref) async {
  final repository = ref.watch(eventRepositoryProvider);
  return repository.getEventsWithCoordinates();
});

final eventsForDateProvider = FutureProvider.family<List<Event>, DateTime>((ref, date) async {
  final repository = ref.watch(eventRepositoryProvider);
  return repository.getEventsForDate(date);
});
