import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:enventory/view/home_screen_firebase.dart';
import 'package:enventory/view/penjualan_screen_firebase.dart';
import 'package:enventory/view/setting_screen%20firebase.dart';
import 'package:enventory/view/stock_screen%20firebase.dart';
import 'package:flutter/material.dart';

class NavBottom extends StatefulWidget {
  const NavBottom({super.key});

  @override
  State<NavBottom> createState() => _NavBottomState();
}

class _NavBottomState extends State<NavBottom> {
  @override
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = [
    HomePageProjectFirebase(),
    ListPenjualanInventoryFirebase(),
    StockScreenfirebase(),
    SettingScreenFirebase(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions[_selectedIndex],

      bottomNavigationBar: CurvedNavigationBar(
        animationCurve: Easing.legacyDecelerate,

        backgroundColor: Color(0xff6D94C5),
        items: <Widget>[
          Icon(Icons.home_outlined, color: Colors.blue, size: 24),
          Icon(Icons.sell_outlined, color: Colors.blue, size: 24),
          Icon(Icons.shopping_cart_outlined, color: Colors.blue, size: 24),
          Icon(Icons.settings_outlined, color: Colors.blue, size: 24),
        ],
        onTap: (index) {
          print(index);
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
