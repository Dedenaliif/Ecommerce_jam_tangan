import 'package:ecommerce_jam_tangan/custom_scaffold.dart';
import 'package:flutter/material.dart';

class MyAccount extends StatelessWidget {
  const MyAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomScaffold(
      body : SingleChildScrollView(
      child: Center(child: Text("My Account")),
      ),
      showBottomNavbar: true,
      initialIndex: 2,
    );
  }
}