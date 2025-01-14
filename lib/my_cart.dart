import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecommerce_jam_tangan/custom_scaffold.dart';
import 'package:intl/intl.dart';

class MyCart extends StatefulWidget {
  const MyCart({super.key});

  @override
  State<MyCart> createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String formatRupiah(int harga) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
    return formatter.format(harga);
  }

  // Fungsi untuk menambah quantity
  Future<void> _increaseQuantity(String productId, int quantity) async {
    await _firestore.collection('carts').doc(_auth.currentUser?.uid).collection('items').doc(productId).update({
      'quantity': quantity + 1,
    });
  }

  // Fungsi untuk mengurangi quantity
  Future<void> _decreaseQuantity(String productId, int quantity) async {
    if (quantity > 1) {
      await _firestore.collection('carts').doc(_auth.currentUser?.uid).collection('items').doc(productId).update({
        'quantity': quantity - 1,
      });
    }
  }

  // Fungsi untuk menghapus item
  Future<void> _removeItem(String productId) async {
    await _firestore.collection('carts').doc(_auth.currentUser?.uid).collection('items').doc(productId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('carts').doc(_auth.currentUser?.uid).collection('items').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Keranjang Anda kosong.'));
          }

          var cartItems = snapshot.data!.docs;
          double totalPrice = 0.0;

          for (var item in cartItems) {
            totalPrice += (item['pricing'] as double) * (item['quantity'] as int);
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Keranjang Belanja Anda',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    var item = cartItems[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: ListTile(
                        leading: Image.network(item['image'], width: 50, height: 50, fit: BoxFit.cover),
                        title: Text(item['title']),
                        subtitle: Text(formatRupiah(item['pricing'])),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () => _decreaseQuantity(item.id, item['quantity']),
                            ),
                            Text('${item['quantity']}'),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () => _increaseQuantity(item.id, item['quantity']),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => _removeItem(item.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Total: ${formatRupiah(totalPrice.toInt())}',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Function to go to the checkout page
                  },
                  child: const Text('Checkout'),
                ),
              ),
              SizedBox(height: 16),  // Add space between the button and the bottom navbar
            ],
          );
        },
      ),
      showBottomNavbar: true,
      initialIndex: 1,  // MyCart is at index 1
    );
  }
}
