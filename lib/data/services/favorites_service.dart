import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const _favoritesKey = 'favorite_event_ids';

  SharedPreferences? _prefs;

  Future<SharedPreferences> get _preferences async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<Set<String>> getFavorites() async {
    final prefs = await _preferences;
    final favorites = prefs.getStringList(_favoritesKey) ?? [];
    return favorites.toSet();
  }

  Future<bool> isFavorite(String eventId) async {
    final favorites = await getFavorites();
    return favorites.contains(eventId);
  }

  Future<void> addFavorite(String eventId) async {
    final prefs = await _preferences;
    final favorites = await getFavorites();
    favorites.add(eventId);
    await prefs.setStringList(_favoritesKey, favorites.toList());
  }

  Future<void> removeFavorite(String eventId) async {
    final prefs = await _preferences;
    final favorites = await getFavorites();
    favorites.remove(eventId);
    await prefs.setStringList(_favoritesKey, favorites.toList());
  }

  Future<void> toggleFavorite(String eventId) async {
    final isFav = await isFavorite(eventId);
    if (isFav) {
      await removeFavorite(eventId);
    } else {
      await addFavorite(eventId);
    }
  }

  Future<void> clearFavorites() async {
    final prefs = await _preferences;
    await prefs.remove(_favoritesKey);
  }
}
