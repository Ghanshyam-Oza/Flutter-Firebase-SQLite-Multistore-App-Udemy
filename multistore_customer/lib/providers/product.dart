class Product {
  String documentId;
  String name;
  double price;
  int orderedQuantity = 1;
  int totalQuantity;
  String imageUrl;
  String supplierId;
  Product({
    required this.documentId,
    required this.name,
    required this.price,
    required this.orderedQuantity,
    required this.totalQuantity,
    required this.imageUrl,
    required this.supplierId,
  });

  Map<String, dynamic> toMap() {
    return {
      'documentId': documentId,
      'name': name,
      'price': price,
      'orderedQuantity': orderedQuantity,
      'totalQuantity': totalQuantity,
      'imageUrl': imageUrl,
      'supplierId': supplierId,
    };
  }

  @override
  String toString() {
    return "Product{name: $name, price: $price, orderedquantity: $orderedQuantity, totalQuantity: $totalQuantity, imageUrl: $imageUrl, supplierId: $supplierId}";
  }

  void increase() {
    orderedQuantity++;
  }

  void decrease() {
    orderedQuantity--;
  }
}
