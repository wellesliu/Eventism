import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/vendor.dart';

class VendorRepository {
  List<Vendor>? _cachedVendors;

  Future<List<Vendor>> loadVendors() async {
    if (_cachedVendors != null) return _cachedVendors!;

    final jsonString = await rootBundle.loadString('assets/data/vendors.json');
    final List<dynamic> jsonList = json.decode(jsonString);

    _cachedVendors = jsonList
        .map((json) => Vendor.fromJson(json as Map<String, dynamic>))
        .toList();

    // Sort by name
    _cachedVendors!.sort((a, b) => a.name.compareTo(b.name));

    return _cachedVendors!;
  }

  Future<Vendor?> getVendor(String id) async {
    final vendors = await loadVendors();
    return vendors.where((v) => v.id == id).firstOrNull;
  }

  Future<Vendor?> getVendorBySlug(String slug) async {
    final vendors = await loadVendors();
    return vendors.where((v) => v.slug == slug).firstOrNull;
  }

  Future<List<Vendor>> searchVendors(String query) async {
    final vendors = await loadVendors();
    if (query.isEmpty) return vendors;
    return vendors.where((v) => v.matchesSearch(query)).toList();
  }

  Future<List<Vendor>> filterVendors({
    String? query,
    List<String>? categories,
    String? location,
    bool? availableOnly,
  }) async {
    var vendors = await loadVendors();

    if (query != null && query.isNotEmpty) {
      vendors = vendors.where((v) => v.matchesSearch(query)).toList();
    }

    if (categories != null && categories.isNotEmpty) {
      vendors = vendors
          .where((v) => categories.any((cat) => v.hasCategory(cat)))
          .toList();
    }

    if (location != null && location.isNotEmpty) {
      vendors = vendors
          .where((v) =>
              v.location?.toLowerCase().contains(location.toLowerCase()) ??
              false)
          .toList();
    }

    if (availableOnly == true) {
      vendors = vendors.where((v) => v.isAvailable).toList();
    }

    return vendors;
  }

  Future<List<String>> getAllCategories() async {
    final vendors = await loadVendors();
    final categories = <String>{};
    for (final vendor in vendors) {
      categories.addAll(vendor.categories);
    }
    final sortedCategories = categories.toList()..sort();
    return sortedCategories;
  }

  Future<List<String>> getAllLocations() async {
    final vendors = await loadVendors();
    final locations = <String>{};
    for (final vendor in vendors) {
      if (vendor.location != null && vendor.location!.isNotEmpty) {
        locations.add(vendor.location!);
      }
    }
    final sortedLocations = locations.toList()..sort();
    return sortedLocations;
  }
}
