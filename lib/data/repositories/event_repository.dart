import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/event.dart';
import '../../core/constants.dart';

class EventRepository {
  List<Event>? _cachedEvents;

  Future<List<Event>> loadEvents() async {
    if (_cachedEvents != null) return _cachedEvents!;

    final jsonString = await rootBundle.loadString(AppConstants.eventsJsonPath);
    final List<dynamic> jsonList = json.decode(jsonString);

    _cachedEvents = jsonList
        .map((json) => Event.fromJson(json as Map<String, dynamic>))
        .where((event) => event.status == 'published')
        .toList();

    // Sort by start date (upcoming first)
    _cachedEvents!.sort((a, b) {
      final aDate = a.startDateTime;
      final bDate = b.startDateTime;
      if (aDate == null && bDate == null) return 0;
      if (aDate == null) return 1;
      if (bDate == null) return -1;
      return aDate.compareTo(bDate);
    });

    return _cachedEvents!;
  }

  Future<Event?> getEvent(String id) async {
    final events = await loadEvents();
    return events.where((e) => e.id == id).firstOrNull;
  }

  Future<List<Event>> searchEvents(String query) async {
    final events = await loadEvents();
    if (query.isEmpty) return events;
    return events.where((e) => e.matchesSearch(query)).toList();
  }

  Future<List<Event>> filterEvents({
    String? query,
    List<String>? tags,
    String? city,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    var events = await loadEvents();

    if (query != null && query.isNotEmpty) {
      events = events.where((e) => e.matchesSearch(query)).toList();
    }

    if (tags != null && tags.isNotEmpty) {
      events = events.where((e) => tags.any((tag) => e.hasTag(tag))).toList();
    }

    if (city != null && city.isNotEmpty) {
      events = events
          .where((e) => e.location?.toLowerCase().contains(city.toLowerCase()) ?? false)
          .toList();
    }

    if (startDate != null) {
      events = events.where((e) {
        final eventDate = e.startDateTime;
        if (eventDate == null) return false;
        return eventDate.isAfter(startDate) ||
            eventDate.isAtSameMomentAs(startDate);
      }).toList();
    }

    if (endDate != null) {
      events = events.where((e) {
        final eventDate = e.startDateTime;
        if (eventDate == null) return false;
        return eventDate.isBefore(endDate) ||
            eventDate.isAtSameMomentAs(endDate);
      }).toList();
    }

    return events;
  }

  Future<List<String>> getAllTags() async {
    final events = await loadEvents();
    final tags = <String>{};
    for (final event in events) {
      tags.addAll(event.tags);
    }
    final sortedTags = tags.toList()..sort();
    return sortedTags;
  }

  Future<List<String>> getAllCities() async {
    final events = await loadEvents();
    final cities = <String>{};
    for (final event in events) {
      final city = event.cityName;
      if (city != 'Unknown') {
        cities.add(city);
      }
    }
    final sortedCities = cities.toList()..sort();
    return sortedCities;
  }

  Future<List<Event>> getEventsWithCoordinates() async {
    final events = await loadEvents();
    return events.where((e) => e.hasCoordinates).toList();
  }

  Future<List<Event>> getEventsForDate(DateTime date) async {
    final events = await loadEvents();
    return events.where((e) {
      final eventDate = e.startDateTime;
      if (eventDate == null) return false;
      return eventDate.year == date.year &&
          eventDate.month == date.month &&
          eventDate.day == date.day;
    }).toList();
  }

  Future<List<Event>> getFeaturedEvents({int limit = 6}) async {
    final events = await loadEvents();
    final now = DateTime.now();

    // Get upcoming events with banners
    final upcoming = events
        .where((e) {
          final date = e.startDateTime;
          return date != null && date.isAfter(now) && e.bannerUrl != null;
        })
        .take(limit)
        .toList();

    return upcoming;
  }
}
