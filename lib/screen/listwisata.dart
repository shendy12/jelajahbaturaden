import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jelajahbaturaden/screen/halaman_edit.dart';

class WisataListPage extends StatefulWidget {
  @override
  _WisataListPageState createState() => _WisataListPageState();
}

class _WisataListPageState extends State<WisataListPage> {
  List<dynamic> wisataList = [];

  @override
  void initState() {
    super.initState();
    fetchWisata();
  }

  Future<void> fetchWisata() async {
    final response = await http.get(
      Uri.parse('https://ac91-175-158-55-121.ngrok-free.app/wisata'),
    );

    if (response.statusCode == 200) {
      setState(() {
        wisataList = json.decode(response.body);
      });
    } else {
      throw Exception('Gagal mengambil data');
    }
  }

  Future<void> deleteWisata(dynamic id) async {
    final url = Uri.parse(
      'https://ac91-175-158-55-121.ngrok-free.app/wisata/$id',
    );

    try {
      final response = await http.delete(url);

      print("Status: ${response.statusCode}");
      print("Body: ${response.body}");

      if (response.statusCode == 200) {
        setState(() {
          wisataList.removeWhere((item) => item['idwisata'] == id);
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Berhasil dihapus')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Widget buildImage(String foto) {
    if (foto.startsWith('http')) {
      return Image.network(
        foto,
        width: 70,
        height: 70,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Icon(Icons.image_not_supported),
      );
    } else if (foto.startsWith('data:image')) {
      final base64Str = foto.split(',').last;
      final imageBytes = base64Decode(base64Str);
      return Image.memory(imageBytes, width: 70, height: 70, fit: BoxFit.cover);
    } else {
      return Icon(Icons.broken_image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('List Wisata')),
      body:
          wisataList.isEmpty
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: wisataList.length,
                itemBuilder: (context, index) {
                  final wisata = wisataList[index];
                  final foto = wisata['foto'] ?? '';

                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: buildImage(foto),
                      ),
                      title: Text(wisata['namawisata'] ?? '-'),
                      subtitle: Text(wisata['namakategori'] ?? '-'),
                      trailing: SizedBox(
                        width: 160,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EditPage(wisata: wisata),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[200],
                                foregroundColor: Colors.purple,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text('Edit'),
                            ),
                            SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                print(wisata['idwisata']);
                                deleteWisata(int.parse(wisata['idwisata']));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red[400],
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text('Hapus'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
