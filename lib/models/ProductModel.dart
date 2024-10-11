class ProductModel {
  final int id;
  final String name;
  final int stock;
  final int price;

  ProductModel({
    required this.id,
    required this.name,
    required this.stock,
    required this.price,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['ID'],
      name: json['name'],
      stock: json['stock'],
      price: json['price'],
    );
  }
}
