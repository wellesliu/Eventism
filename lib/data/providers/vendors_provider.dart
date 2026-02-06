import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/vendor.dart';
import '../repositories/vendor_repository.dart';

final vendorRepositoryProvider = Provider<VendorRepository>((ref) {
  return VendorRepository();
});

final vendorsProvider = FutureProvider<List<Vendor>>((ref) async {
  final repository = ref.watch(vendorRepositoryProvider);
  return repository.loadVendors();
});

final vendorByIdProvider = FutureProvider.family<Vendor?, String>((ref, id) async {
  final repository = ref.watch(vendorRepositoryProvider);
  return repository.getVendor(id);
});

final vendorBySlugProvider = FutureProvider.family<Vendor?, String>((ref, slug) async {
  final repository = ref.watch(vendorRepositoryProvider);
  return repository.getVendorBySlug(slug);
});

final vendorCategoriesProvider = FutureProvider<List<String>>((ref) async {
  final repository = ref.watch(vendorRepositoryProvider);
  return repository.getAllCategories();
});

final vendorLocationsProvider = FutureProvider<List<String>>((ref) async {
  final repository = ref.watch(vendorRepositoryProvider);
  return repository.getAllLocations();
});

final availableVendorsProvider = FutureProvider<List<Vendor>>((ref) async {
  final repository = ref.watch(vendorRepositoryProvider);
  return repository.filterVendors(availableOnly: true);
});
