import 'package:flutter/material.dart';
import 'package:jelajahbaturaden/screen/halamanMenulisReview.dart';
import 'package:jelajahbaturaden/screen/halamanutama.dart' as home;
import 'package:jelajahbaturaden/screen/profil.dart' as profil;
import 'package:jelajahbaturaden/screen/pencarian.dart' as cari;
import 'package:jelajahbaturaden/screen/edit/hapusReview.dart';

void main() {
  runApp(MaterialApp(home: Hapusreview(), debugShowCheckedModeBanner: false));
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
    return Scaffold(body: _pages[_selectedIndex]);
  }
}
