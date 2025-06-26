import 'package:flutter/material.dart';
import 'package:jelajahbaturaden/screen/halamanMenulisReview.dart';

class DetailWisataPage extends StatelessWidget {
  final Map wisata;
  final int userId;

  const DetailWisataPage({Key? key, required this.wisata, required this.userId})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Konversi idwisata ke int secara aman
    final int idWisata = int.parse(wisata['idwisata'].toString());
    final String namaWisata = wisata['namawisata'] ?? 'Nama tidak tersedia';

    return Scaffold(
      appBar: AppBar(
        title: Text(namaWisata),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar utama
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                wisata['foto'] ?? '',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder:
                    (_, __, ___) => Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.broken_image, size: 40),
                      ),
                    ),
              ),
            ),
            const SizedBox(height: 16),

            // Judul & lokasi
            Text(
              namaWisata,
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
                Text(wisata['rating'].toString()),
              ],
            ),
            const SizedBox(height: 24),

            // Deskripsi
            Text(
              wisata['deskripsi'] ?? '-',
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => ReviewPage(
                            idWisata: idWisata,
                            namaWisata: namaWisata,
                            userId: userId,
                          ),
                    ),
                  );
                },
                child: const Text("beri ulasan"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
