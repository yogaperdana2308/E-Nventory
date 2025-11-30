import 'package:enventory/Service/firebase.dart';
import 'package:enventory/view/bottom_navigasi.dart';
import 'package:enventory/widget/login_akun.dart';
import 'package:enventory/widget/login_button.dart';
import 'package:flutter/material.dart';

class LoginScreenFirebase extends StatefulWidget {
  const LoginScreenFirebase({super.key});

  @override
  State<LoginScreenFirebase> createState() => _LoginScreenFirebaseState();
}

class _LoginScreenFirebaseState extends State<LoginScreenFirebase> {
  bool box = false;
  bool obscurePass = true;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff6D94C5),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 56),
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 24),
                Image.asset(
                  'assets/images/logo_sementara1.png',
                  height: 90,
                  width: 90,
                ),
                const SizedBox(height: 12),
                const Text(
                  'e-Nventory',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.shopping_bag_outlined, color: Colors.white),
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

                const SizedBox(height: 24),

                // ===================== CARD LOGIN =====================
                Container(
                  height: 500,
                  width: 340,
                  decoration: BoxDecoration(
                    color: const Color(0xffF5EFE6),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.6),
                        spreadRadius: 3,
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          const Text(
                            'Welcome Back',
                            style: TextStyle(fontSize: 24, color: Colors.black),
                          ),
                          const Text('Sign in to continue'),
                          const SizedBox(height: 12),

                          const Text(
                            'Email',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),

                          LoginAkun(
                            controller: emailC,
                            input: 'your.email@gmail.com',
                            icon: Icons.email_outlined,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email tidak boleh kosong';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 8),
                          const Text(
                            'Password',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),

                          LoginAkun(
                            controller: passwordC,
                            icon: Icons.lock_outline,
                            isPassword: true,
                            input: 'Enter your password',
                            obscurePass: obscurePass,
                            lambang: const Icon(
                              Icons.visibility_off_rounded,
                              size: 16,
                            ),
                            whenPress: () {
                              setState(() {
                                obscurePass = !obscurePass;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password tidak boleh kosong';
                              }
                              if (value.length < 6) {
                                return 'Password minimal 6 karakter';
                              }
                              return null;
                            },
                          ),

                          // Row(
                          //   children: [
                          //     IconButton(
                          //       onPressed: () {
                          //         setState(() {
                          //           box = !box;
                          //         });
                          //       },
                          //       icon: Row(
                          //         children: [
                          //           Icon(
                          //             size: 18,
                          //             box
                          //                 ? Icons.check_box_rounded
                          //                 : Icons.check_box_outline_blank,
                          //           ),
                          //           const Text(
                          //             'Remember me',
                          //             style: TextStyle(fontSize: 12),
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //     const Spacer(),
                          //     TextButton(
                          //       onPressed: () {},
                          //       child: const Text(
                          //         'Forgot Password ?',
                          //         style: TextStyle(
                          //           fontSize: 12,
                          //           fontWeight: FontWeight.bold,
                          //           color: Color(0xFF4D81E7),
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          SizedBox(height: 24),

                          // ===================== BUTTON LOGIN =====================
                          LoginButton(
                            onPress: () async {
                              if (_formKey.currentState!.validate()) {
                                final user = await firebaseService.loginUser(
                                  email: emailC.text.trim(),
                                  password: passwordC.text.trim(),
                                );

                                if (user != null) {
                                  // Login berhasil → masuk ke HomePage
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => NavBottom(),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Email atau password tidak sesuai',
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                            label: 'Login',
                            isLogin: true,
                          ),

                          const SizedBox(height: 24),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Don’t have an account?',
                                style: TextStyle(color: Colors.black),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/register_screen_firebase',
                                  );
                                },
                                child: const Text(
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
