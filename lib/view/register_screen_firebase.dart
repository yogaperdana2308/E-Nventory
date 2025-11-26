import 'package:enventory/Service/firebase.dart';
import 'package:enventory/view/login_screen_firebase.dart';
import 'package:enventory/widget/login_button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterScreenFirebase extends StatefulWidget {
  const RegisterScreenFirebase({super.key});
  static const id = "/register";

  @override
  State<RegisterScreenFirebase> createState() => _RegisterScreenFirebaseState();
}

class _RegisterScreenFirebaseState extends State<RegisterScreenFirebase> {
  final TextEditingController usernameC = TextEditingController();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isVisibility = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Stack(children: [buildBackground(), buildLayer()]));
  }

  // 🌈 ============= UI FORM =============
  SafeArea buildLayer() {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 24),
            Center(
              child: Container(
                height: 700,
                width: 360,
                decoration: BoxDecoration(
                  color: const Color(0xffF5EFE6).withOpacity(0.9),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 4,
                      blurRadius: 10,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 24),

                        // LOGO
                        SizedBox(
                          height: 72,
                          width: 72,
                          child: Image.asset(
                            "assets/images/logo_sementara1.png",
                          ),
                        ),

                        const SizedBox(height: 12),

                        const Text(
                          'e-Nventory',
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),

                        const SizedBox(height: 36),
                        const Text(
                          "Welcome",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text("Register to access your account"),

                        const SizedBox(height: 12),

                        // USERNAME
                        buildTitle("Username"),
                        const SizedBox(height: 12),
                        buildTextField(
                          hintText: "Enter your username",
                          controller: usernameC,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Username tidak boleh kosong";
                            }
                            return null;
                          },
                        ),

                        // EMAIL
                        buildTitle("Email Address"),
                        const SizedBox(height: 12),
                        buildTextField(
                          hintText: "Enter your email",
                          controller: emailC,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Email tidak boleh kosong";
                            }
                            if (!value.contains('@')) {
                              return "Email tidak valid";
                            }
                            return null;
                          },
                        ),

                        // PASSWORD
                        buildTitle("Password"),
                        const SizedBox(height: 12),
                        buildTextField(
                          hintText: "Enter your password",
                          isPassword: true,
                          controller: passwordC,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Password tidak boleh kosong";
                            }
                            if (value.length < 6) {
                              return "Password minimal 6 karakter";
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 24),

                        // 🔥 BUTTON REGISTER (INI BAGIAN PALING PENTING)
                        LoginButton(
                          isLogin: true,
                          label: "Register",
                          onPress: () async {
                            if (_formKey.currentState!.validate()) {
                              // 🔥 Jalankan register Firebase
                              try {
                                final newUser = await firebaseService
                                    .registerUser(
                                      email: emailC.text.trim(),
                                      username: usernameC.text.trim(),
                                      password: passwordC.text.trim(),
                                    );

                                Fluttertoast.showToast(
                                  msg: "Register berhasil!",
                                );

                                // Pindah ke login
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => LoginScreenFirebase(),
                                  ),
                                );
                              } catch (e) {
                                Fluttertoast.showToast(
                                  msg: "Register gagal: $e",
                                );
                              }
                            }
                          },
                        ),

                        const SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Have an account?"),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => LoginScreenFirebase(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Sign In",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
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
            ),
          ],
        ),
      ),
    );
  }

  // BACKGROUND
  Container buildBackground() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: const Color(0xff6D94C5),
    );
  }

  // TEXT FIELD INPUT
  TextFormField buildTextField({
    required String hintText,
    bool isPassword = false,
    TextEditingController? controller,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: isPassword ? !isVisibility : false,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(70)),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isVisibility ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    isVisibility = !isVisibility;
                  });
                },
              )
            : null,
      ),
    );
  }

  Widget buildTitle(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
