import 'package:ecommerce_jam_tangan/history_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatelessWidget {
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
        title: const Text('Riwayat Pemesanan'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('history').doc(uid).collection('orders').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Tidak ada riwayat pemesanan.'));
          }

          var orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              var order = orders[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text('Kode Pesanan: ${order['orderCode']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tanggal: ${formatDate(order['orderDate'])}'),
                      Text('Total: ${formatRupiah(order['totalPrice'])}'),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailHistoryPage(orderId: order.id),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
