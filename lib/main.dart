import 'package:enventory/view/botton_navigasi.dart';
import 'package:enventory/view/home_page.dart';
import 'package:enventory/view/login_screen.dart';
import 'package:enventory/view/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  await initializeDateFormatting('id_ID', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/register_screen': (context) => RegisterScreenProject(),
        '/home_page': (context) => HomePageProject(),
        '/login_screen': (context) => LoginScreenProject(),
      },
      title: 'E-Nventory',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
      ),
      home: NavBottom(),
    );
  }
}
