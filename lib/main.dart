import 'package:ecommerce_jam_tangan/my_account.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_jam_tangan/splash_screen.dart'; // Sesuaikan dengan path SplashScreen Anda
import 'package:ecommerce_jam_tangan/history_page.dart'; // Halaman Riwayat
import 'package:ecommerce_jam_tangan/history_detail_page.dart'; // Halaman Detail Riwayat

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: 'AIzaSyA-_N_TdavPIxiBNF47NVnvx2Npc7pDWYY',
        appId: '1:862620032923:android:97b2cbb60ed98b6c4bcb3e',
        messagingSenderId: '862620032923',
        projectId: 'login-edd54',
        authDomain: 'ecommerce-jam-tangan.firebaseapp.com',
        storageBucket: 'ecommerce-jam-tangan.appspot.com',
      ),
    );
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // Halaman pertama yang akan ditampilkan setelah splash
      routes: {
        '/': (context) => const SplashScreen(),
        '/history': (context) => HistoryPage(),
        '/myaccount' : (context) => MyAccount() 
        // '/historyDetail': (context) => HistoryDetailPage(orderCode: 'HRSP-1'), // Sesuaikan dengan orderCode yang ingin ditampilkan
      },
    );
  }
}
