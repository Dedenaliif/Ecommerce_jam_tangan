import 'package:flutter/material.dart';
import 'package:ecommerce_jam_tangan/custom_scaffold.dart';
import 'package:ecommerce_jam_tangan/sign_in.dart';
import 'package:ecommerce_jam_tangan/sign_up.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: SingleChildScrollView( // Membungkus konten dalam SingleChildScrollView untuk bisa digulir
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height, // Memastikan konten memenuhi tinggi layar
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage('images/background.jpg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.7), BlendMode.darken),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Memastikan kolom terpusat secara vertikal
            children: [
              const SizedBox(height: 100), // Jarak atas untuk logo
              Image.asset(
                'images/logo.jpg',
                height: 175,
              ),
              const SizedBox(height: 50), // Jarak antara logo dan tombol
              
              // Tombol Sign Up
              Button(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const SignUp()),
                  );
                },
                text: 'SIGN UP',
              ),
              const SizedBox(height: 45), // Spasi antar tombol

              // Tombol Sign In
              Button(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const SignIn()),
                  );
                },
                text: 'SIGN IN',
              ),
              const SizedBox(height: 50), // Spasi bawah agar tidak terlalu rapat
            ],
          ),
        ),
      ),
      showBottomNavbar: false, // Hilangkan BottomNavbar di halaman login
    );
  }
}

class Button extends StatelessWidget {
  final String text;
  final void Function() onPressed;

  const Button({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 200,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.greenAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Color.fromARGB(255, 94, 92, 92),
          ),
        ),
      ),
    );
  }
}
