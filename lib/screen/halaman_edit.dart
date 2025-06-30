import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:image_picker/image_picker.dart';

class EditPage extends StatefulWidget {
  final dynamic wisata;

  const EditPage({super.key, required this.wisata});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late TextEditingController idController;
  late TextEditingController namaController;
  late TextEditingController deskripsiController;
  late TextEditingController alamatController;
  String? selectedKategori;
  File? selectedImage;
  final List<String> kategoriList = ['Pantai', 'Gunung', 'Museum', 'Taman'];

  @override
  void initState() {
    super.initState();
    idController = TextEditingController(
      text: widget.wisata['idwisata'].toString(),
    );
    namaController = TextEditingController(text: widget.wisata['namawisata']);
    deskripsiController = TextEditingController(
      text: widget.wisata['deskripsi'],
    );
    alamatController = TextEditingController(text: widget.wisata['alamat']);
    selectedKategori =
        kategoriList.contains(widget.wisata['namakategori'])
            ? widget.wisata['namakategori']
            : null;
    print(selectedKategori);
  }

  Future<void> updateWisata() async {
    var uri = Uri.parse(
      'https://ac91-175-158-55-121.ngrok-free.app/wisataedit/${widget.wisata['idwisata']}',
    );

    var request = http.MultipartRequest('PUT', uri);
    request.fields['namawisata'] = namaController.text;
    request.fields['deskripsi'] = deskripsiController.text;
    request.fields['alamat'] = alamatController.text;
    request.fields['namakategori'] = selectedKategori ?? '';

    if (selectedImage != null) {
      request.files.add(
        await http.MultipartFile.fromPath('foto', selectedImage!.path),
      );
    }

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Berhasil memperbarui data')));
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memperbarui data')));
    }
  }

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        selectedImage = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Wisata")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: idController,
              decoration: InputDecoration(labelText: 'ID Tempat'),
              enabled: false,
            ),
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
            SizedBox(height: 10),
            TextField(
              controller: namaController,
              decoration: InputDecoration(labelText: 'Nama Tempat'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: deskripsiController,
              decoration: InputDecoration(labelText: 'Deskripsi'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: alamatController,
              decoration: InputDecoration(labelText: 'Alamat'),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedKategori,
              decoration: InputDecoration(labelText: 'Kategori'),
              items:
                  kategoriList.map((kategori) {
                    return DropdownMenuItem<String>(
                      value: kategori,
                      child: Text(kategori),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedKategori = value!;
                });
              },
            ),
            SizedBox(height: 30),
            ElevatedButton(onPressed: updateWisata, child: Text('Posting')),
          ],
        ),
      ),
    );
  }
}
