import 'package:flutter/material.dart';
import 'package:kasir_app/models/UserModel.dart';
import 'package:kasir_app/pages/admin/pengguna/TambahEditPengguna.dart';
import 'package:kasir_app/services/admin_service.dart';

class ManajemenPengguna extends StatefulWidget {
  const ManajemenPengguna({super.key});

  @override
  State<ManajemenPengguna> createState() => _ManajemenPenggunaState();
}

class _ManajemenPenggunaState extends State<ManajemenPengguna> {
  late Future<List<UserModel>> users;

  // Fungsi untuk memuat ulang pengguna
  void reloadUsers() {
    setState(() {
      users = AdminService().getAllUser();
    });
  }

  @override
  void initState() {
    super.initState();
    users = AdminService().getAllUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manajemen Pengguna"),
        actions: [
          IconButton(
            onPressed: () async {
              // Tambah Pengguna baru
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TambahEditPengguna(),
                ),
              );

              // Cek jika ada perubahan data
              if (result == true) {
                reloadUsers(); // Memuat ulang data pengguna
              }
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder<List<UserModel>>(
        future: users,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            ); // Tampilkan loading
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            ); // Tampilkan error
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Tidak ada pengguna ditemukan.'),
            ); // Tampilkan pesan jika tidak ada pengguna
          }

          // Jika berhasil diambil
          return ListView.builder(
            itemCount: snapshot.data!.length, // Jumlah pengguna
            itemBuilder: (context, index) {
              UserModel user = snapshot.data![index];

              return ListTile(
                leading: const Icon(Icons.person),
                title: Text(user.name),
                subtitle: Text("Role: ${user.role}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () async {
                        // Edit Pengguna
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TambahEditPengguna(
                              isEdit: true,
                              userId: user.id.toString(),
                              userData: user,
                            ),
                          ),
                        );

                        if (result == true) {
                          reloadUsers(); // Memuat ulang data pengguna
                        }
                      },
                      icon: const Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () {
                        // Hapus Pengguna
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Konfirmasi"),
                              content: const Text(
                                  "Apakah anda yakin ingin menghapus pengguna?"),
                              actions: [
                                TextButton(
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                    // Lakukan penghapusan
                                    await AdminService().deleteUser(user.id);

                                    // Memuat ulang daftar pengguna setelah penghapusan
                                    reloadUsers();
                                  },
                                  child: const Text("Ya"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Tidak"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
