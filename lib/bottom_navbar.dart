import 'package:ecommerce_jam_tangan/food.dart';
import 'package:ecommerce_jam_tangan/home_screen.dart';
import 'package:ecommerce_jam_tangan/my_account.dart';
import 'package:ecommerce_jam_tangan/my_cart.dart';
import 'package:flutter/material.dart';

class BottomNavbar extends StatefulWidget {
  final int initialIndex;
  const BottomNavbar({super.key, required this.initialIndex});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {

  var _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        navigateToRoute(context, '/home', HomeScreen());
        break;
      case 1:
        navigateToRoute(context, '/food', Food());
        break;
      case 2:
        navigateToRoute(context, '/myaccount', MyAccount());
        break;
      case 3:
        navigateToRoute(context, '/mycart', MyCart());
        break;
    }
  }

  void navigateToRoute(context, String routeName, Widget screen) {
    final String? currentRouteName = ModalRoute.of(context)?.settings.name;
    bool routeExists = currentRouteName == routeName;

    if (routeExists) {
      Navigator.popUntil(context, ModalRoute.withName(routeName));
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => screen,
          settings : RouteSettings(name: routeName),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex : _selectedIndex,
      type: BottomNavigationBarType.fixed,
      onTap: _onItemTapped,
      backgroundColor: Colors.white,
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.black, 
      items : <BottomNavigationBarItem> [
      BottomNavigationBarItem(
        icon: Icon(
          Icons.home_outlined,
          color: _selectedIndex == 0 ? Colors.green : Colors.black,
        ),
        label: 'Home'
      ),
      BottomNavigationBarItem(
        icon: Icon(
        Icons.food_bank_outlined,
        color: _selectedIndex == 1 ? Colors.green : Colors.black,
        ),
        label: 'Foods'
      ),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.person_2_outlined,
          color: _selectedIndex == 2 ? Colors.green : Colors.black,
        ),
        label: 'My Account'
      ),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.shopping_cart_outlined,
          color: _selectedIndex == 3 ? Colors.green : Colors.black,
        ),
        label: 'My Cart'
      )
    ]);
  }
}