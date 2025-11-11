import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:enventory/view/home_screen.dart';
import 'package:enventory/view/penjualan_screen.dart';
import 'package:enventory/view/setting_screen.dart';
import 'package:enventory/view/stock_screen.dart';
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
    HomePageProject(),
    ListPenjualanInventory(),
    ListStock(),
    SettingsPage(),
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
