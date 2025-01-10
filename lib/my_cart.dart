import 'package:ecommerce_jam_tangan/custom_scaffold.dart';
import 'package:flutter/material.dart';

class MyCart extends StatelessWidget {
  const MyCart({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomScaffold(
      body : SingleChildScrollView(
      child: Center(child: Text("My Cart")),
      ),
      showBottomNavbar: true,
      initialIndex: 3,
    );
  }
}