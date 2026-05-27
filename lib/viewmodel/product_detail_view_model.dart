import 'package:flutter/material.dart';

import '../model/product_model.dart';
import '../repository/product_repository.dart';

class ProductDetailViewModel extends ChangeNotifier {
  final ProductRepository repository;

  ProductDetailViewModel({ProductRepository? repository})
    : repository = repository ?? ProductRepository();

  bool isLoading = false;
  String errorMessage = "";
  ProductModel? product;

  Future<void> loadProductDetails(int productId) async {
    try {
      isLoading = true;
      errorMessage = "";
      product = null;
      notifyListeners();

      product = await repository.getProductDetails(productId);
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}
