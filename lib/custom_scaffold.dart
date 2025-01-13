import 'package:ecommerce_jam_tangan/bottom_navbar.dart';
import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  final Widget body;
  final bool showBottomNavbar;
  final int initialIndex;
  const CustomScaffold({
    super.key,
    required this.body,
    this.showBottomNavbar = true,
    this.initialIndex = 0
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      bottomNavigationBar: 
        showBottomNavbar ? BottomNavbar(initialIndex: initialIndex) : null,
    );
  }
}