import 'package:flutter/material.dart';
import 'package:kasir_app/models/UserModel.dart';
import 'package:kasir_app/services/kasir_service.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  late Future<UserModel> userProfile;

  @override
  void initState() {
    super.initState();
    userProfile =
        KasirService().getProfileByUserId(); // Fetch user profile by ID
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Informasi User"),
      ),
      body: FutureBuilder<UserModel>(
        future: userProfile,
        builder: (context, snapshot) {
          // print(snapshot.data!);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Gagal memuat data pengguna'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Tidak ada data pengguna'));
          }

          UserModel user = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nama: ${user.name}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'Email: ${user.email}',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                // Tambahkan informasi lain yang dibutuhkan
              ],
            ),
          );
        },
      ),
    );
  }
}
