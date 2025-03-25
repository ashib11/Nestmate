import 'package:flutter/material.dart';
import '../models/property.dart';

class FavoritesProvider with ChangeNotifier {
  final List<Property> _favoriteProperties = [];

  List<Property> get favoriteProperties => _favoriteProperties;

  void addToFavorites(Property property) {
    if (!_favoriteProperties.contains(property)) {
      _favoriteProperties.add(property);
      notifyListeners();
    }
  }

  void removeFromFavorites(Property property) {
    _favoriteProperties.remove(property);
    notifyListeners();
  }

  bool isFavorite(Property property) {
    return _favoriteProperties.contains(property);
  }
}