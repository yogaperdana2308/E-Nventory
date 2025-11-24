import 'package:animate_do/animate_do.dart';
import 'package:enventory/preferences/preferencesHandler.dart';
import 'package:enventory/view/bottom_navigasi.dart';
import 'package:enventory/view/login_screen_copy.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    isLoginFunction();
  }

  isLoginFunction() async {
    // Tambah sedikit delay agar animasi dan loading bar sempat tampil
    await Future.delayed(const Duration(seconds: 3));
    var isLogin = await PreferenceHandler.getLogin();
    if (isLogin != null && isLogin == true) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const NavBottom()),
        (route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreenFirebase()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 131, 179, 238),
              Color(0xff6D94C5),
              Color.fromARGB(255, 103, 148, 204),
            ],
          ),
        ),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ZoomIn(
              duration: const Duration(milliseconds: 3000),
              child: CircleAvatar(
                radius: 100,
                backgroundImage: const AssetImage(
                  "assets/images/logo_sementara1.png",
                ),
              ),
            ),

            const SizedBox(height: 72),

            // Animasi loading bar muncul dari bawah
            FadeInUp(
              duration: const Duration(milliseconds: 1200),
              child: Column(
                children: const [
                  SizedBox(
                    width: 200,
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.white24,
                      color: Colors.white,
                      minHeight: 5,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Loading...",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
