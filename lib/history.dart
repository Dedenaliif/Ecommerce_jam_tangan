import 'package:flutter/material.dart';

class History extends StatelessWidget {
  const History({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("History Transaksi")),
      body: Center(
        child: Text("History Transaksi Anda"),
      ),
    );
  }
}
