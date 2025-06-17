import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: ReviewPage()));

class ReviewPage extends StatefulWidget {
  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  int _selectedRating = 0;
  final TextEditingController _reviewController = TextEditingController();

  List<Map<String, dynamic>> _reviews = [
    {'name': 'Bagus', 'text': 'Tempatnya sejuk menarik', 'rating': 4},
    {'name': 'Adi', 'text': 'Nyaman, bagus', 'rating': 5},
    {'name': 'Faiz', 'text': 'Tempatnya indah', 'rating': 4},
    {'name': 'Shendy', 'text': 'tempatnya nyaman', 'rating': 5},
  ];

  void _submitReview() {
    if (_reviewController.text.isNotEmpty && _selectedRating > 0) {
      setState(() {
        _reviews.insert(0, {
          'name': 'Pengguna',
          'text': _reviewController.text,
          'rating': _selectedRating,
        });
        _reviewController.clear();
        _selectedRating = 0;
      });
    }
  }

  Widget _buildStarRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < _selectedRating ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 30,
          ),
          onPressed: () {
            setState(() {
              _selectedRating = index + 1;
            });
          },
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('curug', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildStarRating(),
            TextField(
              controller: _reviewController,
              decoration: InputDecoration(
                hintText: 'tulis ulasan',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _submitReview,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
              child: Text('beri ulasan'),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _reviews.length,
                itemBuilder: (context, index) {
                  final review = _reviews[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(review['name']),
                      subtitle: Text(review['text']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, color: Colors.amber),
                          Text('${review['rating']}'),
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }
}
