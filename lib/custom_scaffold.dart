import 'package:flutter/material.dart';
import 'bottom_navbar.dart';

class CustomScaffold extends StatelessWidget {
  final Widget body;
  final bool showBottomNavbar;
  final int initialIndex;

  const CustomScaffold({super.key, 
    required this.body,
    this.showBottomNavbar = true, // Default to true to show BottomNavbar
    this.initialIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      bottomNavigationBar: showBottomNavbar
          ? BottomNavbar(initialIndex: initialIndex)
          : null,
    );
  }
}

