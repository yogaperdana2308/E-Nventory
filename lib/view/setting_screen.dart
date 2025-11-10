import 'package:enventory/database/db_helper.dart';
import 'package:enventory/model/user_model.dart';
import 'package:enventory/preferences/preferencesHandler.dart';
import 'package:enventory/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  UserModel? user;

  @override
  void initState() {
    super.initState();
    getData(); // ambil data user saat halaman pertama kali dibuka
  }

  Future<void> getData() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');

    if (email != null) {
      final db = await DbHelper.db();
      final result = await db.query(
        DbHelper.tableUser,
        where: 'email = ?',
        whereArgs: [email],
      );

      if (result.isNotEmpty) {
        setState(() {
          user = UserModel.fromMap(result.first);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 131, 179, 238),
                      Color(0xff6D94C5),
                      Color.fromARGB(255, 103, 148, 204),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Settings",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Manage your preferences",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Profile section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.grey.shade200,
                      child: const Text(
                        "YG",
                        style: TextStyle(fontSize: 20, color: Colors.black54),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user == null ? 'Loading...' : user!.username,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            user == null ? 'Loading...' : user!.email,
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.grey,
                      size: 18,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Account section
              Text(
                "Account",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),

              // // _settingsTile(
              // //   icon: Icons.person_outline_rounded,
              // //   title: "Edit Profile",
              // //   trailing: const Icon(
              // //     Icons.arrow_forward_ios_rounded,
              // //     color: Colors.grey,
              // //     size: 18,
              // //   ),
              // ),
              SizedBox(height: 8),
              _logoutButton(context),

              const SizedBox(height: 108),

              // Footer
              Center(
                child: Column(
                  children: const [
                    Text(
                      "E-Nventory",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Version 1.0.0\n© 2025 All Rights Reserved",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _settingsTile({
    required IconData icon,
    required String title,
    Widget? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.teal),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        trailing: trailing,
      ),
    );
  }

  Widget _logoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          PreferenceHandler.removeLogin();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginScreenProject()),
            (Route<dynamic> route) => false,
          );
        },
        icon: const Icon(Icons.logout_rounded, color: Colors.white),
        label: const Text(
          "Logout",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
