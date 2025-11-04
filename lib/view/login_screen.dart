import 'package:enventory/Database/db_helper.dart';
import 'package:enventory/widget/loginAkun.dart';
import 'package:enventory/widget/loginButton.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreenProject extends StatefulWidget {
  const LoginScreenProject({super.key});

  @override
  State<LoginScreenProject> createState() => _LoginScreenProjectState();
}

class _LoginScreenProjectState extends State<LoginScreenProject> {
  bool box = false;
  bool obscurePass = true;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();
  Future<void> saveUserSession(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
  }

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
                Image.asset(
                  'assets/images/LogoProject.png',
                  height: 120,
                  width: 120,
                ),
                const Text(
                  'e-Nventory',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 20),
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

                // ✅ Form login
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
                      key: _formKey, // <-- Tambahkan form key
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

                          loginAkun(
                            controller: emailC,
                            input: 'your.email@gmail.com',
                            icon: Icons.email_outlined,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email tidak boleh kosong';
                              }
                              final emailRegex = RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              );
                              if (!emailRegex.hasMatch(value)) {
                                return 'Format email tidak valid';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 8),
                          const Text(
                            'Password',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),

                          loginAkun(
                            controller: passwordC,
                            icon: Icons.lock_outline,
                            isPassword: true,
                            input: 'Enter your password',
                            lambang: const Icon(
                              Icons.visibility_off_rounded,
                              size: 16,
                            ),
                            obscurePass: obscurePass,
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

                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    box = !box;
                                  });
                                },
                                icon: Row(
                                  children: [
                                    Icon(
                                      size: 18,
                                      box
                                          ? Icons.check_box_rounded
                                          : Icons.check_box_outline_blank,
                                    ),
                                    const Text(
                                      'Remember me',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: () {},
                                child: const Text(
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
                            onPress: () async {
                              if (_formKey.currentState!.validate()) {
                                final data = await DbHelper.loginUser(
                                  email: emailC.text,
                                  password: passwordC.text,
                                );
                                if (data != null) {
                                  await saveUserSession(emailC.text);
                                  Navigator.pushNamed(
                                    context,
                                    '/bottom_navigasi',
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
                                    '/register_screen',
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
