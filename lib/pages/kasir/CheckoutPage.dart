import 'package:flutter/material.dart';
import 'package:kasir_app/services/transaction_service.dart';

class CheckoutPage extends StatefulWidget {
  final List<Map<String, dynamic>> cart;
  final double totalHarga;

  CheckoutPage({
    required this.cart,
    required this.totalHarga,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String selectedPaymentMethod = "Tunai";
  bool isLoading = false;

  void saveTransaction() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Simpan transaksi melalui service
      await TransactionService().saveTransaction({
        "cart": widget.cart,
        "total_harga": widget.totalHarga,
        "metode_pembayaran": selectedPaymentMethod,
        "waktu_transaksi": DateTime.now().toIso8601String(),
      });

      // Transaksi selesai, arahkan ke halaman sukses atau dashboard
      Navigator.pushReplacementNamed(context, "/transaction_success");
    } catch (error) {
      print(error);
      // Jika terjadi kesalahan, tampilkan pesan kesalahan
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan transaksi: $error')),
      );
    } finally {
      setState(() {
        isLoading = false; // Pastikan status loading diubah di akhir
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.cart.length,
                    itemBuilder: (context, index) {
                      final product = widget.cart[index];

                      return ListTile(
                        title: Text(product['produk']),
                        trailing: Text("Rp ${product['harga']}"),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Total : Rp ${widget.totalHarga}",
                        style: const TextStyle(
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        value: selectedPaymentMethod,
                        items: ["Tunai", "Kartu", "Ewallet"]
                            .map(
                              (method) => DropdownMenuItem(
                                child: Text(method),
                                value: method,
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedPaymentMethod = value!;
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: "Metode Pembayaran",
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                          onPressed: () {
                            saveTransaction();
                          },
                          child: const Text("Konfirmasi Pembayaran"))
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
