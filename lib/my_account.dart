import 'package:ecommerce_jam_tangan/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'history.dart'; // Pastikan halaman History sudah ada

class MyAccount extends StatefulWidget {
  const MyAccount({super.key});

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  String email = ""; // Email pengguna
  String username = ""; // Username pengguna
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Auth instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance

  bool isLoading = false; // Untuk mengindikasikan proses sedang berlangsung

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Ambil data pengguna saat widget diinisialisasi
  }

  // Fungsi untuk mengambil data pengguna dari Firestore
 void _fetchUserData() async {
  try {
    User? user = _auth.currentUser; // Ambil pengguna yang sedang login
    if (user != null) {
      print("User UID: ${user.uid}"); // Cetak UID pengguna ke konsol

      // Ambil data dari Firestore berdasarkan UID pengguna
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        print("Data fetched: ${userDoc.data()}"); // Debug data yang berhasil diambil
        setState(() {
          email = user.email ?? "Tidak ada email"; // Email pengguna
          username = email.split('@')[0]; 
          addressController.text = userDoc['address'] ?? ""; // Isi alamat ke controller
          phoneController.text = userDoc['phone'] ?? ""; // Isi telepon ke controller
        });
      } else {
        print("Dokumen tidak ditemukan untuk UID: ${user.uid}"); // Jika dokumen tidak ada
      }
    } else {
      print("Tidak ada pengguna yang login"); // Jika pengguna belum login
    }
  } catch (e) {
    print("Error fetching data: $e"); // Jika terjadi error
  }
}


  // Fungsi untuk menyimpan data pengguna ke Firestore
  void _saveUserData() async {
  try {
    User? user = _auth.currentUser; // Ambil pengguna yang sedang login
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'email': user.email, // Simpan email pengguna
        'address': addressController.text, // Simpan alamat
        'phone': phoneController.text, // Simpan nomor telepon
      }, SetOptions(merge: true)); // Merge data jika dokumen sudah ada

      print("Data berhasil disimpan"); // Debug sukses
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Data berhasil disimpan!"),
          backgroundColor: Colors.green, // Warna sukses
        ),
      );
    } else {
      print("Pengguna tidak ditemukan, tidak bisa menyimpan data");
    }
  } catch (e) {
    print("Error saving data: $e"); // Tangkap error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Gagal menyimpan data, coba lagi."),
        backgroundColor: Colors.red, // Warna error
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Menampilkan loading saat proses berlangsung
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Menampilkan email dan username
                    Text("Selamat Datang : $username", style: TextStyle(fontSize: 18.0)),
                    SizedBox(height: 16.0),

                    // Input alamat
                    Text("Alamat", style: TextStyle(fontSize: 16.0)),
                    TextField(
                      controller: addressController,
                      decoration: InputDecoration(
                        hintText: "Masukkan alamat Anda",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16.0),

                    // Input nomor telepon
                    Text("Nomor Telepon", style: TextStyle(fontSize: 16.0)),
                    TextField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        hintText: "Masukkan nomor telepon Anda",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 16.0),

                    // Tombol untuk menyimpan data
                    ElevatedButton(
                      onPressed: _saveUserData, // Panggil fungsi simpan data
                      child: Text("Simpan Data"),
                    ),
                    SizedBox(height: 16.0),

                    // Tombol untuk menuju halaman history
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => History()), // Menuju halaman History
                        );
                      },
                      child: Text("Lihat History"),
                    ),
                  ],
                ),
              ),
            ),
      showBottomNavbar: true,
      initialIndex: 2,
    );
  }
}
