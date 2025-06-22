import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
      Uri.parse('http://localhost:8080/wisata'),
    ); // Ganti dengan IP server kamu

    if (response.statusCode == 200) {
      setState(() {
        wisataList = json.decode(response.body);
      });
    } else {
      throw Exception('Gagal mengambil data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Request Wisata')),
      body:
          wisataList.isEmpty
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: wisataList.length,
                itemBuilder: (context, index) {
                  final wisata = wisataList[index];
                  final imageBytes = base64Decode(wisata['foto']);

                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.memory(
                          imageBytes,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(wisata['namawisata']),
                      subtitle: Text(wisata['namakategori']),
                      trailing: ElevatedButton(
                        child: Text('Detail'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailWisataPage(data: wisata),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
    );
  }
}

class DetailWisataPage extends StatelessWidget {
  final dynamic data;

  DetailWisataPage({required this.data});

  @override
  Widget build(BuildContext context) {
    final imageBytes = base64Decode(data['foto']);

    return Scaffold(
      appBar: AppBar(title: Text(data['namawisata'])),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.memory(imageBytes),
            SizedBox(height: 16),
            Text(
              'Kategori: ${data['namakategori']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text('Alamat: ${data['alamat']}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Deskripsi:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text(data['deskripsi']),
          ],
        ),
      ),
    );
  }
}
