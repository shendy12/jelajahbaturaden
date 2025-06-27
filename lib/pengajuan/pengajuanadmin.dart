import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jelajahbaturaden/model/requestmodel.dart';
import 'package:jelajahbaturaden/konstanta.dart';
import 'package:jelajahbaturaden/pengajuan/detailpengajuan.dart';

class PengajuanAdminPage extends StatefulWidget {
  const PengajuanAdminPage({Key? key}) : super(key: key);

  @override
  State<PengajuanAdminPage> createState() => _PengajuanAdminPageState();
}

class _PengajuanAdminPageState extends State<PengajuanAdminPage> {
  late Future<List<Pengajuan>> _futurePengajuan;
  List<Pengajuan> _allPengajuan = [];
  List<Pengajuan> _filteredPengajuan = [];
  final TextEditingController _searchController = TextEditingController();

  // --- LOGIKA ApiService DIMASUKKAN KE SINI ---
  Future<List<Pengajuan>> fetchPengajuanList() async {
    final response = await http.get(Uri.parse('${baseUrl}pengajuanadmin'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Pengajuan.fromJson(item)).toList();
    } else {
      throw Exception('Gagal mengambil daftar pengajuan');
    }
  }
  // -----------------------------------------

  @override
  void initState() {
    super.initState();
    _loadPengajuan();
    _searchController.addListener(_filterPengajuan);
  }

  void _loadPengajuan() {
    setState(() {
      _futurePengajuan = fetchPengajuanList();
      _futurePengajuan.then((data) {
        setState(() {
          _allPengajuan = data;
          _filteredPengajuan = data;
        });
      }).catchError((error) {
        // Handle error jika fetch gagal
        setState(() {
          _allPengajuan = [];
          _filteredPengajuan = [];
        });
      });
    });
  }
  
  void _filterPengajuan() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredPengajuan = _allPengajuan.where((item) {
        return item.namawisata.toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> _refresh() async {
    _searchController.clear();
    _loadPengajuan();
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: const Text('Request Wisata'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Pengajuan>>(
              future: _futurePengajuan,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Tidak ada request wisata.'));
                }

                return RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView.builder(
                    itemCount: _filteredPengajuan.length,
                    itemBuilder: (context, index) {
                      final item = _filteredPengajuan[index];
                      return _buildPengajuanCard(item);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPengajuanCard(Pengajuan item) {
    Widget imageWidget;
    if (item.foto.isNotEmpty) {
      imageWidget = Image.network(
        item.foto,
        width: 100,
        height: 80,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: 100,
            height: 80,
            color: Colors.grey[300],
            child: const Center(child: CircularProgressIndicator()),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
              width: 100,
              height: 80,
              color: Colors.grey[300],
              child: Icon(Icons.broken_image_outlined, color: Colors.grey[600]));
        },
      );
    } else {
      imageWidget = Container(
          width: 100,
          height: 80,
          color: Colors.grey[300],
          child: Icon(Icons.image_not_supported_outlined, color: Colors.grey[600]));
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: imageWidget,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.namawisata,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  item.namakategori,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
            ),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPengajuanPage(id: item.id),
                ),
              );
              if (result == true) {
                _refresh();
              }
            },
            child: const Text("Detail"),
          ),
        ],
      ),
    );
  }
}
