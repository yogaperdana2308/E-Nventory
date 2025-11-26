import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enventory/model/firebase_model.dart';
import 'package:enventory/view/input_barang.dart';
import 'package:enventory/view/jual_barang.dart';
import 'package:enventory/widget/home_page.dart';
import 'package:enventory/widget/inventory_item.dart';
import 'package:enventory/widget/tambahjual_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePageProjectFirebase extends StatefulWidget {
  const HomePageProjectFirebase({super.key});

  @override
  State<HomePageProjectFirebase> createState() =>
      _HomePageProjectFirebaseState();
}

class _HomePageProjectFirebaseState extends State<HomePageProjectFirebase> {
  UserFirebaseModel? userModel; // <- model untuk user kita
  DateTime today = DateTime.now();

  @override
  void initState() {
    super.initState();
    loadUserFromFirestore();
  }

  // =============================================================
  // 🔥 LOAD DATA USER dari Firestore
  // =============================================================
  Future<void> loadUserFromFirestore() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        print("USER NOT LOGGED IN");
        return;
      }

      final snap = await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUser.uid)
          .get();

      print("DOC EXISTS: ${snap.exists}");
      print("DATA: ${snap.data()}");

      if (snap.exists) {
        setState(() {
          userModel = UserFirebaseModel.fromMap(snap.data()!);
        });
      }
    } catch (e) {
      print("ERROR LOAD USER: $e");
    }
  }

  // =============================================================
  // UI
  // =============================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 24),

              // =======================
              // 🔥 HEADER – Nama & Tanggal
              // =======================
              Container(
                height: 130,
                width: 400,
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
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 209, 209, 209),
                      spreadRadius: 1,
                      blurRadius: 16,
                      offset: const Offset(3, 1),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 20,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // TEKS USERNAME
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userModel == null
                                ? "Loading..."
                                : (userModel!.username ?? "Tanpa Nama"),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // TANGGAL
                          Text(
                            DateFormat(
                              'EEEE, dd MMMM yyyy',
                              'id_ID',
                            ).format(today),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      Spacer(),

                      // SEARCH
                      Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.search,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(width: 12),

                      // NOTIF
                      Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.notifications_none_outlined,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ======================
              // CARD DASHBOARD
              // ======================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DashboardCard(
                    icon: Icons.shopping_cart_outlined,
                    title: "Penjualan Hari Ini",
                    value: "Rp 1.2M",
                    persentase: "+12%",
                    persentaseColor: Colors.green,
                    iconBgColor: const Color(0xFFE0F7FA),
                  ),
                  const SizedBox(width: 16),
                  DashboardCard(
                    icon: Icons.inventory_2_outlined,
                    title: "Sisa Stok",
                    value: "3,842",
                    alert: true,
                    iconBgColor: const Color(0xFFFFF3E0),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ======================
              // TOTAL PENDAPATAN
              // ======================
              Container(
                width: 380,
                height: 120,
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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "Total Pendapatan",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Rp 45.8M",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Bulan ini",
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // BUTTON BARANG & JUAL
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  tambahJualButton(
                    label: "Tambah Barang",
                    icon: Icons.add,
                    color: Colors.blue.withOpacity(0.6),
                    tujuan: InputItem(),
                  ),
                  const SizedBox(width: 16),
                  tambahJualButton(
                    label: "Jual Barang",
                    icon: Icons.sell_outlined,
                    color: Colors.blue.withOpacity(0.6),
                    tujuan: JualBarang(),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ======================
              // STATUS INVENTORI
              // ======================
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(
                        255,
                        175,
                        175,
                        175,
                      ).withOpacity(0.6),
                      spreadRadius: 3,
                      blurRadius: 20,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Status Inventori",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    InventoryItem(
                      name: "Minyak Goreng",
                      stock: 42,
                      status: "Stok Rendah",
                      statusColor: Colors.orange.shade100,
                      statusTextColor: Colors.orange,
                    ),
                    const SizedBox(height: 12),
                    InventoryItem(
                      name: "Gula Pasir 1kg",
                      stock: 89,
                      status: "Aman",
                      statusColor: Colors.green.shade100,
                      statusTextColor: Colors.green,
                    ),
                    const SizedBox(height: 12),
                    InventoryItem(
                      name: "Beras 5kg",
                      stock: 67,
                      status: "Aman",
                      statusColor: Colors.green.shade100,
                      statusTextColor: Colors.green,
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
}
