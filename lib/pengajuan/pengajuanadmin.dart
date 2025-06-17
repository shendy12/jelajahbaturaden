import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form Pengajuan Tempat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: PengajuanFormPage(),
    );
  }
}

class PengajuanFormPage extends StatefulWidget {
  @override
  _PengajuanFormPageState createState() => _PengajuanFormPageState();
}

class _PengajuanFormPageState extends State<PengajuanFormPage> {
  final TextEditingController _idTempatController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  String? _selectedKategori;

  final List<String> _kategoriList = [
    'Wisata Alam',
    'Budaya',
    'Kuliner',
    'Lainnya',
  ];

  String get imageUrl {
    final id =
        _idTempatController.text.isEmpty ? "default" : _idTempatController.text;
    return 'https://picsum.photos/seed/$id/600/400';
  }

  void _submitForm() {
    if (_idTempatController.text.isEmpty ||
        _namaController.text.isEmpty ||
        _deskripsiController.text.isEmpty ||
        _alamatController.text.isEmpty ||
        _selectedKategori == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Mohon lengkapi semua data")));
      return;
    }

    print("ID Tempat: ${_idTempatController.text}");
    print("Nama: ${_namaController.text}");
    print("Deskripsi: ${_deskripsiController.text}");
    print("Alamat: ${_alamatController.text}");
    print("Kategori: $_selectedKategori");
    print("Gambar URL: $imageUrl");

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Pengajuan berhasil dikirim")));
  }

  void _clearForm() {
    _idTempatController.clear();
    _namaController.clear();
    _deskripsiController.clear();
    _alamatController.clear();
    setState(() {
      _selectedKategori = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pengajuan Tempat"),
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {}),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Gambar dari Picsum
              Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(child: Text("Gagal memuat gambar"));
                    },
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _idTempatController,
                decoration: InputDecoration(labelText: "ID Tempat"),
                onChanged: (_) => setState(() {}),
              ),
              SizedBox(height: 12),
              TextField(
                controller: _namaController,
                decoration: InputDecoration(labelText: "Nama Tempat"),
              ),
              SizedBox(height: 12),
              TextField(
                controller: _deskripsiController,
                maxLines: 2,
                decoration: InputDecoration(labelText: "Deskripsi"),
              ),
              SizedBox(height: 12),
              TextField(
                controller: _alamatController,
                decoration: InputDecoration(labelText: "Alamat"),
              ),
              SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedKategori,
                hint: Text("Kategori"),
                items:
                    _kategoriList.map((String kategori) {
                      return DropdownMenuItem<String>(
                        value: kategori,
                        child: Text(kategori),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedKategori = value;
                  });
                },
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      child: Text("Posting"),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: StadiumBorder(),
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _clearForm,
                      child: Text("Clear"),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: StadiumBorder(),
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
