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
        backgroundColor: Color(0xffB87C4C),
        items: <Widget>[
          Icon(Icons.home_outlined, color: Color(0xffB87C4C), size: 24),
          Icon(
            Icons.shopping_cart_outlined,
            color: Color(0xffB87C4C),
            size: 24,
          ),
          Icon(Icons.list_alt_outlined, color: Color(0xffB87C4C), size: 24),
          Icon(Icons.settings_outlined, color: Color(0xffB87C4C), size: 24),
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
