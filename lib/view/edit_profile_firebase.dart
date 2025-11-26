import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enventory/model/firebase_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfileFirebase extends StatefulWidget {
  final UserFirebaseModel user;

  const EditProfileFirebase({super.key, required this.user});

  @override
  State<EditProfileFirebase> createState() => _EditProfileFirebaseState();
}

class _EditProfileFirebaseState extends State<EditProfileFirebase> {
  final TextEditingController usernameC = TextEditingController();

  @override
  void initState() {
    super.initState();
    usernameC.text = widget.user.username ?? "";
  }

  Future<void> saveUsername() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance.collection("users").doc(uid).update({
      "username": usernameC.text.trim(),
      "updateAt": DateTime.now().toIso8601String(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Username berhasil diupdate!"),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context, true); // kembali ke SettingsPage
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: const Color(0xff6D94C5),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Username",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: usernameC,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: "Enter new username",
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff6D94C5),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: saveUsername,
                child: const Text(
                  "Save",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
