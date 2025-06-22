import 'package:flutter/material.dart';

class DetailWisataPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const DetailWisataPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data['nama']),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                data['gambar'],
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),

            // Nama dan lokasi
            Text(
              data['nama'],
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                Icon(Icons.location_on, size: 18, color: Colors.grey[700]),
                SizedBox(width: 4),
                Text("Lihat Lokasi", style: TextStyle(color: Colors.grey[700])),
                Spacer(),
                Icon(Icons.star, color: Colors.amber, size: 18),
                SizedBox(width: 4),
                Text(data['rating'].toString()),
              ],
            ),
            const SizedBox(height: 24),

            // Deskripsi
            Text(data['deskripsi'], style: TextStyle(color: Colors.grey[800])),
            const Spacer(),

            // Tombol ulasan
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {},
                child: const Text("beri ulasan"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
