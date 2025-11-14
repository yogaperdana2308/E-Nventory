// import 'dart:io';

// import 'package:enventory/database/db_helper.dart';
// import 'package:enventory/model/user_model.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';

// class EditProfilePage extends StatefulWidget {
//   final UserModel user;
//   const EditProfilePage({super.key, required this.user});

//   @override
//   State<EditProfilePage> createState() => _EditProfilePageState();
// }

// class _EditProfilePageState extends State<EditProfilePage> {
//   late TextEditingController usernameController;
//   late TextEditingController nomorHpController;
//   late TextEditingController emailController;
//   late TextEditingController passwordController;
//   File? _profileImage;

//   @override
//   void initState() {
//     super.initState();
//     usernameController = TextEditingController(text: widget.user.username);
//     nomorHpController = TextEditingController(
//       text: widget.user.nomorhp.toString() ?? '',
//     );
//     emailController = TextEditingController(text: widget.user.email);
//     passwordController = TextEditingController(text: widget.user.password);
//   }

//   Future<void> _pickImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       final dir = await getApplicationDocumentsDirectory();
//       final newPath =
//           '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.png';
//       final savedImage = await File(pickedFile.path).copy(newPath);

//       setState(() {
//         _profileImage = savedImage;
//       });
//     }
//   }

//   Future<void> _saveChanges() async {
//     final updatedUser = UserModel(
//       id: widget.user.id,
//       username: usernameController.text,
//       nomorhp: int.tryParse(nomorHpController.text) ?? 0,
//       email: emailController.text,
//       password: passwordController.text,
//     );

//     final db = await DbHelper.db();
//     await db.update(
//       DbHelper.tableUser,
//       updatedUser.toMap(),
//       where: 'id = ?',
//       whereArgs: [widget.user.id],
//     );

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Profile updated successfully")),
//     );

//     Navigator.pop(context, true);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF7F8FA),
//       appBar: AppBar(
//         title: const Text("Edit Profile"),
//         backgroundColor: const Color(0xff6D94C5),
//         foregroundColor: Colors.white,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             GestureDetector(
//               onTap: _pickImage,
//               child: CircleAvatar(
//                 radius: 50,
//                 backgroundColor: Colors.grey.shade300,
//                 backgroundImage: _profileImage != null
//                     ? FileImage(_profileImage!)
//                     : null,
//                 child: _profileImage == null
//                     ? const Icon(
//                         Icons.camera_alt_rounded,
//                         size: 32,
//                         color: Colors.white70,
//                       )
//                     : null,
//               ),
//             ),
//             const SizedBox(height: 24),

//             _buildTextField(
//               "Username",
//               usernameController,
//               Icons.person_outline,
//             ),
//             const SizedBox(height: 16),
//             _buildTextField(
//               "Nomor HP",
//               nomorHpController,
//               Icons.phone,
//               keyboardType: TextInputType.phone,
//             ),
//             const SizedBox(height: 16),
//             _buildTextField("Email", emailController, Icons.email_outlined),
//             const SizedBox(height: 16),
//             _buildTextField(
//               "Password",
//               passwordController,
//               Icons.lock_outline,
//               obscureText: true,
//             ),
//             const SizedBox(height: 24),

//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xff6D94C5),
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 onPressed: _saveChanges,
//                 child: const Text(
//                   "Save Changes",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField(
//     String label,
//     TextEditingController controller,
//     IconData icon, {
//     bool obscureText = false,
//     TextInputType keyboardType = TextInputType.text,
//   }) {
//     return TextField(
//       controller: controller,
//       obscureText: obscureText,
//       keyboardType: keyboardType,
//       decoration: InputDecoration(
//         prefixIcon: Icon(icon, color: Colors.teal),
//         labelText: label,
//         filled: true,
//         fillColor: Colors.white,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide.none,
//         ),
//       ),
//     );
//   }
// }
