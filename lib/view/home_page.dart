import 'package:enventory/widget/homePage.dart';
import 'package:enventory/widget/inventoryItem.dart';
import 'package:enventory/widget/tambahJualButton.dart';
import 'package:flutter/material.dart';

class HomePageProject extends StatefulWidget {
  const HomePageProject({super.key});

  @override
  State<HomePageProject> createState() => _HomePageProjectState();
}

class _HomePageProjectState extends State<HomePageProject> {
  DateTime? selectedPicked = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 20,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Bagian kiri (teks sapaan dan tanggal)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Hello, Yoga! 👋",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Jumat, 31 Oktober 2025",
                            style: TextStyle(
                              color: Color.fromARGB(179, 255, 255, 255),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
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
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.attach_money_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  tambahJualButton(
                    label: "Tambah Barang",
                    icon: Icons.add,
                    color: Color(0xFFFF9800), // oranye
                  ),
                  SizedBox(width: 16),
                  tambahJualButton(
                    label: "Jual Barang",
                    icon: Icons.shopping_cart_outlined,
                    color: Color(0xFF00BCD4), // biru toska
                  ),
                ],
              ),

              //List Barang
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Judul dan tombol lihat semua
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Status Inventori",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "Lihat Semua",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ],
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
