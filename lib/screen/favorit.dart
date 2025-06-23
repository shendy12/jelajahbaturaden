import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../konstanta.dart';
import '../model/user_session.dart';
import '../model/favoritmodel.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  Future<List<WisataFavorite>>? favorites;

  @override
  void initState() {
    super.initState();
    // Tunggu sampai context tersedia
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = Provider.of<UserSession>(context, listen: false).userId;

      if (userId != null) {
        setState(() {
          favorites = fetchFavorites(userId);
        });
      } else {
        setState(() {
          favorites = Future.error("Pengguna belum login");
        });
      }
    });
  }

  Future<List<WisataFavorite>> fetchFavorites(int userId) async {
    final response = await http.get(
      Uri.parse('${baseUrl}getUserFavorites?idpengguna=$userId'),
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => WisataFavorite.fromJson(e)).toList();
    } else {
      throw Exception("Gagal memuat data favorit");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorit Saya"),
        backgroundColor: Colors.teal,
      ),
      body: favorites == null
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<List<WisataFavorite>>(
              future: favorites,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Belum ada wisata favorit."));
                }

                final items = snapshot.data!;
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 220,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final wisata = items[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                            child: Image.network(
                              wisata.foto,
                              height: 120,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.broken_image, size: 50),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            wisata.namawisata,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            wisata.namakategori,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
