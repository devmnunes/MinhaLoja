import 'dart:convert';
import 'dart:io' show HttpException;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loja/models/product.dart';
import 'package:loja/utils/constants.dart';

class ProductList with ChangeNotifier {
  final String _token;
  List<Product> _items = [];

  List<Product> get items => [..._items];
  List<Product> get favoriteItems =>
      _items.where((prod) => prod.isFavorite).toList();

  ProductList(this._token, this._items);

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadProducts() async {
    try {
      _items.clear();

      final response = await http.get(
        Uri.parse('${Constants.productBaseUrl}.json?auth=$_token'),
      ).timeout(const Duration(seconds: 10));

      // Debug: verifique a resposta
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode >= 400) {
        throw HttpException(
          'Falha ao carregar produtos. Código: ${response.statusCode}',
        );
      }

      if (response.body == 'null' || response.body.isEmpty) {
        print('Nenhum produto encontrado no servidor');
        notifyListeners();
        return;
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      
      // Limpa a lista antes de adicionar novos itens
      _items.clear();
      
      data.forEach((productId, productData) {
        // Verifica se os dados necessários existem
        if (productData is Map<String, dynamic> &&
            productData['name'] != null &&
            productData['description'] != null &&
            productData['price'] != null) {
          
          _items.add(
            Product(
              id: productId,
              name: productData['name'] as String,
              description: productData['description'] as String,
              price: (productData['price'] is int)
                  ? (productData['price'] as int).toDouble()
                  : productData['price'] as double,
              imageUrl: productData['imageUrl'] as String? ?? '',
              isFavorite: productData['isFavorite'] as bool? ?? false,
            ),
          );
        } else {
          print('Dados inválidos para o produto $productId: $productData');
        }
      });
      
      print('${_items.length} produtos carregados com sucesso');
      notifyListeners();
      
    } catch (error) {
      print('Erro ao carregar produtos: $error');
      // Re-lançar o erro para tratamento superior se necessário
      throw HttpException('Erro ao carregar produtos: $error');
    }
  }

  Future<void> saveProduct(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final product = Product(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      name: data['name'] as String,
      description: data['description'] as String,
      price: data['price'] as double,
      imageUrl: data['imageUrl'] as String,
    );

    if (hasId) {
      return updateProduct(product);
    } else {
      return addProduct(product);
    }
  }

  Future<void> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse('${Constants.productBaseUrl}.json?auth=$_token'),
      body: jsonEncode({
        "name": product.name,
        "description": product.description,
        "price": product.price,
        "imageUrl": product.imageUrl,
      }),
    );

    final id = jsonDecode(response.body)['name'];
    _items.add(
      Product(
        id: id,
        name: product.name,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      ),
    );
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse(
          '${Constants.productBaseUrl}/${product.id}.json?auth=$_token',
        ),
        body: jsonEncode({
          "name": product.name,
          "description": product.description,
          "price": product.price,
          "imageUrl": product.imageUrl,
        }),
      );

      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> removeProduct(Product product) async {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      final product = _items[index];
      _items.remove(product);
      notifyListeners();

      final response = await http.delete(
        Uri.parse(
          '${Constants.productBaseUrl}/${product.id}.json?auth=$_token',
        ),
      );

      if (response.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();
        throw HttpException('Não foi possível excluir o produto.');
      }
    }
  }
}
