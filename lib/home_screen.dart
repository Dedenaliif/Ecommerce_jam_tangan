import 'package:ecommerce_jam_tangan/custom_scaffold.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomScaffold(
      body : SingleChildScrollView(
      child: Center(child: Text("Home Screen")),
      ),
      showBottomNavbar: true,
      initialIndex: 0,
    );
  }
}