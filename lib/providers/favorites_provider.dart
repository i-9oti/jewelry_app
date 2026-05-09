import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/database_helper.dart';

class FavoritesNotifier extends StateNotifier<Set<String>> {
  FavoritesNotifier() : super({});

  Future<void> loadFavorites(String userEmail) async {
    final names = await DatabaseHelper.instance.getFavorites(userEmail);
    state = names.toSet();
  }

  bool isFavorite(String productName) {
    return state.contains(productName);
  }

  Future<void> toggleFavorite(
    String userEmail,
    Map<String, dynamic> product,
  ) async {
    final name = product['name'] as String;
    if (state.contains(name)) {
      state = {...state}..remove(name);
      await DatabaseHelper.instance.removeFavorite(userEmail, name);
    } else {
      state = {...state, name};
      await DatabaseHelper.instance.addFavorite(userEmail, name);
    }
  }

  void clearData() {
    state = {};
  }
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, Set<String>>(
  (ref) {
    return FavoritesNotifier();
  },
);
