import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jelajahbaturaden/model/requestmodel.dart';
import 'package:jelajahbaturaden/konstanta.dart';

class DetailPengajuanPage extends StatefulWidget {
  final int id;
  const DetailPengajuanPage({Key? key, required this.id}) : super(key: key);

  @override
  State<DetailPengajuanPage> createState() => _DetailPengajuanPageState();
}

class _DetailPengajuanPageState extends State<DetailPengajuanPage> {
  late Future<DetailPengajuan> _futureDetail;
  bool _isProcessing = false;

  // --- LOGIKA ApiService DIMASUKKAN KE SINI ---
  Future<DetailPengajuan> fetchPengajuanDetail(int id) async {
    final response = await http.get(Uri.parse('${baseUrl}pengajuanadmin/$id'));
    if (response.statusCode == 200) {
      return DetailPengajuan.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal mengambil detail pengajuan');
    }
  }

  Future<bool> rejectPengajuan(int id) async {
    final response = await http.delete(Uri.parse('${baseUrl}pengajuanadmin/$id'));
    return response.statusCode == 200;
  }

  Future<bool> postPengajuan(int id) async {
    final response = await http.post(Uri.parse('${baseUrl}pengajuanadmin/posting/$id'));
    return response.statusCode == 201;
  }
  // -----------------------------------------

  @override
  void initState() {
    super.initState();
    _futureDetail = fetchPengajuanDetail(widget.id);
  }

  Future<void> _handleAction(BuildContext context, Future<bool> Function(int) action) async {
    setState(() { _isProcessing = true; });
    try {
      final success = await action(widget.id);
      if (mounted) {
        final message = success ? 'Aksi berhasil dilakukan' : 'Aksi gagal';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
        if(success) { Navigator.of(context).pop(true); }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Terjadi error: $e')));
      }
    } finally {
      if(mounted) { setState(() { _isProcessing = false; }); }
    }
  }
  
  void _showConfirmationDialog(BuildContext context, String title, String content, VoidCallback onConfirm) {
    showDialog(context: context, builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () { Navigator.of(ctx).pop(); onConfirm(); },
            style: ElevatedButton.styleFrom(backgroundColor: title == 'Tolak Pengajuan' ? Colors.red : Colors.teal),
            child: Text(title == 'Tolak Pengajuan' ? 'Tolak' : 'Posting'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Pengajuan"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: BackButton(onPressed: () => Navigator.of(context).pop(false)),
      ),
      body: FutureBuilder<DetailPengajuan>(
        future: _futureDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting || _isProcessing) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            final detail = snapshot.data!;
            return _buildDetailContent(context, detail);
          }
          return const Center(child: Text("Data tidak ditemukan."));
        },
      ),
    );
  }

  Widget _buildDetailContent(BuildContext context, DetailPengajuan detail) {
    Widget imageWidget;
    if (detail.foto.isNotEmpty) {
      imageWidget = Image.network(
        detail.foto,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) => 
          Icon(Icons.broken_image_outlined, size: 50, color: Colors.grey[600]),
      );
    } else {
      imageWidget = Icon(Icons.image_not_supported_outlined, size: 50, color: Colors.grey[600]);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.grey[200],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: imageWidget,
            ),
          ),
          const SizedBox(height: 24),
          _buildInfoField("Nama Tempat", detail.namawisata),
          _buildInfoField("Deskripsi", detail.deskripsi, maxLines: 5),
          _buildInfoField("Alamat", detail.alamat, maxLines: 3),
          _buildInfoField("Kategori", detail.namakategori),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _showConfirmationDialog(context, 'Tolak Pengajuan', 'Apakah Anda yakin ingin menolak dan menghapus pengajuan ini?', 
                    () => _handleAction(context, rejectPengajuan)
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red, side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text("Tolak", style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _showConfirmationDialog(context, 'Posting Wisata', 'Apakah Anda yakin ingin menerima dan memposting wisata ini?',
                    () => _handleAction(context, postPengajuan)
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal, padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text("Posting", style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildInfoField(String label, String value, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!)
            ),
            child: Text(
              value,
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
