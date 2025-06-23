class WisataFavorite {
  final int idwisata;
  final String namawisata;
  final String namakategori;
  final String foto;
  final int? idpengguna; // optional jika dibutuhkan untuk tracking user

  WisataFavorite({
    required this.idwisata,
    required this.namawisata,
    required this.namakategori,
    required this.foto,
    this.idpengguna,
  });

  factory WisataFavorite.fromJson(Map<String, dynamic> json) {
    return WisataFavorite(
      idwisata: int.parse(json['idwisata'].toString()),
      namawisata: json['namawisata'] ?? '',
      namakategori: json['namakategori'] ?? '',
      foto: json['foto'] ?? '',
      idpengguna: json['idpengguna'] != null
          ? int.tryParse(json['idpengguna'].toString())
          : null,
    );
  }
}
