import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecommerce_jam_tangan/models/product.dart';
import 'package:ecommerce_jam_tangan/custom_scaffold.dart';
import 'package:intl/intl.dart';

String formatRupiah(double harga) {
  final NumberFormat currencyFormatter = NumberFormat.simpleCurrency(locale: 'id_ID');
  return currencyFormatter.format(harga);
}

class ProductDetail extends StatefulWidget {
  final Product product;

  const ProductDetail({required this.product, super.key});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _addToCart(Product product) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        var cartItem = await _firestore
            .collection('carts')
            .doc(user.uid)
            .collection('items')
            .where('title', isEqualTo: product.title)
            .get();

        if (cartItem.docs.isEmpty) {
          await _firestore.collection('carts').doc(user.uid).collection('items').add({
            'title': product.title,
            'pricing': product.pricing,
            'description': product.description,
            'image': product.images[0],
            'quantity': 1,  // Set default quantity to 1
          });
        } else {
          await _firestore
              .collection('carts')
              .doc(user.uid)
              .collection('items')
              .doc(cartItem.docs.first.id)
              .update({
            'quantity': cartItem.docs.first['quantity'] + 1,  // Increase quantity by 1
          });
        }

        // Show a success SnackBar when the item is added
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${product.title} telah ditambahkan ke keranjang!')),
        );
      } else {
        print('User not logged in');
      }
    } catch (e) {
      print('Failed to add to cart: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(widget.product.images[0]),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.title,
                      style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.product.description,
                      style: const TextStyle(fontSize: 16.0, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      formatRupiah(widget.product.pricing),
                      style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => _addToCart(widget.product),
                      child: const Text('Add to Cart'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
