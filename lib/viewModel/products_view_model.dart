import 'package:curatech_ecom/models/product.dart';
import 'package:flutter/services.dart' show rootBundle;

class ProductViewModel {
  List<Product> _productList;

  List<Product> _selectedProducts = List.empty(growable: true);

  List<Product> get getProductList => _productList;

  List<Product> get getSelectedProduct => _selectedProducts;

  void fetchProducts() async {
    _productList = productFromJson(
        await rootBundle.loadString('lib/assets/raw/products.json'));
  }

  Future<bool> addToCart(Product selectedProduct) {
    if (!_selectedProducts.contains(selectedProduct)) {
      _selectedProducts.add(selectedProduct);
      return Future.value(true);
    } else
      return Future.value(false);
  }

  void removeFromCart(Product selectedProduct) {
    if (_selectedProducts.contains(selectedProduct)) {
      _selectedProducts.remove(selectedProduct);
    }
  }
}
