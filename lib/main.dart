import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_jam_tangan/splash_screen.dart'; // Pastikan path sesuai dengan struktur folder Anda.

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Periksa apakah Firebase sudah diinisialisasi
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
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
