import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:jelajahbaturaden/konstanta.dart';

class FormPostingWisata extends StatefulWidget {
  @override
  _FormPostingWisataState createState() => _FormPostingWisataState();
}

class _FormPostingWisataState extends State<FormPostingWisata> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  String? selectedKategori;
  File? selectedImage;

  final List<Map<String, dynamic>> kategoriList = [
    {'id': '1', 'label': 'Wisata Alam'},
    {'id': '2', 'label': 'Budaya'},
    {'id': '3', 'label': 'Kuliner'},
    {'id': '4', 'label': 'Lainnya'},
  ];

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        selectedImage = File(picked.path);
      });
    }
  }

  Future<void> submitForm() async {
    if (namaController.text.isEmpty ||
        deskripsiController.text.isEmpty ||
        alamatController.text.isEmpty ||
        selectedKategori == null ||
        selectedImage == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Mohon lengkapi semua data')));
      return;
    }

    try {
      var uri = Uri.parse('$baseUrl wisata');
      var request = http.MultipartRequest('POST', uri);

      request.fields['namawisata'] = namaController.text;
      request.fields['deskripsi'] = deskripsiController.text;
      request.fields['alamat'] = alamatController.text;
      request.fields['idkategori'] = selectedKategori!;
      request.files.add(
        await http.MultipartFile.fromPath('foto', selectedImage!.path),
      );

      print('Mengirim data ke $baseUrl wisata...');
      print('Path Gambar: ${selectedImage!.path}');
      print('Kategori ID: $selectedKategori');

      var response = await request.send();
      final respStr = await response.stream.bytesToString();

      print('Status Code: ${response.statusCode}');
      print('Response Body: $respStr');

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Data berhasil dikirim')));
        clearForm();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal: $respStr')));
      }
    } catch (e) {
      print('ERROR: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Terjadi kesalahan: $e')));
    }
  }

  void clearForm() {
    namaController.clear();
    deskripsiController.clear();
    alamatController.clear();
    setState(() {
      selectedKategori = null;
      selectedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Posting Wisata')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: pickImage,
              child: Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(16),
                ),
                child:
                    selectedImage != null
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(selectedImage!, fit: BoxFit.cover),
                        )
                        : Center(child: Text('Upload Image')),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: namaController,
              decoration: InputDecoration(labelText: 'Nama Tempat'),
            ),
            SizedBox(height: 12),
            TextField(
              controller: deskripsiController,
              decoration: InputDecoration(labelText: 'Deskripsi'),
              maxLines: 2,
            ),
            SizedBox(height: 12),
            TextField(
              controller: alamatController,
              decoration: InputDecoration(labelText: 'Alamat'),
            ),
            SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedKategori,
              hint: Text('Kategori'),
              onChanged: (value) => setState(() => selectedKategori = value),
              items:
                  kategoriList
                      .map(
                        (kategori) => DropdownMenuItem<String>(
                          value: kategori['id'],
                          child: Text(kategori['label']),
                        ),
                      )
                      .toList(),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: submitForm,
                    child: Text('Posting'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: StadiumBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: clearForm,
                    child: Text('Clear'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: StadiumBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
