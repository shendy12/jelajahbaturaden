import 'package:flutter/material.dart';
import 'package:jelajahbaturaden/login/login.dart';
import 'package:jelajahbaturaden/screen/favorit.dart';
import 'package:jelajahbaturaden/pengajuan/postinguser.dart'; // tambahkan import ini

class Profil extends StatefulWidget {
  const Profil({super.key});

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        children: [
          const SizedBox(height: 40),
          CircleAvatar(
            radius: 80,
            backgroundColor: Colors.grey.shade200,
            child: const Icon(Icons.person, size: 120, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text('Nama Profil', style: TextStyle(fontSize: 16)),
          ),
          const SizedBox(height: 32),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF00879B),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                MenuProfil(
                  icon: Icons.favorite_border,
                  label: 'Favorite',
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FavoritePage()),
                      ),
                ),
                MenuProfil(
                  icon: Icons.format_list_bulleted,
                  label: 'Request Tempat Wisata',
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FormrequestWisata(),
                        ), // diarahkan ke postinguser.dart
                      ),
                ),
                MenuProfil(
                  icon: Icons.logout,
                  label: 'Logout',
                  onTap:
                      () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => PageLogin()),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MenuProfil extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const MenuProfil({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(label, style: TextStyle(color: Colors.white, fontSize: 16)),
      onTap: onTap,
    );
  }
}
