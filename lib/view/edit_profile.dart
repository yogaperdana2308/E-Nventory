import 'package:enventory/database/db_helper.dart';
import 'package:enventory/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePage extends StatefulWidget {
  final UserModel? user; // ✅ sekarang tidak required

  const EditProfilePage({super.key, this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController nomorhpController;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController(
      text: widget.user?.username ?? '',
    );
    emailController = TextEditingController(text: widget.user?.email ?? '');
    passwordController = TextEditingController(
      text: widget.user?.password ?? '',
    );
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final db = await DbHelper.db();

    if (widget.user == null) {
      // ✅ Jika user belum ada di DB, tambahkan baru
      await db.insert(DbHelper.tableUser, {
        'username': usernameController.text,
        'email': emailController.text,
        'password': passwordController.text,
        'nomorhp': nomorhpController.text,
      });
    } else {
      // ✅ Jika user sudah ada, update berdasarkan id
      await db.update(
        DbHelper.tableUser,
        {
          'username': usernameController.text,
          'email': emailController.text,
          'password': passwordController.text,
          'nomorhp': nomorhpController.text,
        },
        where: 'id = ?',
        whereArgs: [widget.user!.id],
      );
    }

    // Simpan email terbaru ke SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', emailController.text);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.user == null
              ? 'Profil baru berhasil disimpan'
              : 'Profil berhasil diperbarui',
        ),
      ),
    );

    Navigator.pop(context, true); // kembali ke halaman sebelumnya
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: const Color(0xff6D94C5),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Username wajib diisi'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Email wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Password wajib diisi'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: nomorhpController,
                decoration: InputDecoration(
                  labelText: 'Nomor Hp',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Nomor Hp wajib diisi'
                    : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff6D94C5),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _saveProfile,
                  child: const Text(
                    'Simpan Perubahan',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
