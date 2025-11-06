import 'package:flutter/material.dart';

class LoginAkun extends StatelessWidget {
  const LoginAkun({
    super.key,
    required this.input,
    this.obscurePass = false,
    this.whenPress,
    this.lambang,
    this.isPassword = false,
    required this.icon,
    this.validator,
    this.controller,
  });
  final String input;
  final bool obscurePass;
  final void Function()? whenPress;
  final Widget? lambang;
  final bool isPassword;
  final IconData icon;
  final String? Function(String?)? validator;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscurePass,
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, size: 20),
        fillColor: const Color.fromARGB(255, 255, 255, 255),
        filled: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        hintText: input,
        suffixIcon: isPassword
            ? IconButton(
                onPressed: whenPress,
                // icon: lambang ?? SizedBox(),
                icon: obscurePass
                    ? Icon(Icons.visibility_off_outlined, size: 16)
                    : Icon(Icons.visibility_outlined, size: 16),
              )
            : null,
      ),
      validator: validator,
    );
  }
}
