import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:jelajahbaturaden/konstanta.dart';

class FormrequestWisata extends StatefulWidget {
  // Konstruktor untuk menerima data userData

  @override
  _FormrequestWisataState createState() => _FormrequestWisataState();
}

class _FormrequestWisataState extends State<FormrequestWisata> {
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
    if (selectedImage == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gambar harus dipilih!')));
      return;
    }

    try {
      // Pastikan baseUrl benar, misalnya: "http://your-api-url.com"
      var uri = Uri.parse('$baseUrl pengajuan'); // Endpoint pengajuan
      var request = http.MultipartRequest('POST', uri);

      // Mengirimkan idpengguna yang diambil dari userData (sementara '1' digunakan sebagai default)
      request.fields['idpengguna'] =
          '1'; // Pastikan idpengguna dikirim dengan benar
      request.fields['namawisata'] = namaController.text;
      request.fields['deskripsi'] = deskripsiController.text;
      request.fields['alamat'] = alamatController.text;
      request.fields['idkategori'] = selectedKategori!;

      // Pastikan foto yang dipilih sudah ada dan dikirimkan dengan benar
      request.files.add(
        await http.MultipartFile.fromPath('foto', selectedImage!.path),
      );

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
      appBar: AppBar(title: Text('Request Wisata')),
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
                    child: Text('Request'),
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
