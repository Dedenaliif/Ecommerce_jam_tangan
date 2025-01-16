import 'package:ecommerce_jam_tangan/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'history_page.dart'; // Pastikan halaman History sudah ada

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
        // Ambil data dari Firestore berdasarkan UID pengguna
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          setState(() {
            email = user.email ?? "Tidak ada email"; // Email pengguna
            username = userDoc['username'] ?? email.split('@')[0]; // Jika tidak ada username, gunakan email sebelum @
            addressController.text = userDoc['address'] ?? ""; // Isi alamat ke controller
            phoneController.text = userDoc['phone'] ?? ""; // Isi telepon ke controller
          });
        }
      }
    } catch (e) {
      print("Error fetching data: $e"); // Jika terjadi error
    }
  }

  // Fungsi untuk menyimpan data pengguna ke Firestore
  void _saveUserData() async {
    if (addressController.text.isEmpty || phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Alamat dan nomor telepon wajib diisi."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      User? user = _auth.currentUser; // Ambil pengguna yang sedang login
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'email': user.email, // Simpan email pengguna
          'username': username, // Simpan username
          'address': addressController.text, // Simpan alamat
          'phone': phoneController.text, // Simpan nomor telepon
        }, SetOptions(merge: true)); // Merge data jika dokumen sudah ada

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Data berhasil disimpan!"), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      print("Error saving data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menyimpan data, coba lagi."), backgroundColor: Colors.red),
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
                    Text("Selamat Datang : $username", style: TextStyle(fontSize: 18.0)),
                    SizedBox(height: 16.0),
                    Text("Alamat", style: TextStyle(fontSize: 16.0)),
                    TextField(
                      controller: addressController,
                      decoration: InputDecoration(hintText: "Masukkan alamat Anda", border: OutlineInputBorder()),
                    ),
                    SizedBox(height: 16.0),
                    Text("Nomor Telepon", style: TextStyle(fontSize: 16.0)),
                    TextField(
                      controller: phoneController,
                      decoration: InputDecoration(hintText: "Masukkan nomor telepon Anda", border: OutlineInputBorder()),
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: _saveUserData,
                      child: Text("Simpan Data"),
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HistoryPage()),
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
