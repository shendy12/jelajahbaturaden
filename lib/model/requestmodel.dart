class Pengajuan {
  final int id;
  final String namawisata;
  final String namakategori;
  final String foto;

  Pengajuan({
    required this.id,
    required this.namawisata,
    required this.namakategori,
    required this.foto,
  });

  factory Pengajuan.fromJson(Map<String, dynamic> json) {
    return Pengajuan(
      id: int.parse(json['idpengajuan'].toString()),
      namawisata: json['namawisata'] ?? 'Tanpa Nama',
      namakategori: json['namakategori'] ?? 'Tanpa Kategori',
      foto: json['foto'] ?? '',
    );
  }
}

class DetailPengajuan {
  final int id;
  final String namawisata;
  final String deskripsi;
  final String alamat;
  final String namakategori;
  final String foto;

  DetailPengajuan({
    required this.id,
    required this.namawisata,
    required this.deskripsi,
    required this.alamat,
    required this.namakategori,
    required this.foto,
  });

  factory DetailPengajuan.fromJson(Map<String, dynamic> json) {
    return DetailPengajuan(
      id: int.parse(json['idpengajuan'].toString()),
      namawisata: json['namawisata'] ?? 'Tanpa Nama',
      deskripsi: json['deskripsi'] ?? 'Tidak ada deskripsi.',
      alamat: json['alamat'] ?? 'Tidak ada alamat.',
      namakategori: json['namakategori'] ?? 'Tanpa Kategori',
      foto: json['foto'] ?? '',
    );
  }
}
