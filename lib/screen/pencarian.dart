import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '../model/user_session.dart';
import '../konstanta.dart';
import 'detail_wisata.dart';

class PencarianPage extends StatefulWidget {
  const PencarianPage({Key? key}) : super(key: key);

  @override
  State<PencarianPage> createState() => _PencarianPageState();
}

class _PencarianPageState extends State<PencarianPage> {
  List historyList = [];
  List hasilPencarian = [];
  String searchText = '';
  int userId = 0;
  bool isSearching = false;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userSession = Provider.of<UserSession>(context, listen: false);
      userId = userSession.userId ?? 0;
      fetchHistory();
    });
  }

  Future<void> fetchHistory() async {
    final response = await http.get(
      Uri.parse('$baseUrl/pencarian/history/$userId'),
    );
    if (response.statusCode == 200) {
      setState(() {
        historyList = json.decode(response.body);
      });
    }
  }

  Future<void> searchWisata(String query) async {
    if (query.isEmpty) return;

    setState(() {
      isSearching = true;
      searchText = query;
    });

    final response = await http.post(
      Uri.parse('$baseUrl/pencarian'),
      body: {'idpengguna': userId.toString(), 'text': query},
    );

    if (response.statusCode == 200) {
      setState(() {
        hasilPencarian = json.decode(response.body);
        isSearching = false;
      });
    } else {
      setState(() => isSearching = false);
    }
  }

  Widget buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        onSubmitted: searchWisata,
        decoration: InputDecoration(
          hintText: 'Search',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }

  Widget buildHistoryItem(String text) {
    return ListTile(
      leading: const Icon(Icons.history),
      title: Text(text),
      trailing: const Icon(Icons.restore),
      onTap: () {
        _searchController.text = text;
        searchWisata(text);
      },
    );
  }

  Widget buildHistoryList() {
    if (historyList.isEmpty) {
      return const Center(child: Text('Belum ada pencarian'));
    }

    return ListView.builder(
      itemCount: historyList.length,
      itemBuilder: (context, index) {
        final text = historyList[index]['text'];
        return buildHistoryItem(text);
      },
    );
  }

  Widget buildResultItem(Map wisata) {
    String imageUrl = wisata['foto'] ?? '';
    if (!imageUrl.startsWith('http')) {
      imageUrl = '$baseUrl/uploads/$imageUrl';
    }

    final nama = wisata['namawisata'] ?? '';
    final rating = wisata['rating']?.toString() ?? '0.0';
    final alamat = wisata['alamat'] ?? '-';

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child:
              imageUrl.isNotEmpty
                  ? Image.network(
                    imageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (_, __, ___) =>
                            const Icon(Icons.broken_image, size: 40),
                  )
                  : const Icon(Icons.broken_image, size: 40),
        ),
        title: Text(nama),
        subtitle: Text(alamat),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 16),
            Text(rating),
          ],
        ),
        onTap: () {
          wisata['foto'] = imageUrl;

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetailWisataPage(wisata: wisata, userId: userId),
            ),
          );
        },
      ),
    );
  }

  Widget buildResultList() {
    if (isSearching) {
      return const Center(child: CircularProgressIndicator());
    }

    if (hasilPencarian.isEmpty) {
      return const Center(child: Text('Tidak ada hasil ditemukan.'));
    }

    return ListView.builder(
      itemCount: hasilPencarian.length,
      itemBuilder: (context, index) => buildResultItem(hasilPencarian[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pencarian", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Column(
        children: [
          buildSearchBar(),
          Expanded(
            child: searchText.isEmpty ? buildHistoryList() : buildResultList(),
          ),
        ],
      ),
    );
  }
}
