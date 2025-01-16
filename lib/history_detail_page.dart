import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class DetailHistoryPage extends StatelessWidget {
  final String orderId;

  DetailHistoryPage({required this.orderId});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String formatDate(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('dd MMM yyyy, HH:mm').format(dateTime);
  }

  String formatRupiah(int harga) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
    return formatter.format(harga);
  }

  @override
  Widget build(BuildContext context) {
    String? uid = FirebaseAuth.instance.currentUser?.uid; // Ambil UID pengguna

    if (uid == null) {
      return Scaffold(
        body: const Center(
          child: Text('Pengguna belum login.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Riwayat Pemesanan'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _firestore
            .collection('history')
            .doc(uid)
            .collection('orders')
            .doc(orderId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Data tidak ditemukan.'));
          }

          var order = snapshot.data!;
          List products = order['products']; // Pastikan field `products` ada di database

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kode Pesanan: ${order['orderCode']}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text('Tanggal: ${formatDate(order['orderDate'])}'),
                const SizedBox(height: 10),
                Text('Total Harga: ${formatRupiah(order['totalPrice'])}'),
                const SizedBox(height: 20),
                const Text(
                  'Detail Produk',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      var product = products[index];
                      return Card(
                        child: ListTile(
                          leading: Image.network(product['image']),
                          title: Text(product['productName']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Harga: ${formatRupiah(product['price'])}'),
                              Text('Jumlah: ${product['quantity']}'),
                              Text('Subtotal: ${formatRupiah(product['price'] * product['quantity'])}'),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
 }

}
