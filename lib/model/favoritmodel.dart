import 'dart:convert';
import 'dart:typed_data';

class WisataFavorite {
  final int idwisata;
  final String namawisata;
  final String namakategori;
  final Uint8List foto;

  WisataFavorite({
    required this.idwisata,
    required this.namawisata,
    required this.namakategori,
    required this.foto,
  });

  factory WisataFavorite.fromJson(Map<String, dynamic> json) {
    return WisataFavorite(
      idwisata: int.parse(json['idwisata'].toString()),
      namawisata: json['namawisata'],
      namakategori: json['namakategori'],
      foto: base64Decode(json['foto']),
    );
  }
}
