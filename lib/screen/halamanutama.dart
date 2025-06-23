import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jelajahbaturaden/konstanta.dart';
import 'profil.dart' as profil;
import 'pencarian.dart' as cari;
import 'detail_wisata.dart';
import 'package:provider/provider.dart';
import '../model/user_session.dart';

class HalamanUtama extends StatefulWidget {
  const HalamanUtama({super.key});

  @override
  State<HalamanUtama> createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends State<HalamanUtama> {
  int _selectedIndex = 0;
  List wisataList = [];
  List kategoriList = [];
  int? selectedKategoriId;
  Set<int> favoriteIds = {};
  final PageController _pageController = PageController(viewportFraction: 0.9);

  int userId = 0;
  String username = 'Pengguna';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userSession = Provider.of<UserSession>(context, listen: false);
      if (mounted) {
        setState(() {
          userId = userSession.userId ?? 0;
          username = userSession.username ?? 'Pengguna';
        });
        fetchKategori();
        fetchWisata();
      }
    });
  }

  Future<void> fetchKategori() async {
    final uri = Uri.parse('$baseUrl/kategori');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (!mounted) return;
      setState(() => kategoriList = decoded);
    }
  }

  Future<void> fetchWisata({int? kategoriId}) async {
    final uri =
        kategoriId == null
            ? Uri.parse('$baseUrl/wisata?idpengguna=$userId')
            : Uri.parse(
              '$baseUrl/wisata/kategori/$kategoriId?idpengguna=$userId',
            );

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (!mounted) return;
        setState(() {
          wisataList = decoded;
          favoriteIds = {
            for (var w in decoded)
              if (w['isFavorit'] == 1) w['idwisata'],
          };
        });
      } else {
        print('Failed to load wisata: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching wisata: $e');
    }
  }

  Future<void> toggleFavorit(int idwisata) async {
    if (!mounted) return;
    setState(() {
      favoriteIds.contains(idwisata)
          ? favoriteIds.remove(idwisata)
          : favoriteIds.add(idwisata);
    });
  }

  Widget buildHighlightImageSlider() {
    if (wisataList.isEmpty) {
      return Container(
        height: 200,
        color: Colors.grey[300],
        child: const Center(child: Text("Gambar belum tersedia")),
      );
    }

    return SizedBox(
      height: 200,
      child: PageView.builder(
        controller: _pageController,
        itemCount: wisataList.length,
        itemBuilder: (context, index) {
          final imageUrl = wisataList[index]['foto'];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child:
                  imageUrl != null
                      ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (_, __, ___) => const Icon(Icons.broken_image),
                      )
                      : Container(
                        color: Colors.grey,
                        child: const Icon(Icons.broken_image),
                      ),
            ),
          );
        },
      ),
    );
  }

  Widget buildKategori() {
    if (kategoriList.isEmpty) return const Text("Kategori belum tersedia");

    return Wrap(
      spacing: 10,
      children:
          kategoriList.map((item) {
            final isSelected = selectedKategoriId == item['idkategori'];
            return ChoiceChip(
              label: Text(item['namakategori']),
              selected: isSelected,
              onSelected: (_) {
                if (!mounted) return;
                setState(() => selectedKategoriId = item['idkategori']);
                fetchWisata(kategoriId: item['idkategori']);
              },
              selectedColor: Colors.teal,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
              ),
            );
          }).toList(),
    );
  }

  List<Widget> buildRekomendasiList() {
    if (wisataList.isEmpty) return [const Text("Wisata tidak ditemukan.")];

    return wisataList.map<Widget>((wisata) {
      final id = wisata['idwisata'];
      final isFavorite = favoriteIds.contains(id);
      final imageUrl = wisata['foto'];

      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          contentPadding: const EdgeInsets.all(10),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => DetailWisataPage(wisata: wisata, userId: userId),
              ),
            );
          },
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child:
                imageUrl != null
                    ? Image.network(
                      imageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (_, __, ___) => const Icon(Icons.broken_image),
                    )
                    : Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey,
                      child: const Icon(Icons.broken_image),
                    ),
          ),
          title: Text(wisata['namawisata'] ?? '-'),
          subtitle: Text(wisata['namakategori'] ?? '-'),
          trailing: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => toggleFavorit(id),
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  Text(wisata['rating'].toString()),
                ],
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget buildHomeContent() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selamat Datang, $username'),
        backgroundColor: Colors.teal,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        children: [
          const Text(
            "WISATA BATURADEN",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          buildHighlightImageSlider(),
          const SizedBox(height: 16),
          buildKategori(),
          const SizedBox(height: 16),
          ...buildRekomendasiList(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [buildHomeContent(), cari.PencarianPage(), profil.Profil()];
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
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
