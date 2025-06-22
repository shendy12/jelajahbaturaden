import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:jelajahbaturaden/konstanta.dart';

// Ganti sesuai baseUrl API kamu

class ReviewPage extends StatefulWidget {
  final int idWisata;
  final String namaWisata;
  final int userId; // id_pengguna yang sedang login

  const ReviewPage({
    required this.idWisata,
    required this.namaWisata,
    required this.userId,
    Key? key,
  }) : super(key: key);

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  double _currentRating = 0;
  final TextEditingController _ulasanController = TextEditingController();
  List<dynamic> _reviews = [];

  @override
  void initState() {
    super.initState();
    _fetchUlasan();
  }

  Future<void> _fetchUlasan() async {
    final response = await http.get(
      Uri.parse('${baseUrl}review/${widget.idWisata}'),
    );

    if (response.statusCode == 200) {
      setState(() {
        _reviews = json.decode(response.body);
      });
    } else {
      print('Gagal mengambil ulasan');
    }
  }

  Future<void> _kirimUlasan() async {
    if (_currentRating == 0 || _ulasanController.text.trim().isEmpty) return;

    final response = await http.post(
      Uri.parse('${baseUrl}review'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'idwisata': widget.idWisata,
        'review': _ulasanController.text.trim(),
        'rating': _currentRating.toInt(),
      }),
    );

    if (response.statusCode == 201) {
      setState(() {
        _currentRating = 0;
        _ulasanController.clear();
      });
      _fetchUlasan();
    } else {
      print('Gagal mengirim ulasan');
    }
  }

  Future<void> _hapusUlasan(int idReview) async {
    final response = await http.delete(Uri.parse('${baseUrl}review/$idReview'));

    if (response.statusCode == 200 || response.statusCode == 204) {
      _fetchUlasan();
    } else {
      print('Gagal menghapus ulasan');
    }
  }

  Widget _buildUlasanCard(Map review) {
    final bool isMine = review['id_pengguna'] == widget.userId;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(blurRadius: 2, color: Colors.grey.shade300)],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  review['username'] ?? 'Anonim',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(review['review'] ?? ''),
                const SizedBox(height: 6),
                Row(
                  children: List.generate(
                    review['rating'],
                    (_) =>
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                  ),
                ),
              ],
            ),
          ),
          if (isMine)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: const Text('Hapus Ulasan'),
                        content: const Text(
                          'Apakah kamu yakin ingin menghapus ulasan ini?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Batal'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Hapus'),
                          ),
                        ],
                      ),
                );
                if (confirm == true) {
                  _hapusUlasan(review['idreview']);
                }
              },
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(widget.namaWisata),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            RatingBar.builder(
              initialRating: _currentRating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemSize: 34,
              itemBuilder:
                  (context, _) => const Icon(Icons.star, color: Colors.amber),
              onRatingUpdate: (rating) {
                setState(() => _currentRating = rating);
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _ulasanController,
              decoration: InputDecoration(
                hintText: 'tulis ulasan',
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _kirimUlasan,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('beri ulasan', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 12),
            const Divider(),
            Expanded(
              child:
                  _reviews.isEmpty
                      ? const Center(child: Text('Belum ada ulasan.'))
                      : ListView.builder(
                        itemCount: _reviews.length,
                        itemBuilder:
                            (context, index) =>
                                _buildUlasanCard(_reviews[index]),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
