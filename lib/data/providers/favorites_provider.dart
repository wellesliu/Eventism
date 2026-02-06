import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/favorites_service.dart';

final favoritesServiceProvider = Provider<FavoritesService>((ref) {
  return FavoritesService();
});

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, Set<String>>((ref) {
  final service = ref.watch(favoritesServiceProvider);
  return FavoritesNotifier(service);
});

class FavoritesNotifier extends StateNotifier<Set<String>> {
  final FavoritesService _service;
  bool _initialized = false;

  FavoritesNotifier(this._service) : super({}) {
    _init();
  }

  Future<void> _init() async {
    if (_initialized) return;
    final favorites = await _service.getFavorites();
    state = favorites;
    _initialized = true;
  }

  bool isFavorite(String eventId) {
    return state.contains(eventId);
  }

  Future<void> toggleFavorite(String eventId) async {
    await _service.toggleFavorite(eventId);
    if (state.contains(eventId)) {
      state = {...state}..remove(eventId);
    } else {
      state = {...state, eventId};
    }
  }

  Future<void> addFavorite(String eventId) async {
    await _service.addFavorite(eventId);
    state = {...state, eventId};
  }

  Future<void> removeFavorite(String eventId) async {
    await _service.removeFavorite(eventId);
    state = {...state}..remove(eventId);
  }

  Future<void> clearFavorites() async {
    await _service.clearFavorites();
    state = {};
  }
}

// Convenience provider to check if a specific event is favorited
final isEventFavoritedProvider = Provider.family<bool, String>((ref, eventId) {
  final favorites = ref.watch(favoritesProvider);
  return favorites.contains(eventId);
});
