import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jelajahbaturaden/konstanta.dart';

class RatingSummary extends StatefulWidget {
  final int idWisata;

  const RatingSummary({required this.idWisata, Key? key}) : super(key: key);

  @override
  State<RatingSummary> createState() => _RatingSummaryState();
}

class _RatingSummaryState extends State<RatingSummary> {
  double averageRating = 0.0;
  int totalReviewers = 0;

  @override
  void initState() {
    super.initState();
    _calculateAverageRating();
  }

  Future<void> _calculateAverageRating() async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}review/${widget.idWisata}'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> reviews = json.decode(response.body);
        if (reviews.isNotEmpty) {
          double totalRating = 0.0;
          for (var review in reviews) {
            totalRating += (double.tryParse(review['rating'].toString()) ?? 0.0);
          }

          if (mounted) {
            setState(() {
              totalReviewers = reviews.length;
              averageRating = totalRating / totalReviewers;
            });
          }
        }
      } else {
        debugPrint('Gagal mengambil ulasan: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.star, color: Colors.amber, size: 18),
        const SizedBox(width: 4),
        Text(
          averageRating.toStringAsFixed(1),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 6),
        Text("($totalReviewers ulasan)", style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
