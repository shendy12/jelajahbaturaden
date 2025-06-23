import 'package:flutter/material.dart';
import 'package:jelajahbaturaden/screen/halamanMenulisReview.dart';

class DetailWisataPage extends StatelessWidget {
  final Map wisata;
  final int userId;

  const DetailWisataPage({Key? key, required this.wisata, required this.userId})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(wisata['namawisata']),
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
                wisata['foto'],
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),

            // Nama dan lokasi
            Text(
              wisata['namawisata'],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                Icon(Icons.location_on, size: 18, color: Colors.grey[700]),
                const SizedBox(width: 4),
                Text("Lihat Lokasi", style: TextStyle(color: Colors.grey[700])),
                const Spacer(),
                const Icon(Icons.star, color: Colors.amber, size: 18),
                const SizedBox(width: 4),
                Text(
                  wisata['rating'].toString(),
                ), // Pastikan rating sudah diubah menjadi int di backend
              ],
            ),
            const SizedBox(height: 24),

            // Deskripsi
            Text(
              wisata['deskripsi'],
              style: TextStyle(color: Colors.grey[800]),
            ),
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
                onPressed: () {
                  // Pastikan idWisata diubah menjadi integer
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => ReviewPage(
                            idWisata: int.parse(
                              wisata['idwisata'].toString(),
                            ), // Mengonversi String ke int
                            namaWisata: wisata['namawisata'],
                            userId: userId, // Pastikan userId adalah int
                          ),
                    ),
                  );
                },
                child: const Text("Beri Ulasan"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
