import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:jelajahbaturaden/konstanta.dart';

class FormrequestWisata extends StatefulWidget {
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon lengkapi semua data')),
      );
      return;
    }

    try {
      var uri = Uri.parse('$baseUrl/pengajuan'); // <- PERBAIKAN PENTING
      var request = http.MultipartRequest('POST', uri);

      // Gantilah idpengguna ini dengan userId sesungguhnya dari session jika perlu
      request.fields['idpengguna'] = '1';
      request.fields['namawisata'] = namaController.text;
      request.fields['deskripsi'] = deskripsiController.text;
      request.fields['alamat'] = alamatController.text;
      request.fields['idkategori'] = selectedKategori!;
      request.files.add(
        await http.MultipartFile.fromPath('foto', selectedImage!.path),
      );

      var response = await request.send();
      final respStr = await response.stream.bytesToString();

      print('Status Code: ${response.statusCode}');
      print('Response Body: $respStr');

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Data berhasil dikirim')));
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
      appBar: AppBar(title: const Text('Request Wisata')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
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
                        : const Center(child: Text('Upload Image')),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: namaController,
              decoration: const InputDecoration(labelText: 'Nama Tempat'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: deskripsiController,
              decoration: const InputDecoration(labelText: 'Deskripsi'),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: alamatController,
              decoration: const InputDecoration(labelText: 'Alamat'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedKategori,
              hint: const Text('Kategori'),
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
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: submitForm,
                    child: const Text('Request'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: const StadiumBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: clearForm,
                    child: const Text('Clear'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: const StadiumBorder(),
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
