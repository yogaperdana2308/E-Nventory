import 'package:enventory/view/bottom_navigasi.dart';
import 'package:enventory/view/home_screen.dart';
import 'package:enventory/view/jual_barang.dart';
import 'package:enventory/view/login_screen.dart';
import 'package:enventory/view/register_screen.dart';
import 'package:enventory/view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Nventory',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
      ),

      // 🔹 GUNAKAN SplashScreen sebagai halaman awal
      // dan biarkan SplashScreen yang mengarahkan ke /home atau /login
      home: const SplashScreen(),

      // 🔹 Semua route didefinisikan dengan benar & konsisten
      routes: {
        '/register_screen': (context) => RegisterScreenProject(),
        '/login_screen': (context) => LoginScreenProject(),
        '/home': (context) => const HomePageProject(),
        '/bottom_navigasi': (context) => NavBottom(),
        '/jual': (context) => const JualBarang(),
        // '/edit_profile': (context) => EditProfilePage(),
      },
    );
  }
}
