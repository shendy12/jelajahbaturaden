import 'package:flutter/material.dart';
import 'package:jelajahbaturaden/screen/halamanutama.dart' as home;
import 'package:jelajahbaturaden/screen/profil.dart' as profil;
import 'package:jelajahbaturaden/screen/pencarian.dart' as cari;
import 'package:jelajahbaturaden/login/login.dart';
import 'package:jelajahbaturaden/login/addpengguna.dart';

void main() {
  runApp(MaterialApp(home: PageLogin(), debugShowCheckedModeBanner: false));
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
