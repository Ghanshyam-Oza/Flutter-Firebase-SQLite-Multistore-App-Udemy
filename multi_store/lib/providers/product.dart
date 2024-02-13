class Product {
  String name;
  double price;
  int orderedQuantity = 1;
  int totalQuantity;
  List imageUrl;
  String documentId;
  String supplierId;
  Product({
    required this.name,
    required this.price,
    required this.orderedQuantity,
    required this.totalQuantity,
    required this.documentId,
    required this.imageUrl,
    required this.supplierId,
  });

  void increase() {
    orderedQuantity++;
  }

  void decrease() {
    orderedQuantity--;
  }
}
