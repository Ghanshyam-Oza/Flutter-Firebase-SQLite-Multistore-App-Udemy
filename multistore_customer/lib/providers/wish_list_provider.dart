import 'package:flutter/foundation.dart';
import 'package:multistore_customer/providers/product.dart';
import 'package:multistore_customer/providers/sql_helper.dart';

class WishList extends ChangeNotifier {
  List<Product> _list = [];
  List<Product> get getWishListItems {
    return _list;
  }

  int? get getCount {
    return _list.length;
  }

  loadWishListItemProvider() async {
    List<Map> items = await SQLHelper.loadWishItems();
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

  void addWishListItem(Product product) async {
    await SQLHelper.insertWishItem(product)
        .whenComplete(() => _list.add(product));
    notifyListeners();
  }

  void removeProduct(Product product) async {
    await SQLHelper.deleteWishItem(product.documentId)
        .whenComplete(() => _list.remove(product));
    notifyListeners();
  }

  void clearWishList() async {
    await SQLHelper.deleteAllWishItems().whenComplete(() => _list.clear());
    notifyListeners();
  }

  double get totalPrice {
    var totalPrice = 0.0;
    for (var item in _list) {
      totalPrice += item.orderedQuantity * item.price;
    }
    return totalPrice;
  }

  void removeThis(String id) async {
    await SQLHelper.deleteWishItem(id).whenComplete(
        () => _list.removeWhere((element) => element.documentId == id));
    notifyListeners();
  }
}
