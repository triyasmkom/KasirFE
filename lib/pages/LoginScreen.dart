// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:kasir_app/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() async {
    String? token = await _authService.login(
      _emailController.text,
      _passwordController.text,
    );

    if (token != null) {
      String? role = await _authService.getRole();

      if (role == 'Admin') {
        Navigator.pushReplacementNamed(context, "/admin");
      } else if (role == 'Kasir') {
        Navigator.pushReplacementNamed(context, "/kasir");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Role tidak dikenali"),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("login failed!"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Login",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              // onPressed: () {
              // contoh ogika login, ganti dengan autentikasi asli
              // bool isAdmin = true;

              // if (isAdmin) {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => AdminDashboard(),
              //     ),
              //   );
              // } else {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => KasirDashboard(),
              //     ),
              //   );
              // }

              // },
              child: const Text("Login"),
            ),
            TextButton(
              onPressed: () {},
              child: const Text("Lupa Password"),
            )
          ],
        ),
      ),
    );
  }
}
