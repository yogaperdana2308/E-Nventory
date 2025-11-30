import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enventory/Service/firebase.dart';
import 'package:enventory/model/firebase_model.dart';
import 'package:enventory/model/item_firebase.dart';
import 'package:enventory/model/sales_model_firebase.dart';
import 'package:enventory/view/jual_barang_firebase.dart';
import 'package:enventory/widget/inventory_item.dart';
import 'package:enventory/widget/sales_chart.dart';
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
  UserFirebaseModel? userModel;
  int todayProfit = 0;
  int monthlyProfit = 0;
  int totalStock = 0;
  DateTime today = DateTime.now();
  Map<int, int> dailySales = {};
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _inventorySectionKey = GlobalKey();
  bool showAllInventory = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadUserFromFirestore();
      loadDashboardData();
      loadMonthlyProfit();
      loadDailySales(); // ← penting
    });
  }

  Future<void> loadDailySales() async {
    final data = await firebaseService.getDailySalesLast7Days();

    setState(() {
      dailySales = data;
    });
  }

  // =================================================
  // FORMAT RUPIAH
  // =================================================
  String formatRupiah(int value) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(value);
  }

  // =================================================
  // FIREBASE LOGIC (FIXED TYPE)
  // =================================================

  Future<int> getTodayProfitFirebase() async {
    final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final List<SalesModelFirebase> sales = await firebaseService
        .getSalesInDateRange(startDate: todayStr, endDate: todayStr);

    return sales.fold<int>(0, (int sum, s) => sum + s.sales);
  }

  Future<int> getTotalStockFirebase() async {
    final List<ItemFirebase> items = await firebaseService.getAllItems();

    return items.fold<int>(0, (int sum, item) => sum + item.stock);
  }

  Future<int> getMonthlyProfitFirebase() async {
    final now = DateTime.now();

    final start = DateFormat(
      'yyyy-MM-dd',
    ).format(DateTime(now.year, now.month, 1));
    final end = DateFormat(
      'yyyy-MM-dd',
    ).format(DateTime(now.year, now.month + 1, 0));

    final List<SalesModelFirebase> sales = await firebaseService
        .getSalesInDateRange(startDate: start, endDate: end);

    return sales.fold<int>(0, (int sum, s) => sum + s.sales);
  }

  // =================================================
  // LOAD DATA DASHBOARD
  // =================================================

  Future<void> loadDashboardData() async {
    final todayProfitFB = await getTodayProfitFirebase();
    final totalStockFB = await getTotalStockFirebase();

    setState(() {
      todayProfit = todayProfitFB;
      totalStock = totalStockFB;
    });
  }

  Future<void> loadMonthlyProfit() async {
    final monthlyProfitFB = await getMonthlyProfitFirebase();

    setState(() {
      monthlyProfit = monthlyProfitFB;
    });
  }

  // =================================================
  // LOAD USER
  // =================================================

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

  // =================================================
  // UI (TIDAK DIUBAH)
  // =================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          controller: ScrollController(),
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              _buildHeader(),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: _dashboardCard(
                      icon: Icons.shopping_cart_outlined,
                      title: "Penjualan Hari Ini",
                      value: formatRupiah(todayProfit),
                      percent: '',
                      percentColor: Colors.green,
                      bg: const Color(0xFFE0F7FA),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _dashboardCard(
                      icon: Icons.inventory_2_outlined,
                      title: "Sisa Stok",
                      value: totalStock.toString(),
                      bg: const Color(0xFFFFF3E0),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              _buildPendapatanCard(),

              const SizedBox(height: 20),

              _buildChart(),

              const SizedBox(height: 24),

              Container(
                key: _inventorySectionKey, // ← tambahkan ini
                child: _buildInventoryReal(), // versi non-dummy
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // =================================================
  // UI COMPONENTS — NO CHANGES
  // =================================================

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF83B3EE), Color(0xFF6D94C5), Color(0xFF6794CC)],
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
                DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(today),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const Spacer(),
          _headerIcon(Icons.search),
          const SizedBox(width: 10),
          _headerIcon(Icons.notifications_none_outlined),
        ],
      ),
    );
  }

  Widget _buildPendapatanCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF83B3EE), Color(0xFF6D94C5), Color(0xFF6794CC)],
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
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(width: 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Total Pendapatan",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Rp ${NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(monthlyProfit)}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Bulan ini",
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChart() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
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
              const Text(
                "Statistik Inventori",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              Spacer(),
              SizedBox(
                height: 32,
                child: tambahJualButton(
                  icon: Icons.sell_outlined,
                  label: "Jual Barang",
                  color: Color(0xFF4D8DDA),
                  tujuan: JualBarangFirebase(),
                ),
              ),
            ],
          ),

          SizedBox(height: 10),
          SalesChart(dailySales: dailySales),
        ],
      ),
    );
  }

  Future<List<ItemFirebase>> getInventoryItems() async {
    final items = await firebaseService.getAllItems();

    // urutkan berdasarkan stok terendah
    items.sort((a, b) => a.stock.compareTo(b.stock));

    return items;
  }

  Widget _buildInventoryReal() {
    return FutureBuilder<List<ItemFirebase>>(
      future: getInventoryItems(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final items = snapshot.data!;
        final statusText = items.isEmpty ? "Belum ada data inventori" : "";

        // Tentukan apakah menampilkan 3 item atau semua item
        final displayedItems = showAllInventory
            ? items
            : items.take(3).toList();

        return Container(
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
              // =======================================================
              //     HEADER (WRAP)
              // =======================================================
              Wrap(
                spacing: 8,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Text(
                    "Status Inventori",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),

                  // Tombol Lihat Semua
                  TextButton(
                    onPressed: () {
                      setState(() {
                        showAllInventory = !showAllInventory;
                      });
                    },
                    child: Text(
                      showAllInventory ? "Tampilkan 3 Item" : "Lihat Semua",
                      style: const TextStyle(
                        color: Color(0xFF4D8DDA),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  // Status text
                  Text(
                    statusText,
                    style: const TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // =======================================================
              //   TAMPILKAN ITEM (BISA 3 ATAU SEMUA ITEM)
              // =======================================================
              if (items.isEmpty)
                const Text(
                  "Tidak ada data inventori",
                  style: TextStyle(color: Colors.black54),
                ),

              ...displayedItems.map((item) {
                // status otomatis
                String status;
                Color statusColor;
                Color statusTextColor;

                if (item.stock == 0) {
                  status = "Habis";
                  statusColor = Colors.red.shade100;
                  statusTextColor = Colors.red.shade800;
                } else if (item.stock < 10) {
                  status = "Stok Rendah";
                  statusColor = Colors.orange.shade100;
                  statusTextColor = Colors.orange.shade800;
                } else {
                  status = "Aman";
                  statusColor = Colors.green.shade100;
                  statusTextColor = Colors.green.shade800;
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: InventoryItem(
                    name: item.name,
                    stock: item.stock,
                    status: status,
                    statusColor: statusColor,
                    statusTextColor: statusTextColor,
                    extraInfo: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Modal: Rp ${NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(item.modal)}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          "Harga Jual: Rp ${NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(item.price)}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

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
              if (alertIcon != null)
                Icon(alertIcon, color: alertColor, size: 18),
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
