import 'package:ecommerce_jam_tangan/custom_scaffold.dart';
import 'package:ecommerce_jam_tangan/my_cart.dart';
import 'package:ecommerce_jam_tangan/models/product.dart';
import 'package:flutter/material.dart';

class ProductDetail extends StatelessWidget {
  final Product product;

  ProductDetail({required this.product});

  // Simulasi keranjang
  static List<Product> cart = [];

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: SingleChildScrollView( // Gunakan SingleChildScrollView agar konten bisa digulir
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(product.images[0]),
              SizedBox(height: 16.0),
              Text(
                product.title,
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Text(
                product.pricing,
                style: TextStyle(fontSize: 18.0, color: Colors.grey),
              ),
              SizedBox(height: 16.0),
              Text(
                product.description,
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      cart.add(product); // Tambahkan produk ke keranjang
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyCart()), // Navigasi ke MyCart
                      );
                    },
                    child: Text('Tambahkan ke Keranjang'),
                  ),
                  SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      // Aksi untuk Beli Sekarang (mungkin bisa mengarah ke halaman pembayaran)
                    },
                    child: Text('Beli Sekarang'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      showBottomNavbar: true, // Tampilkan BottomNavbar di halaman ini
    );
  }
}
