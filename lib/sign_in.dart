import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

TextEditingController _emailAddressController = TextEditingController();
TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);
        if(!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null){
          currentFocus.focusedChild?.unfocus();
        }
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 110, 20, 110),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Login',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)
              ),
              const SizedBox(height: 10)
              Text(
                'Please sign in to continue.',
                style: const TextStyle(fontSize: 20,Colors.grey,
              ),
              const SizedBox(height: 40)
              TextFormField(
                controller: _emailAddressController,
                style: TextStyle(color: color.black, fontFamily: 'SFUIDisplay'),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'EMAIL',
                  prefixIcon: Icon(icons.email_outlined),
                  labelStyle: const TextStyle(fontSize: 12),
                ),
              )
              const SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                style: TextStyle(color: color.black, fontFamily: 'SFUIDisplay'),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'PASSWORD',
                  prefixIcon: Icon(icons.lock_outlined),
                  suffixIcon: TextButton(
                    onPressed: (){},
                    child: Text(
                      'FORGOT', 
                      style: TextStyle(color: colors.green),
                    ),
                  ),
                  labelStyle: const TextStyle(fontSize: 12),
                ),
              )
              const SizedBox(height: 10),
              Align(
                alignment: Aligment,centerRight,
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: (){},
                    style: ElevatedButton.styleFrom(
                      primary; Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius; borderRadius.circular(30.0)
                      )
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Login'),
                        const SizedBox(width: 5),
                        Icon(Icon.arrow_forward,size: 24.0)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: SizedBox(
          height: 60,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              "Dont have an account?"
               style: TextStyle(fontFamily: 'SFUIDisplay', color: colors.black, fontSize: 15),
               ),
               TextButton(
                onPressed: (){}, 
                child: Text(
                  'Sign Up', 
                  style: TextStyle(
                    fontFamily: 'SFUIDisplay',
                    color: colors,green,
                    fontSize: 15),
                    ))
          ],),
        ),
      ),
    );
  }
}