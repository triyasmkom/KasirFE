class TransactionModel {
  final int id;
  final int userId;
  final double totalHarga;
  final String metodePembayaran;
  final String waktuTransaksi;
  final String kodeTransaksi;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.totalHarga,
    required this.metodePembayaran,
    required this.waktuTransaksi,
    required this.kodeTransaksi,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['ID'],
      userId: json['user_id'],
      totalHarga: json['total_harga'],
      metodePembayaran: json['metode_pembayaran'],
      waktuTransaksi: json['waktu_transaksi'],
      kodeTransaksi: json['kode_transaksi'],
    );
  }
}
