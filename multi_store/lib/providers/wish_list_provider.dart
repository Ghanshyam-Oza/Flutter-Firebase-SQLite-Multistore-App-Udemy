import 'package:flutter/foundation.dart';
import 'package:multi_store/providers/product.dart';

class WishList extends ChangeNotifier {
  List<Product> _list = [];
  List<Product> get getWishListItems {
    return _list;
  }

  int? get getCount {
    return _list.length;
  }

  void addWishListItem(String name, double price, int orderedQuantity,
      int totalQuantity, List imageUrl, String documentId, String supplierId) {
    var product = Product(
      name: name,
      price: price,
      orderedQuantity: orderedQuantity,
      totalQuantity: totalQuantity,
      documentId: documentId,
      imageUrl: imageUrl,
      supplierId: supplierId,
    );
    _list.add(product);
    notifyListeners();
  }

  void removeProduct(Product product) {
    _list.remove(product);
    notifyListeners();
  }

  void clearWishList() {
    _list.clear();
    notifyListeners();
  }

  double get totalPrice {
    var totalPrice = 0.0;
    for (var item in _list) {
      totalPrice += item.orderedQuantity * item.price;
    }
    return totalPrice;
  }

  void removeThis(String id) {
    _list.removeWhere((element) => element.documentId == id);
    notifyListeners();
  }
}
