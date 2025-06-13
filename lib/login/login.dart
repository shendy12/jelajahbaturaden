import 'package:flutter/material.dart';
import 'reset.dart';
class PageLogin extends StatefulWidget {
  const PageLogin({super.key});

  @override
  State<PageLogin> createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[700],

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'lib/assets/images/mountainblack.png',
                  height: 100,
                  errorBuilder: (context, error, stackTrace) =>
                      const Text('Gambar tidak ditemukan'),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Belum difungsikan
                  },
                  child: const Text('Sign in'),
                ),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(context,
                    MaterialPageRoute(
                      builder: (context) =>const PageLogin(),
                      ),
                    );
                  },
                  child: const Text('Create Account'),
                ),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(context,
                    MaterialPageRoute(
                      builder: (context) => ResetPasswordForm(),
                    ));
                  },
                  child: const Text('Reset Password'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
