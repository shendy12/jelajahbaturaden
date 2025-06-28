import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jelajahbaturaden/login/login.dart';
import 'package:jelajahbaturaden/screen/favorit.dart';
import 'package:jelajahbaturaden/pengajuan/postinguser.dart';
import '../model/user_session.dart';

class Profil extends StatefulWidget {
  const Profil({super.key});

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  String _username = 'Nama Profil';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userSession = Provider.of<UserSession>(context, listen: false);
      setState(() {
        _username = userSession.username ?? 'Nama Profil';
      });
    });
  }

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
          Center(child: Text(_username, style: TextStyle(fontSize: 16))),
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
                        MaterialPageRoute(builder: (context) => PostingUser()),
                      ),
                ),
                MenuProfil(
                  icon: Icons.logout,
                  label: 'Logout',
                  onTap: () {
                    final userSession = Provider.of<UserSession>(
                      context,
                      listen: false,
                    );
                    userSession.clearSession();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => PageLogin()),
                      (Route<dynamic> route) => false,
                    );
                  },
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
