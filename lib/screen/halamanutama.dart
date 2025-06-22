import 'package:flutter/material.dart';

class HalamanUtama extends StatefulWidget {
  final Map<String, dynamic>? userData;

  const HalamanUtama({super.key, this.userData});

  @override
  State<HalamanUtama> createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends State<HalamanUtama> {
  final List<String> carouselImages = [
    'https://picsum.photos/id/1018/400/250',
    'https://picsum.photos/id/1020/400/250',
    'https://picsum.photos/id/1024/400/250',
  ];

  final List<String> kategori = ['curug', 'taman', 'camping area', 'restoran'];

  final List<Map<String, dynamic>> rekomendasiWisata = List.generate(5, (index) {
    return {
      'id': index,
      'nama': 'Wisata Lain',
      'lokasi': 'Seelisburg',
      'gambar': 'https://picsum.photos/id/${100 + index}/200/150',
      'rating': 4.5,
    };
  });

  final Set<int> favoritSet = {};

  @override
  Widget build(BuildContext context) {
    final namaPengguna = widget.userData?['username'] ?? 'Pengguna';

    return Scaffold(
      appBar: AppBar(
        title: Text('Selamat Datang, $namaPengguna'),
        backgroundColor: Colors.teal,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "WISATA BATURADEN",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 12),

              // Carousel
              SizedBox(
                height: 180,
                child: PageView.builder(
                  itemCount: carouselImages.length,
                  controller: PageController(viewportFraction: 0.9),
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          carouselImages[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              const Text("Rekomendasi", style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),

              // Kategori Chip
              Wrap(
                spacing: 10,
                children: kategori.map((item) {
                  return Chip(
                    label: Text(item),
                    backgroundColor: Colors.grey[200],
                    labelStyle: const TextStyle(fontWeight: FontWeight.w500),
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              // List Wisata
              Column(
                children: rekomendasiWisata.map((item) {
                  final bool isFavorit = favoritSet.contains(item['id']);
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                          ),
                          child: Image.network(
                            item['gambar'],
                            width: 110,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['nama'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item['lokasi'],
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.star, color: Colors.amber, size: 18),
                                        const SizedBox(width: 4),
                                        Text(item['rating'].toString()),
                                      ],
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        isFavorit ? Icons.favorite : Icons.favorite_border,
                                        color: isFavorit ? Colors.red : Colors.black,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          if (isFavorit) {
                                            favoritSet.remove(item['id']);
                                          } else {
                                            favoritSet.add(item['id']);
                                          }
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
