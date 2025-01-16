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
    await _firestore
        .collection('carts')
        .doc(_auth.currentUser?.uid)
        .collection('items')
        .doc(productId)
        .update({
      'quantity': quantity + 1,
    });
  }

  // Fungsi untuk mengurangi quantity
  Future<void> _decreaseQuantity(String productId, int quantity) async {
    if (quantity > 1) {
      await _firestore
          .collection('carts')
          .doc(_auth.currentUser?.uid)
          .collection('items')
          .doc(productId)
          .update({
        'quantity': quantity - 1,
      });
    }
  }

  // Fungsi untuk menghapus item
  Future<void> _removeItem(String productId) async {
    await _firestore
        .collection('carts')
        .doc(_auth.currentUser?.uid)
        .collection('items')
        .doc(productId)
        .delete();
  }

  // Fungsi untuk checkout dan generate orderCode
  Future<void> _checkout() async {
    try {
      var userId = _auth.currentUser?.uid;
      if (userId == null) {
        // Jika tidak ada pengguna yang login, tampilkan pesan kesalahan
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Anda harus login terlebih dahulu.')),
        );
        return;
      }

      // Ambil data pengguna untuk memastikan apakah alamat dan nomor telepon sudah terisi
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();

      // Cek apakah alamat dan nomor telepon sudah diisi
      if (userDoc.exists) {
        String? address = userDoc['address'];
        String? phone = userDoc['phone'];

        // Validasi jika alamat atau nomor telepon kosong
        if (address == null || phone == null || address.isEmpty || phone.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Silakan lengkapi alamat dan nomor telepon Anda di halaman Akun')),
          );
          Navigator.pushNamed(context, '/myaccount');  // Arahkan ke halaman MyAccount
          return;
        }
      } else {
        // Jika dokumen pengguna tidak ditemukan, tampilkan pesan kesalahan
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data pengguna tidak ditemukan.')),
        );
        return;
      }

      var cartRef = _firestore.collection('carts').doc(userId).collection('items');
      var historyRef = _firestore.collection('history').doc(userId).collection('orders');

      // Ambil semua item dari keranjang
      var cartItems = await cartRef.get();

      if (cartItems.docs.isEmpty) {
        // Keranjang kosong
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Keranjang Anda kosong.')),
        );
        return;
      }

      // Hitung total harga
      int totalPrice = 0;
      List<Map<String, dynamic>> products = [];

      for (var item in cartItems.docs) {
        int price = item['pricing'];
        int quantity = item['quantity'];
        totalPrice += price * quantity;

        // Simpan produk ke dalam list
        products.add({
          'productName': item['title'],
          'price': price,
          'quantity': quantity,
          'image': item['image'],
        });
      }

      // Generate order code
      var lastOrderQuery = await historyRef.orderBy('orderCode', descending: true).limit(1).get();
      int nextOrderNumber = 1; // Default order number if no previous orders exist

      if (lastOrderQuery.docs.isNotEmpty) {
        String lastOrderCode = lastOrderQuery.docs.first['orderCode'];
        nextOrderNumber = int.parse(lastOrderCode.split('-')[1]) + 1;
      }

      String orderCode = 'HRSP-$nextOrderNumber';

      // Simpan ke Firestore
      await historyRef.add({
        'orderCode': orderCode,
        'orderDate': Timestamp.now(),
        'totalPrice': totalPrice,
        'products': products, // Simpan semua produk sebagai array
      });

      // Hapus item dari keranjang setelah checkout
      for (var doc in cartItems.docs) {
        await doc.reference.delete();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pesanan berhasil dibuat dengan kode $orderCode.')),
      );

      // Arahkan pengguna ke halaman History
      Navigator.pushNamed(context, '/history');
    } catch (e) {
      print('Checkout Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan saat checkout: $e')),
      );
    }
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
            totalPrice += (item['pricing'] as int) * (item['quantity'] as int);
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
                  onPressed: _checkout, // Checkout function
                  child: const Text('Checkout'),
                ),
              ),
              SizedBox(height: 16), // Add space between the button and the bottom navbar
            ],
          );
        },
      ),
      showBottomNavbar: true,
      initialIndex: 1, // MyCart is at index 1
    );
  }
}
