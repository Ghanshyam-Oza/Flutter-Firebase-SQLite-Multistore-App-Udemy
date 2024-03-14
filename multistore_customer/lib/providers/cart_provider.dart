import 'package:flutter/foundation.dart';
import 'package:multistore_customer/providers/product.dart';
import 'package:multistore_customer/providers/sql_helper.dart';

class Cart extends ChangeNotifier {
  List<Product> _list = [];
  List<Product> get getItems {
    return _list;
  }

  int? get getCount {
    return _list.length;
  }

  loadCartItemProvider() async {
    List<Map> items = await SQLHelper.loadCartItems();
    _list = items.map((e) {
      return Product(
          documentId: e['documentId'],
          name: e['name'],
          price: e['price'],
          orderedQuantity: e['orderedQuantity'],
          totalQuantity: e['totalQuantity'],
          imageUrl: e['imageUrl'],
          supplierId: e['supplierId']);
    }).toList();
    notifyListeners();
  }

  void addItem(Product product) async {
    await SQLHelper.insertCartItem(product)
        .whenComplete(() => _list.add(product));
    notifyListeners();
  }

  void increaseByOne(Product product) async {
    product.increase();
    await SQLHelper.updateCartItem(product);
    notifyListeners();
  }

  void reduceByOne(Product product) async {
    product.decrease();
    await SQLHelper.updateCartItem(product);
    notifyListeners();
  }

  void removeProduct(Product product) async {
    await SQLHelper.deleteCartItem(product.documentId)
        .whenComplete(() => _list.remove(product));
    notifyListeners();
  }

  void clearCart() async {
    await SQLHelper.deleteAllCartItems().whenComplete(() => _list.clear());
    notifyListeners();
  }

  double get totalPrice {
    var totalPrice = 0.0;
    for (var item in _list) {
      totalPrice += item.orderedQuantity * item.price;
    }
    return totalPrice;
  }
}
