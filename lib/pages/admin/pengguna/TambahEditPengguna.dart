import 'package:flutter/material.dart';
import 'package:kasir_app/models/UserModel.dart';
import 'package:kasir_app/services/admin_service.dart';

class TambahEditPengguna extends StatefulWidget {
  final bool isEdit;
  final String? userId; // ID pengguna untuk edit
  final UserModel? userData; // Data pengguna yang ada

  TambahEditPengguna({
    this.isEdit = false,
    this.userId,
    this.userData,
  });

  @override
  State<TambahEditPengguna> createState() => _TambahEditPenggunaState();
}

class _TambahEditPenggunaState extends State<TambahEditPengguna> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController name = TextEditingController();
  String? role;
  final TextEditingController password = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.userData != null) {
      // Mengisi field dengan data pengguna yang ada
      name.text = widget.userData!.name;
      email.text = widget.userData!.email;
      role = widget.userData!.role;
    }
  }

  // Fungsi untuk update pengguna
  Future<void> apiEditUser(
      String userId, String name, String email, role, password) async {
    try {
      await AdminService()
          .editUser(int.parse(userId), name, email, role, password);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pengguna berhasil diperbarui'),
        ),
      );
      Navigator.pop(context, true); // Kembali ke halaman sebelumnya
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memperbarui pengguna: $e'),
        ),
      );
    }
  }

  // Fungsi untuk menambahkan pengguna
  Future<void> apiAddUser(String name, String email, role, password) async {
    try {
      await AdminService().addUser(name, email, role, password);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pengguna berhasil ditambahkan')),
      );
      Navigator.pop(context, true); // Kembali ke halaman sebelumnya
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menambahkan pengguna: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? 'Edit Pengguna' : 'Tambah Pengguna'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: name,
                decoration: InputDecoration(labelText: 'Nama Pengguna'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama pengguna tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: email,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email tidak boleh kosong';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField(
                value: role,
                items: <String>['Kasir', 'Admin'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    role = value;
                  });
                },
                decoration: InputDecoration(labelText: 'Role'),
              ),
              if (!widget.isEdit)
                TextFormField(
                  controller: password,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (!widget.isEdit && (value == null || value.isEmpty)) {
                      return 'Password tidak boleh kosong';
                    }
                    return null;
                  },
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    if (widget.isEdit && widget.userId != null) {
                      // Update pengguna
                      apiEditUser(
                        widget.userId!,
                        name.text,
                        email.text,
                        role,
                        password.text.isEmpty
                            ? null
                            : password.text, // Password opsional
                      );
                    } else {
                      // Tambah pengguna
                      apiAddUser(name.text, email.text, role, password.text);
                    }
                  }
                },
                child: Text(
                    widget.isEdit ? 'Simpan Perubahan' : 'Tambah Pengguna'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
