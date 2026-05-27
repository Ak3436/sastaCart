import 'package:flutter/material.dart';

import '../model/product_model.dart';
import '../repository/product_repository.dart';

class CategoryDetailViewModel extends ChangeNotifier {
  final ProductRepository repository;

  CategoryDetailViewModel({ProductRepository? repository})
    : repository = repository ?? ProductRepository();

  bool isLoading = false;
  String errorMessage = "";
  List<ProductModel> products = [];

  Future<void> loadProducts(String url) async {
    try {
      isLoading = true;
      errorMessage = "";
      notifyListeners();

      products = await repository.getProductsByCategoryUrl(url);
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}
