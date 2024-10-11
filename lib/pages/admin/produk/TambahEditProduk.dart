import 'package:flutter/material.dart';
import 'package:kasir_app/models/ProductModel.dart';
import 'package:kasir_app/services/admin_service.dart';

class TambahEditProduk extends StatefulWidget {
  final bool isEdit;
  final String? productId;
  final ProductModel? productData;

  TambahEditProduk({
    this.isEdit = false,
    this.productId,
    this.productData,
  });

  @override
  State<TambahEditProduk> createState() => _TambahEditProdukState();
}

class _TambahEditProdukState extends State<TambahEditProduk> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController stock = TextEditingController();
  final TextEditingController nameProduct = TextEditingController();
  final TextEditingController price = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.productData != null) {
      nameProduct.text = widget.productData!.name;
      stock.text = (widget.productData!.stock).toString();
      price.text = (widget.productData!.price).toString();
    }
  }

  Future<void> apiAddProduct(
    BuildContext context,
    String name,
    int stock,
    int price,
  ) async {
    try {
      await AdminService().addProduct(name, stock, price);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product berhasil ditambahkan')),
      );
      Navigator.pop(context,
          true); // Kembali ke halaman sebelumnya dengan true sebagai return value
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menambahkan product: $e')),
      );
    }
  }

  Future<void> apiEditProduct(
    BuildContext context,
    String productId,
    String name,
    int stock,
    int price,
  ) async {
    try {
      await AdminService().editProduct(
        int.parse(productId),
        name,
        stock,
        price,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product berhasil diperbarui'),
        ),
      );
      Navigator.pop(context, true); // Kembali ke halaman sebelumnya
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memperbarui product: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? "Edit Produk" : "Tambah Produk"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameProduct,
                decoration: const InputDecoration(labelText: "Nama Produk"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama Produk tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: price,
                decoration: const InputDecoration(labelText: "Harga"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga tidak boleh kosong';
                  }

                  // Validasi angka
                  final n = num.tryParse(value);
                  if (n == null) {
                    return 'Harga harus berupa angka yang valid';
                  }

                  if (n <= 0) {
                    return 'Harga harus lebih dari 0';
                  }

                  return null;
                },
              ),
              TextFormField(
                controller: stock,
                decoration: const InputDecoration(labelText: "Stok"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Stok tidak boleh kosong';
                  }

                  // Validasi angka
                  final n = num.tryParse(value);
                  if (n == null) {
                    return 'Stok harus berupa angka yang valid';
                  }

                  if (n < 0) {
                    return 'Stok tidak boleh kurang dari 0';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    if (widget.isEdit && widget.productId != null) {
                      // Tambahkan atau update produk
                      apiEditProduct(
                        context,
                        widget.productId!,
                        nameProduct.text,
                        int.parse(stock.text),
                        int.parse(price.text),
                      );
                    } else {
                      apiAddProduct(
                        context,
                        nameProduct.text,
                        int.parse(stock.text),
                        int.parse(price.text),
                      );
                    }
                  }
                },
                child:
                    Text(widget.isEdit ? "Simpan Perubahan" : "Tambah Produk"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
