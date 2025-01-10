import 'package:ecommerce_jam_tangan/custom_scaffold.dart';
import 'package:flutter/material.dart';

class Food extends StatelessWidget {
  const Food({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomScaffold(
      body : SingleChildScrollView(
      child: Center(child: Text("Food"))
      ),
      showBottomNavbar: true,
      initialIndex: 1,
    );
  }
}