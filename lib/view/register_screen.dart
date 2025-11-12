import 'package:enventory/database/db_helper.dart';
import 'package:enventory/model/user_model.dart';
import 'package:enventory/view/login_screen.dart';
import 'package:enventory/widget/login_button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterScreenProject extends StatefulWidget {
  const RegisterScreenProject({super.key});
  static const id = "/register";
  @override
  State<RegisterScreenProject> createState() => _RegisterScreenProjectState();
}

class _RegisterScreenProjectState extends State<RegisterScreenProject> {
  final TextEditingController usernameC = TextEditingController();
  final TextEditingController nomorhpC = TextEditingController();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();

  bool isVisibility = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Stack(children: [buildBackground(), buildLayer()]));
  }

  final _formKey = GlobalKey<FormState>();
  SafeArea buildLayer() {
    return SafeArea(
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            SizedBox(height: 24),
            Center(
              child: Container(
                height: 700,
                width: 360,
                decoration: BoxDecoration(
                  color: Color(0xffF5EFE6).withOpacity(0.9),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(
                        255,
                        109,
                        109,
                        109,
                      ).withOpacity(0.8),
                      spreadRadius: 6,
                      blurRadius: 10,
                      // offset: Offset(3, 1),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 24),
                          SizedBox(
                            height: 72,
                            width: 72,
                            child: Image(
                              image: AssetImage(
                                'assets/images/logo_sementara1.png',
                              ),
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'e-Nventory',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontFamily: 'Inter',
                            ),
                          ),
                          SizedBox(height: 36),
                          Text(
                            "Welcome",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text("Register to access your account"),
                          height(12),
                          buildTitle("Username"),
                          height(12),
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

                          buildTitle("No. HP"),
                          height(12),
                          buildTextField(
                            hintText: "No. HP",
                            controller: nomorhpC,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "No. HP tidak boleh kosong";
                              } else if (value.length < 6) {
                                return "No. HP minimal 6 karakter";
                              }
                              return null;
                            },
                          ),

                          buildTitle("Email Address"),
                          height(12),
                          buildTextField(
                            hintText: "Enter your email",
                            controller: emailC,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Email tidak boleh kosong";
                              } else if (!value.contains('@')) {
                                return "Email tidak valid";
                              } else if (!RegExp(
                                r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$",
                              ).hasMatch(value)) {
                                return "Format Email tidak valid";
                              }
                              return null;
                            },
                          ),

                          buildTitle("Password"),
                          height(12),
                          buildTextField(
                            hintText: "Enter your password",
                            isPassword: true,
                            controller: passwordC,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Password tidak boleh kosong";
                              } else if (value.length < 6) {
                                return "Password minimal 6 karakter";
                              }
                              return null;
                            },
                          ),

                          height(24),
                          LoginButton(
                            isLogin: true,
                            label: "Register",
                            onPress: () {
                              if (_formKey.currentState!.validate()) {
                                print(emailC.text);
                                final UserModel data = UserModel(
                                  email: emailC.text,
                                  username: usernameC.text,
                                  password: passwordC.text,
                                  nomorhp: int.parse(nomorhpC.text),
                                );
                                DbHelper.registerUser(data);
                                Fluttertoast.showToast(
                                  msg: "Register Berhasil",
                                );
                                Navigator.pushNamed(context, '/login_screen');
                                //     } else {}
                              }
                            },
                          ),
                          height(16),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Have an account?"),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return LoginScreenProject();
                                      },
                                    ),
                                  );
                                },
                                child: Text(
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
            ),
          ],
        ),
      ),
    );
  }

  Container buildBackground() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xff6D94C5),
        // image: DecorationImage(
        //   image: AssetImage("assets/images/backgroundSlicing.jpeg"),
        //   fit: BoxFit.cover,
        // ),
      ),
    );
  }

  TextFormField buildTextField({
    String? hintText,
    bool isPassword = false,
    TextEditingController? controller,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      validator: validator,
      controller: controller,
      obscureText: isPassword ? isVisibility : false,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(70),
          borderSide: BorderSide(
            color: Colors.black.withOpacity(0.1),
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide(color: Colors.black, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide(
            color: Colors.black.withOpacity(0.2),
            width: 1.0,
          ),
        ),
        suffixIcon: isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    isVisibility = !isVisibility;
                  });
                },
                icon: Icon(
                  isVisibility ? Icons.visibility_off : Icons.visibility,
                ),
              )
            : null,
      ),
    );
  }

  SizedBox height(double height) => SizedBox(height: height);
  SizedBox width(double width) => SizedBox(width: width);

  Widget buildTitle(String text) {
    return Row(children: [

      ],
    );
  }
}
