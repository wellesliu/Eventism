import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/organizer.dart';

class OrganizerRepository {
  List<Organizer>? _cachedOrganizers;

  Future<List<Organizer>> loadOrganizers() async {
    if (_cachedOrganizers != null) return _cachedOrganizers!;

    final jsonString = await rootBundle.loadString('assets/data/organizers.json');
    final List<dynamic> jsonList = json.decode(jsonString);

    _cachedOrganizers = jsonList
        .map((json) => Organizer.fromJson(json as Map<String, dynamic>))
        .toList();

    // Sort by name
    _cachedOrganizers!.sort((a, b) => a.name.compareTo(b.name));

    return _cachedOrganizers!;
  }

  Future<Organizer?> getOrganizer(String id) async {
    final organizers = await loadOrganizers();
    return organizers.where((o) => o.id == id).firstOrNull;
  }

  Future<Organizer?> getOrganizerBySlug(String slug) async {
    final organizers = await loadOrganizers();
    return organizers.where((o) => o.slug == slug).firstOrNull;
  }

  Future<List<Organizer>> searchOrganizers(String query) async {
    final organizers = await loadOrganizers();
    if (query.isEmpty) return organizers;
    return organizers.where((o) => o.matchesSearch(query)).toList();
  }

  Future<List<Organizer>> filterOrganizers({
    String? query,
    List<String>? eventTypes,
    String? location,
  }) async {
    var organizers = await loadOrganizers();

    if (query != null && query.isNotEmpty) {
      organizers = organizers.where((o) => o.matchesSearch(query)).toList();
    }

    if (eventTypes != null && eventTypes.isNotEmpty) {
      organizers = organizers
          .where((o) => eventTypes.any((type) => o.hasEventType(type)))
          .toList();
    }

    if (location != null && location.isNotEmpty) {
      organizers = organizers
          .where((o) =>
              o.location?.toLowerCase().contains(location.toLowerCase()) ??
              false)
          .toList();
    }

    return organizers;
  }

  Future<List<String>> getAllEventTypes() async {
    final organizers = await loadOrganizers();
    final eventTypes = <String>{};
    for (final organizer in organizers) {
      eventTypes.addAll(organizer.eventTypes);
    }
    final sortedTypes = eventTypes.toList()..sort();
    return sortedTypes;
  }

  Future<List<String>> getAllLocations() async {
    final organizers = await loadOrganizers();
    final locations = <String>{};
    for (final organizer in organizers) {
      if (organizer.location != null && organizer.location!.isNotEmpty) {
        locations.add(organizer.location!);
      }
    }
    final sortedLocations = locations.toList()..sort();
    return sortedLocations;
  }
}
