import 'package:ecommerce_jam_tangan/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'history.dart'; // Pastikan History sudah ada

class MyAccount extends StatefulWidget {
  const MyAccount({super.key});

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String email = "den@gmail.com"; // Ganti dengan email pengguna yang terdaftar
    String username = email.split('@')[0]; // Username adalah bagian sebelum '@'

    return CustomScaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Username: $username", style: TextStyle(fontSize: 18.0)),
              SizedBox(height: 16.0),
              Text("Alamat", style: TextStyle(fontSize: 16.0)),
              TextField(
                controller: addressController,
                decoration: InputDecoration(hintText: "Masukkan alamat Anda"),
              ),
              SizedBox(height: 16.0),
              Text("Nomor Telepon", style: TextStyle(fontSize: 16.0)),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(hintText: "Masukkan nomor telepon Anda"),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Menyimpan alamat dan nomor telepon
                  String address = addressController.text;
                  String phone = phoneController.text;
                  // Simpan data alamat dan telepon sesuai kebutuhan
                },
                child: Text("Simpan Data"),
              ),
              SizedBox(height: 16.0),
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
