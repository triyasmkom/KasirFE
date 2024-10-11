import 'package:flutter/material.dart';
import 'package:kasir_app/pages/admin/AdminDashboard.dart';
import 'package:kasir_app/pages/kasir/CheckoutPage.dart';
import 'package:kasir_app/pages/kasir/KasirDashboard.dart';
import 'package:kasir_app/pages/LoginScreen.dart';
import 'package:kasir_app/pages/kasir/TransactionSuccessPage.dart';
// import 'package:kasir_app/pages/admin/produk/ManajemenProduk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Kasir',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => const LoginScreen(),
        "/kasir": (context) => KasirDashboard(),
        "/admin": (context) => AdminDashboard(),
        "/transaction_success": (context) => const TransactionSuccessPage(),
        // "/manajemenProduk": (context) => const ManajemenProduk(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == "/checkout") {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(builder: (context) {
            return CheckoutPage(
                cart: args['cart'], totalHarga: args['totalHarga']);
          });
        }
        return null;
      },
    );
  }
}
