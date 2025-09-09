import 'dart:math';

import 'package:flutter/material.dart';
import 'package:loja/data/dummy_data.dart';
import 'package:loja/models/product.dart';

class ProductList with ChangeNotifier {
  final List<Product> _items = dummyProducts;

  List<Product> get items => [..._items];
  List<Product> get favoriteItems =>
      _items.where((prod) => prod.isFavorite).toList();

  int get itemsCount {
    return _items.length;
  }

  void addProductFromData(Map<String, Object> data) {
    final newProduct = Product(
      id: Random().nextDouble().toString(),
      name: data['nome'] as String,
      description: data['descrição'] as String,
      price: data['preço'] as double,
      imageUrl: data['imageUrl'] as String,
    );
    addProduct(newProduct);
  }

  void addProduct(Product product) {
    _items.add(product);
    notifyListeners();
  }
}

// bool _showFavoriteOnly = false;

//   List<Product> get items {
//     if (_showFavoriteOnly) {
//       return _items.where((prod) => prod.isFavorite).toList();
//     }
//     return [..._items];
//   }

//   void showFavoriteOnly() {
//     _showFavoriteOnly = true;
//     notifyListeners();
//   }

//   void showAll() {
//     _showFavoriteOnly = false;
//     notifyListeners();
//   }
