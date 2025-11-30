import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enventory/model/firebase_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfileDialog extends StatefulWidget {
  final UserFirebaseModel user;

  const EditProfileDialog({super.key, required this.user});

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  final TextEditingController usernameC = TextEditingController();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    usernameC.text = widget.user.username ?? "";
  }

  Future<void> saveUsername() async {
    setState(() => loading = true);

    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance.collection("users").doc(uid).update({
      "username": usernameC.text.trim(),
      "updateAt": DateTime.now().toIso8601String(),
    });

    Navigator.pop(context, true); // return true ke halaman sebelumnya
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text("Edit Profile"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Username",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: usernameC,
            decoration: InputDecoration(
              hintText: "Enter new username",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: loading ? null : () => Navigator.pop(context, false),
          child: Text("Cancel", style: TextStyle(color: Colors.black)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff6D94C5),
          ),
          onPressed: loading ? null : saveUsername,
          child: loading
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text("Save", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
