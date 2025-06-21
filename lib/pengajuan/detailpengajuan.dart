import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jelajahbaturaden/konstanta.dart';

class DetailPengajuanPage extends StatefulWidget {
  final int id;

  const DetailPengajuanPage({Key? key, required this.id}) : super(key: key);

  @override
  State<DetailPengajuanPage> createState() => _DetailPengajuanPageState();
}

class _DetailPengajuanPageState extends State<DetailPengajuanPage> {
  Map<String, dynamic>? data;

  @override
  void initState() {
    super.initState();
    fetchDetail();
  }

  Future<void> fetchDetail() async {
    final response = await http.get(
      Uri.parse('$baseUrl${widget.id}'),
    );
    if (response.statusCode == 200) {
      setState(() {
        data = json.decode(response.body);
      });
    } else {
      print('Gagal fetch detail');
    }
  }

  Future<void> tolak() async {
    final response = await http.delete(
      Uri.parse('$baseUrl${widget.id}'),
    );
    if (response.statusCode == 200) {
      Navigator.pop(context);
    } else {
      print('Gagal menolak');
    }
  }

  Future<void> posting() async {
    final response = await http.post(
      Uri.parse('${baseUrl}approve/${widget.id}'),
    );
    if (response.statusCode == 200) {
      Navigator.pop(context);
    } else {
      print('Gagal posting');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Detail")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.memory(
                base64Decode(data!['foto']),
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            buildTextField("Nama Tempat", data!['namawisata']),
            buildTextField("Deskripsi", data!['deskripsi']),
            buildTextField("Alamat", data!['alamat']),
            buildTextField("Kategori", data!['namakategori']),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: tolak,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                    child: const Text("Tolak"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: posting,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                    child: const Text("Posting"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        initialValue: value,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
