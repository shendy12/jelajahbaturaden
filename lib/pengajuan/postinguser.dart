import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  String? _selectedKategori;

  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;

  final List<String> _kategoriList = [
    'Wisata Alam',
    'Budaya',
    'Kuliner',
    'Lainnya',
  ];

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  void _submitForm() {
    if (_selectedImage == null ||
        _namaController.text.isEmpty ||
        _deskripsiController.text.isEmpty ||
        _alamatController.text.isEmpty ||
        _selectedKategori == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Mohon lengkapi semua data")));
      return;
    }

    // Contoh log output
    print("Nama: ${_namaController.text}");
    print("Deskripsi: ${_deskripsiController.text}");
    print("Alamat: ${_alamatController.text}");
    print("Kategori: $_selectedKategori");
    print("Gambar path: ${_selectedImage!.path}");

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Pengajuan berhasil dikirim")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pengajuan Tempat"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child:
                      _selectedImage != null
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.file(
                              File(_selectedImage!.path),
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          )
                          : Center(child: Text("Upload Image")),
                ),
              ),
              SizedBox(height: 16),
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
              ElevatedButton(
                onPressed: _submitForm,
                child: Text("Request"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: StadiumBorder(),
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
