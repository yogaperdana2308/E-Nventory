import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:enventory/view/home_page.dart';
import 'package:enventory/view/listPenjualan_inventory.dart';
import 'package:enventory/view/listStock.dart';
import 'package:enventory/view/setting_page.dart';
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
    ListpenjualanInventory(),
    ListStock(),
    SettingsPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions[_selectedIndex],

      bottomNavigationBar: CurvedNavigationBar(
        animationCurve: Easing.legacyDecelerate,
        backgroundColor: Color(0xFF00BCD4).withOpacity(0.04),
        items: <Widget>[
          Icon(Icons.home_outlined, color: Color(0xFF00BCD4), size: 24),
          Icon(
            Icons.shopping_cart_outlined,
            color: Color(0xFF00BCD4),
            size: 24,
          ),
          Icon(Icons.outbox_outlined, color: Color(0xFF00BCD4), size: 24),
          Icon(Icons.settings_outlined, color: Color(0xFF00BCD4), size: 24),
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
