import 'package:flutter/material.dart';
import 'package:jelajahbaturaden/login/login.dart';
import 'package:jelajahbaturaden/screen/favorit.dart';
class Profil extends StatefulWidget {
  const Profil({super.key});

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  int _currentIndex = 0;
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
          Center(child: const Text('Nama Profil', style: TextStyle(fontSize: 16))),
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
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Favorit())),
                ),
                MenuProfil(icon: Icons.format_list_bulleted, label: 'Request Tempat Wisata', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Favorit()))),
                MenuProfil(icon: Icons.logout, label: 'Logout', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PageLogin())))

              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
          panggilhalaman(value);
        },
        currentIndex: _currentIndex,
        selectedItemColor: Color(0xFF00879B),
        unselectedItemColor: Color(0xFF9E9E9E),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search),label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ]
      ),
    );
  }
  
  void panggilhalaman(int index) {
    if (index == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Favorit()));
    } else if (index == 2){
      Navigator.push(context, MaterialPageRoute(builder: (context) => Favorit()));
    } else if (index == 3) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Profil()));
    }
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
      leading: Icon(icon, color: Colors.white,),
      title: Text(label , style: TextStyle(color: Colors.white, fontSize: 16)),
      onTap: onTap,
    );
  }
}