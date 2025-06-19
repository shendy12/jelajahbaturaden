import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  // Dummy list riwayat pencarian (kosong untuk simulasi)
  final List<String> historyList = const [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pencarian", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // History List
          Expanded(
            child:
                historyList.isEmpty
                    ? const Center(
                      child: Text(
                        "Belum ada history pencarian",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: historyList.length,
                      itemBuilder: (context, index) {
                        final item = historyList[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              const Icon(Icons.history, color: Colors.grey),
                            ],
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
