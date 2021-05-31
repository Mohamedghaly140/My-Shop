import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './product.dart';
import '../models/http_exception.dart';

class Products with ChangeNotifier {
  List<Product> _products = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  final String authToken;
  final String userId;

  Products(this.authToken, this.userId, this._products);

  List<Product> get getAllProducts {
    return [..._products];
  }

  List<Product> get getFavorites {
    return _products.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _products.firstWhere((p) => p.id == id);
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';

    var url = Uri.parse(
      'https://shop-flutter-app-cdf5f-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$authToken&$filterString',
    );

    try {
      final response = await http.get(url);
      final jsonData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];

      if (jsonData == null) {
        return;
      }

      url = Uri.parse(
        'https://shop-flutter-app-cdf5f-default-rtdb.europe-west1.firebasedatabase.app/userFavorites/$userId.json?auth=$authToken',
      );

      final favResponse = await http.get(url);
      final favData = json.decode(favResponse.body);

      jsonData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          isFavorite: favData == null ? false : favData[prodId] ?? false,
          imageUrl: prodData['imageUrl'],
        ));
      });

      _products = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
      'https://shop-flutter-app-cdf5f-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$authToken',
    );

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'description': product.description,
          'creatorId': userId,
        }),
      );

      var newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );

      _products.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _products.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = Uri.parse(
        'https://shop-flutter-app-cdf5f-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json?auth=$authToken',
      );

      await http.patch(
        url,
        body: json.encode({
          'title': newProduct.title,
          'price': newProduct.price,
          'imageUrl': newProduct.imageUrl,
          'description': newProduct.description,
        }),
      );

      _products[prodIndex] = newProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String prodId) async {
    final url = Uri.parse(
      'https://shop-flutter-app-cdf5f-default-rtdb.europe-west1.firebasedatabase.app/products/$prodId.json?auth=$authToken',
    );

    final existingProductIndex =
        _products.indexWhere((prod) => prod.id == prodId);
    var existingProduct = _products[existingProductIndex];

    _products.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _products.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('');
    }
    existingProduct = null;
  }
}
