import 'package:enventory/view/bottom_navigasi.dart';
import 'package:enventory/view/home_screen.dart';
import 'package:enventory/view/login_screen.dart';
import 'package:enventory/view/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  final prefs = await SharedPreferences.getInstance();
  final bool isLogin = prefs.getBool('isLogin') ?? false;
  runApp(MyApp(isLogin: isLogin));
}

class MyApp extends StatelessWidget {
  final bool isLogin;
  const MyApp({super.key, required this.isLogin});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/register_screen': (context) => RegisterScreenProject(),
        '/home_page': (context) => HomePageProject(),
        '/login_screen': (context) => LoginScreenProject(),
        '/bottom_navigasi': (context) => NavBottom(),
      },
      title: 'E-Nventory',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
      ),
      home: isLogin ? NavBottom() : LoginScreenProject(),
    );
  }
}
