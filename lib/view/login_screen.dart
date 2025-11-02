import 'package:enventory/widget/loginAkun.dart';
import 'package:enventory/widget/loginButton.dart';
import 'package:flutter/material.dart';

class LoginScreenProject extends StatefulWidget {
  const LoginScreenProject({super.key});

  @override
  State<LoginScreenProject> createState() => _LoginScreenProjectState();
}

class _LoginScreenProjectState extends State<LoginScreenProject> {
  bool box = false;
  final WinterInterFont = 'Inter';
  bool obscurePass = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff6D94C5),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(top: 56),
          child: Center(
            child: Column(
              // spacing: 12,
              children: [
                Image.asset(
                  'assets/images/LogoProject.png',
                  height: 120,
                  width: 120,
                ),
                Text(
                  'e-Nventory',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontFamily: 'Inter',
                    // fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Icon(
                      Icons.shopping_bag_outlined,
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Make Your Inventory Smartly',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Container(
                  height: 500,
                  width: 340,
                  decoration: BoxDecoration(
                    color: Color(0xffF5EFE6),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(
                          255,
                          109,
                          109,
                          109,
                        ).withOpacity(0.6),
                        spreadRadius: 3,
                        blurRadius: 20,
                        // offset: Offset(3, 1),
                      ),
                    ],

                    // gradient: LinearGradient(
                    //   begin: Alignment.topCenter,
                    //   end: Alignment.bottomCenter,
                    //   colors: [Colors.red, Colors.black, Colors.blue],
                    // ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      spacing: 4,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16),
                        Text(
                          'Welcome Back',
                          style: TextStyle(fontSize: 24, color: Colors.black),
                        ),
                        Text('Sign in to continue'),

                        SizedBox(height: 12),
                        Text(
                          'Email',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        loginAkun(
                          input: 'your.email@.gmail.com',
                          icon: Icons.email_outlined,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Password',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        loginAkun(
                          icon: Icons.lock_outline,
                          isPassword: true,
                          input: 'Enter your password',
                          lambang: Icon(Icons.visibility_off_rounded, size: 16),
                          obscurePass: obscurePass,
                          whenPress: () {
                            setState(() {
                              obscurePass = !obscurePass;
                            });
                          },
                        ),
                        // width: 100,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              child: IconButton(
                                onPressed: () {
                                  box = !box;
                                  setState(() {});
                                },
                                icon: Row(
                                  children: [
                                    Icon(
                                      size: 18,
                                      box
                                          ? Icons.check_box_rounded
                                          : Icons.check_box_outline_blank,
                                    ),
                                    Text(
                                      'Remember me',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Spacer(),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'Forgot Password ?',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4D81E7),
                                ),
                              ),
                            ),
                          ],
                        ),

                        LoginButton(
                          onPress: () {
                            Navigator.pushNamed(context, '/home_page.dart');
                          },
                          label: 'Login',
                          isLogin: true,
                        ),
                        // LoginButton(
                        //   onPress: () {
                        //     Navigator.pushNamed(
                        //       context,
                        //       'bottom_navigasi.dart',
                        //     );
                        //   },
                        //   label: 'Continue as a guest',
                        //   isLogin: false,
                        // ),
                        SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Dont have an account?',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/register_screen',
                                );
                              },
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Color(0xFF4D81E7),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
