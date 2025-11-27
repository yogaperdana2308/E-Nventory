import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enventory/model/firebase_model.dart';
import 'package:enventory/widget/inventory_item.dart';
import 'package:enventory/widget/sales_chart.dart';
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
  UserFirebaseModel? userModel;
  DateTime today = DateTime.now();

  @override
  void initState() {
    super.initState();
    loadUserFromFirestore();
  }

  Future<void> loadUserFromFirestore() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) return;

      final snap = await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUser.uid)
          .get();

      if (snap.exists) {
        setState(() {
          userModel = UserFirebaseModel.fromMap(snap.data()!);
        });
      }
    } catch (e) {
      print("ERROR LOAD USER: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              // =======================
              // HEADER
              // =======================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF83B3EE),
                      Color(0xFF6D94C5),
                      Color(0xFF6794CC),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 12,
                      offset: const Offset(2, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Nama + tanggal
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userModel?.username ?? "Loading...",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          DateFormat(
                            'EEEE, dd MMMM yyyy',
                            'id_ID',
                          ).format(today),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // ICON BUTTONS
                    _headerIcon(Icons.search),
                    const SizedBox(width: 10),
                    _headerIcon(Icons.notifications_none_outlined),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // =======================
              // DASHBOARD CARDS
              // =======================
              Row(
                children: [
                  Expanded(
                    child: _dashboardCard(
                      icon: Icons.shopping_cart_outlined,
                      title: "Penjualan Hari Ini",
                      value: "Rp 1.2M",
                      percent: "+12%",
                      percentColor: Colors.green,
                      bg: const Color(0xFFE0F7FA),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _dashboardCard(
                      icon: Icons.inventory_2_outlined,
                      title: "Sisa Stok",
                      value: "3.842",
                      alertIcon: Icons.error_outline,
                      alertColor: Colors.orange,
                      bg: const Color(0xFFFFF3E0),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // =======================
              // TOTAL PENDAPATAN
              // =======================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF83B3EE),
                      Color(0xFF6D94C5),
                      Color(0xFF6794CC),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total Pendapatan",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 6),
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
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Container(
                // height: 350,
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Statistik Penjualan",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10),
                    SalesChart(),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // =======================
              // BUTTONS
              // =======================
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Expanded(
                  //   child: tambahJualButton(
                  //     label: "Tambah Barang",
                  //     icon: Icons.add,
                  //     color: const Color(0xFF4D8DDA),
                  //     tujuan: InputItem(),
                  //   ),
                  // ),
                  // const SizedBox(width: 4),
                ],
              ),

              const SizedBox(height: 24),

              // =======================
              // STATUS INVENTORI
              // =======================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
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
                      extraInfo: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          SizedBox(height: 4),
                          Text(
                            "Modal: Rp 12.000",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            "Harga Jual: Rp 14.000",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),
                  ],
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // =======================
  // WIDGET: ICON HEADER
  // =======================
  Widget _headerIcon(IconData icon) {
    return Container(
      height: 34,
      width: 34,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: Colors.white, size: 18),
    );
  }

  // =======================
  // WIDGET: CARD DASHBOARD
  // =======================
  Widget _dashboardCard({
    required IconData icon,
    required String title,
    required String value,
    Color? percentColor,
    String? percent,
    Color? bg,
    IconData? alertIcon,
    Color? alertColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg ?? Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.black54, size: 22),
              const Spacer(),
              if (percent != null)
                Text(
                  percent,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: percentColor ?? Colors.black,
                  ),
                ),
              if (alertIcon != null) ...[
                Icon(alertIcon, color: alertColor, size: 18),
              ],
            ],
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(color: Colors.black54, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
