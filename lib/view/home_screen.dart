import 'package:enventory/database/db_helper.dart';
import 'package:enventory/model/user_model.dart';
import 'package:enventory/view/input_barang.dart';
import 'package:enventory/view/jual_barang.dart';
import 'package:enventory/widget/home_page.dart';
import 'package:enventory/widget/inventory_item.dart';
import 'package:enventory/widget/tambahjual_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePageProject extends StatefulWidget {
  const HomePageProject({super.key});

  @override
  State<HomePageProject> createState() => _HomePageProjectState();
}

class _HomePageProjectState extends State<HomePageProject> {
  DateTime? selectedPicked = DateTime.now();
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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 24),
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
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Bagian kiri (teks sapaan dan tanggal)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user == null ? 'Loading...' : user!.username,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            DateFormat(
                              'EEEE, dd MMMM yyyy',
                              "id_ID",
                            ).format(selectedPicked!),
                          ),
                        ],
                      ),
                      Spacer(),
                      // Tombol search
                      Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.search,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Tombol notifikasi
                      Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.notifications_none_outlined,
                          weight: 20,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DashboardCard(
                    icon: Icons.shopping_cart_outlined,
                    title: "Penjualan Hari Ini",
                    value: "Rp 1.2M",
                    persentase: "+12%",
                    persentaseColor: Colors.green,
                    iconBgColor: Color(0xFFE0F7FA),
                  ),
                  SizedBox(width: 16),
                  DashboardCard(
                    icon: Icons.inventory_2_outlined,
                    title: "Sisa Stok",
                    value: "3,842",
                    alert: true,
                    iconBgColor: Color(0xFFFFF3E0),
                  ),
                ],
              ),
              SizedBox(height: 24),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Bagian kiri: teks
                      Column(
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
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  tambahJualButton(
                    label: "Tambah Barang",
                    icon: Icons.add,
                    color: Colors.blue.withOpacity(0.6), // oranye
                    tujuan: InputItem(),
                  ),
                  SizedBox(width: 16),
                  tambahJualButton(
                    label: "Jual Barang",
                    icon: Icons.sell_outlined,
                    color: Colors.blue.withOpacity(0.6), // biru toska
                    tujuan: JualBarang(),
                  ),
                ],
              ),

              //List Barang
              SizedBox(height: 16),
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
                    // Judul dan tombol lihat semua
                    Text(
                      "Status Inventori",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Item 1
                    InventoryItem(
                      name: "Minyak Goreng",
                      stock: 42,
                      status: "Stok Rendah",
                      statusColor: Colors.orange.shade100,
                      statusTextColor: Colors.orange,
                    ),
                    const SizedBox(height: 12),
                    // Item 2
                    InventoryItem(
                      name: "Gula Pasir 1kg",
                      stock: 89,
                      status: "Aman",
                      statusColor: Colors.green.shade100,
                      statusTextColor: Colors.green,
                    ),
                    const SizedBox(height: 12),
                    // Item 3
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
