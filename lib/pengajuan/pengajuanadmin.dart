import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jelajahbaturaden/konstanta.dart';
import 'package:jelajahbaturaden/pengajuan/detailpengajuan.dart';

class Pengajuan {
  final int id;
  final String namawisata;
  final String namakategori;
  final String foto;

  Pengajuan({
    required this.id,
    required this.namawisata,
    required this.namakategori,
    required this.foto,
  });

  factory Pengajuan.fromJson(Map<String, dynamic> json) {
    return Pengajuan(
      id: int.parse(json['idpengajuan']),
      namawisata: json['namawisata'],
      namakategori: json['namakategori'],
      foto: json['foto'],
    );
  }
}

class Pengajuanadmin extends StatefulWidget {
  const Pengajuanadmin({Key? key}) : super(key: key);

  @override
  State<Pengajuanadmin> createState() => _PengajuanadminState();
}

class _PengajuanadminState extends State<Pengajuanadmin> {
  List<Pengajuan> pengajuanList = [];

  @override
  void initState() {
    super.initState();
    fetchPengajuan();
  }

  Future<void> fetchPengajuan() async {
    final response = await http.get(
      Uri.parse(baseUrl), 
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        pengajuanList = data.map((item) => Pengajuan.fromJson(item)).toList();
      });
    } else {
      print('Gagal mengambil data: ${response.statusCode}');
    }
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
        leading: const BackButton(),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                // Tambahkan pencarian jika perlu
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: pengajuanList.length,
              itemBuilder: (context, index) {
                final item = pengajuanList[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.memory(
                          base64Decode(item.foto),
                          width: 100,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.namawisata,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPengajuanPage(id: item.id),
                            ),
                          );
                        },
                        child: const Text("Detail"),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
