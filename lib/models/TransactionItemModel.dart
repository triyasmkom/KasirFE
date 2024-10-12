class TransactionItemModel {
  final int id;
  final double price;
  final String productName;
  final String kode;

  TransactionItemModel({
    required this.id,
    required this.price,
    required this.productName,
    required this.kode,
  });

  factory TransactionItemModel.fromJson(Map<String, dynamic> json) {
    return TransactionItemModel(
      id: json['ID'],
      price: json['price'],
      productName: json['product_name'],
      kode: json['kode'],
    );
  }
}
