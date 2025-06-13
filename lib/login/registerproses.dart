class PenggunaModel {
  String? idPengguna;
  String? email;
  String? password;
  String? username;
  String? role;

  PenggunaModel({
    this.idPengguna,
    this.email,
    this.password,
    this.username,
    this.role,
  });

  PenggunaModel.fromJson(Map<String, dynamic> json) {
    idPengguna = json['id_pengguna']?.toString();
    email = json['email'];
    password = json['password'];
    username = json['username'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_pengguna'] = idPengguna ?? '';
    data['email'] = email ?? '';
    data['password'] = password ?? '';
    data['username'] = username ?? '';
    data['role'] = role ?? '';
    return data;
  }
}
