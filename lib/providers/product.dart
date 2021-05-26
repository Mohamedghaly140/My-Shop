import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final double price;
  final String imageUrl;
  final String description;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus() async {
    final oldState = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    final url = Uri.parse(
      'https://shop-flutter-app-cdf5f-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json',
    );

    try {
      final response = await http.patch(
        url,
        body: json.encode({
          'isFavorite': isFavorite,
        }),
      );

      if (response.statusCode >= 400) {
        _setFavValue(oldState);
      }
    } catch (error) {
      _setFavValue(oldState);
    }
  }
}
