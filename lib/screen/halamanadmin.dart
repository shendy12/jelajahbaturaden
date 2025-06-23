
import 'package:flutter/material.dart';
import 'package:jelajahbaturaden/pengajuan/pengajuanadmin.dart';
import 'package:jelajahbaturaden/pengajuan/postingadmin.dart';
import 'package:jelajahbaturaden/screen/editdeleteadmin.dart';
import 'package:provider/provider.dart'; 
import '../login/addadmin.dart';
import 'package:jelajahbaturaden/login/login.dart';
import '../model/user_session.dart'; 
class HalamanAdmin extends StatefulWidget {
  const HalamanAdmin({Key? key}) : super(key: key);
  @override
  _HalamanAdminState createState() => _HalamanAdminState();
}
class _HalamanAdminState extends State<HalamanAdmin> {

  String _adminUsername = 'username'; 
  int _adminId = 0; 
  String _adminRole = 'Admin'; 

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userSession = Provider.of<UserSession>(context, listen: false);
      setState(() {
        _adminUsername = userSession.username ?? 'username';
        _adminId = userSession.userId ?? 0;
        _adminRole = userSession.role ?? 'Admin';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.logout, color: Colors.black), 
          onPressed: () {
            final userSession = Provider.of<UserSession>(context, listen: false);
            userSession.clearSession();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const PageLogin()),
              (Route<dynamic> route) => false,
            );
          },
        ),
        title: const Text(
          'Dashboard Admin',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add, color: Colors.black),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => Addadmin()));
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval(
                child: Image.asset(
                  'lib/assets/images/admin.png', 
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.person_pin, size: 150, color: Colors.grey); // Fallback icon
                  },
                ),
              ),
              const SizedBox(height: 24),
              Text(
                _adminUsername, // Menampilkan username 
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Administrator (ID: $_adminId)', // Menampilkan ID 
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D9488),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => FormPostingWisata())

                    );                  },
                  child: const Text('Posting / Manajemen Konten', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D9488),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) =>EditDeleteAdminPage())
                    );
                  },
                  child: const Text('Edit Data Wisata', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D9488),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => Pengajuanadmin()));

                  },
                  child: const Text('Kelola Request Wisata', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: Colors.grey.shade400),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => Addadmin()));
                  },
                  child: Text('Tambah Akun Admin Baru', style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}