import 'package:flutter/material.dart';

import '../model/category_model.dart';
import '../model/product_model.dart';
import '../network/api_service.dart';


class HomeViewModel
    extends ChangeNotifier {

  final ApiService apiService =
  ApiService();

  bool isLoading = false;

  String errorMessage = "";

  List<CategoryModel> categories = [];

  List<ProductModel> products = [];

  /// LOAD ALL APIs IN PARALLEL
  Future<void> loadHomeData() async {

    try {

      isLoading = true;

      notifyListeners();

      final results = await Future.wait([

        apiService.getCategories(),

        apiService.getProducts(),
      ]);

      categories =
      results[0]
      as List<CategoryModel>;

      products =
      results[1]
      as List<ProductModel>;

    } catch (e) {

      errorMessage = e.toString();
    }

    isLoading = false;

    notifyListeners();
  }
}