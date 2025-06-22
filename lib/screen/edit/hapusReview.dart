import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: Hapusreview(), debugShowCheckedModeBanner: false));
}

class Review {
  String name;
  String comment;
  int rating;
  bool isUser;

  Review(this.name, this.comment, this.rating, {this.isUser = false});
}

class Hapusreview extends StatefulWidget {
  @override
  _HapusreviewState createState() => _HapusreviewState();
}

class _HapusreviewState extends State<Hapusreview> {
  int _rating = 0;
  final TextEditingController _commentController = TextEditingController();

  final List<Review> _reviews = [
    Review('Bagus', 'Tempatnya sejuk menarik', 4),
    Review('Adi', 'Nyaman, bagus', 5),
    Review('Faiz', 'Tempatnya indah', 4),
    Review('Shendy', 'Tempatnya sejuk menarik', 5),
  ];

  int? _editingIndex;

  void _submitReview() {
    if (_commentController.text.isNotEmpty && _rating > 0) {
      setState(() {
        if (_editingIndex == null) {
          // Tambah review baru dari user
          _reviews.insert(
            0,
            Review("User", _commentController.text, _rating, isUser: true),
          );
        } else {
          // Edit review milik user
          _reviews[_editingIndex!] = Review(
            "User",
            _commentController.text,
            _rating,
            isUser: true,
          );
          _editingIndex = null;
        }
        _commentController.clear();
        _rating = 0;
      });
    }
  }

  void _editReview(int index) {
    final review = _reviews[index];
    if (!review.isUser) return; // Hanya izinkan edit jika milik user

    setState(() {
      _commentController.text = review.comment;
      _rating = review.rating;
      _editingIndex = index;
    });
  }

  void _deleteReview(int index) {
    final review = _reviews[index];
    if (!review.isUser) return; // Hanya izinkan hapus jika milik user

    setState(() {
      _reviews.removeAt(index);
      if (_editingIndex == index) {
        _editingIndex = null;
        _commentController.clear();
        _rating = 0;
      }
    });
  }

  Widget buildStar(int index) {
    return IconButton(
      icon: Icon(
        index < _rating ? Icons.star : Icons.star_border,
        color: Colors.black,
        size: 36,
      ),
      onPressed: () {
        setState(() {
          _rating = index + 1;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('curug', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) => buildStar(index)),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'tulis ulasan',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _submitReview,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(
                _editingIndex == null ? 'beri ulasan' : 'simpan perubahan',
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _reviews.length,
                itemBuilder: (context, index) {
                  final review = _reviews[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(
                        review.name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(review.comment),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, color: Colors.amber),
                          SizedBox(width: 4),
                          Text('${review.rating}'),
                          if (review.isUser) ...[
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.grey[700]),
                              onPressed: () => _editReview(index),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteReview(index),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
