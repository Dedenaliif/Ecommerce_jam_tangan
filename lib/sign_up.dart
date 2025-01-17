import 'package:ecommerce_jam_tangan/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
       onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
          currentFocus.focusedChild?.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(), 
            icon: Icon(
              Icons.arrow_back, 
              color: Colors.black,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 110, 20, 110),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Create Account', style: TextStyle(fontSize: 32, fontWeight:  FontWeight.bold)),
                  const SizedBox(height: 40),
                  TextFields(
                    label: 'FULL NAME', 
                    icon: Icon(Icons.person_2_outlined), 
                    controller: _nameController,
                  ),
                  const SizedBox(height: 10),
                  TextFields(
                    label: 'EMAIL', 
                    icon: Icon(Icons.email_outlined), 
                    controller: _emailController,
                  ),
                  const SizedBox(height: 10),
                  TextFields(
                    label: 'PASSWORD',
                    secureText: true, 
                    icon: Icon(Icons.lock_outline), 
                    controller: _passwordController,
                  ),
                  const SizedBox(height: 10),
                  TextFields(
                    label: 'Confirm Password',
                    secureText: true,
                    icon: Icon(Icons.lock_outline), 
                    controller: _confirmPasswordController,
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      child: ElevatedButton(
                        onPressed: () async {
                          // Sign up using Firebase Auth
                          try {
                            if (_passwordController.text == _confirmPasswordController.text) {
                              UserCredential userCredential = await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                    email: _emailController.text, 
                                    password: _passwordController.text,
                                  );
                              
                              // Save user data to Firestore
                              User? user = userCredential.user;
                              if (user != null) {
                                await _firestore.collection('users').doc(user.uid).set({
                                  'email': _emailController.text,
                                  'username': _nameController.text, // Save the full name as username
                                  'phone': '', // Placeholder for phone number
                                  'address': '', // Placeholder for address
                                });

                                // Navigate to sign-in page
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignIn()));
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Password and Confirm Password do not match"))
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Error during sign-up: $e"))
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape : RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          )
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('SIGN UP'),
                            SizedBox(width: 5),
                            Icon(Icons.arrow_forward, size: 24.0)
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Already have an account?", style: TextStyle(fontFamily: 'SFUIDisplay', color: Colors.black, fontSize: 15)),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignIn()));
                },
                child: Text('Sign In', style: TextStyle(fontFamily: 'SFUIDisplay', color: Colors.green, fontSize: 15)),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TextFields extends StatelessWidget {
  final Icon icon;
  final String label;
  final TextEditingController controller;
  final bool secureText;

  TextFields({super.key, required this.icon, required this.label, required this.controller, this.secureText = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        controller: controller,
        obscureText: secureText,
        style: TextStyle(color: Colors.black, fontFamily: 'SFUIDisplay'),
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: label,
          prefixIcon: icon,
          labelStyle: TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}
