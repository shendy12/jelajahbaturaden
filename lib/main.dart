import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:jelajahbaturaden/pengajuan/postingadmin.dart';
=======
>>>>>>> f8104e76482add3765b98299409c6e0672ff6208
import 'package:jelajahbaturaden/screen/halamanutama.dart' as home;
import 'package:jelajahbaturaden/screen/listadmin.dart';
import 'package:jelajahbaturaden/screen/profil.dart' as profil;
import 'package:jelajahbaturaden/screen/pencarian.dart' as cari;

void main() {
  runApp(
<<<<<<< HEAD
    MaterialApp(home: FormPostingWisata(), debugShowCheckedModeBanner: false),
=======
    MaterialApp(home: WisataListPage(), debugShowCheckedModeBanner: false),
>>>>>>> f8104e76482add3765b98299409c6e0672ff6208
  );
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    home.HalamanUtama(),
    cari.PencarianPage(),
    profil.Profil(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}
