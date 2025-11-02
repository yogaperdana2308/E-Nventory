import 'package:flutter/material.dart';

class ListpenjualanInventory extends StatefulWidget {
  const ListpenjualanInventory({super.key});

  @override
  State<ListpenjualanInventory> createState() => _ListpenjualanInventoryState();
}

class _ListpenjualanInventoryState extends State<ListpenjualanInventory> {
  final List<SalesDay> allSalesData = [
    SalesDay(
      date: 'Senin, 27 Oktober 2025',
      items: [
        SalesItem(name: 'Minyak Goreng', price: 32000, qty: 5),
        SalesItem(name: 'Gula Pasir 1kg', price: 14000, qty: 8),
      ],
    ),
    SalesDay(
      date: 'Minggu, 26 Oktober 2025',
      items: [
        SalesItem(name: 'Beras 5kg', price: 70000, qty: 3),
        SalesItem(name: 'Indomie Goreng', price: 3000, qty: 12),
      ],
    ),
  ];

  List<SalesDay> filteredData = [];
  DateTime? selectedDate;
  String? selectedItem;

  int totalItemsSold = 0;
  int totalSales = 0;

  @override
  void initState() {
    super.initState();
    filteredData = allSalesData;
    _calculateSummary();
  }

  // ======================
  // FILTER BY DATE
  // ======================
  Future<void> _filterByDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );

    if (picked != null) {
      final formatted = _formatDate(picked);
      setState(() {
        selectedDate = picked;
        selectedItem = null;
        filteredData = allSalesData
            .where((day) => day.date.contains(formatted))
            .toList();
        _calculateSummary();
      });
    }
  }

  // ======================
  // FILTER BY ITEM
  // ======================
  Future<void> _filterByItem() async {
    final items = {
      for (var d in allSalesData) ...d.items.map((i) => i.name),
    }.toList();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Pilih Item'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: items
                  .map(
                    (item) => ListTile(
                      title: Text(item),
                      onTap: () {
                        setState(() {
                          selectedItem = item;
                          selectedDate = null;
                          filteredData = allSalesData
                              .map((day) {
                                final filteredItems = day.items
                                    .where((i) => i.name == item)
                                    .toList();
                                if (filteredItems.isEmpty) return null;
                                return SalesDay(
                                  date: day.date,
                                  items: filteredItems,
                                );
                              })
                              .whereType<SalesDay>()
                              .toList();
                          _calculateSummary();
                        });
                        Navigator.pop(ctx);
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
        );
      },
    );
  }

  // ======================
  // RESET FILTER
  // ======================
  void _resetFilter() {
    setState(() {
      selectedDate = null;
      selectedItem = null;
      filteredData = allSalesData;
      _calculateSummary();
    });
  }

  // ======================
  // HITUNG RINGKASAN
  // ======================
  void _calculateSummary() {
    int totalQty = 0;
    int totalMoney = 0;

    for (var day in filteredData) {
      for (var item in day.items) {
        totalQty += item.qty;
        totalMoney += item.price * item.qty;
      }
    }

    totalItemsSold = totalQty;
    totalSales = totalMoney;
  }

  // ======================
  // FORMAT TANGGAL
  // ======================
  String _formatDate(DateTime date) {
    final List<String> hari = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    final List<String> bulan = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    String namaHari = hari[date.weekday - 1];
    String namaBulan = bulan[date.month - 1];
    return '$namaHari, ${date.day} $namaBulan ${date.year}';
  }

  // ======================
  // FORMAT RUPIAH
  // ======================
  String formatRupiah(int number) {
    String s = number.toString();
    String result = '';
    int count = 0;
    for (int i = s.length - 1; i >= 0; i--) {
      result = s[i] + result;
      count++;
      if (count == 3 && i != 0) {
        result = '.$result';
        count = 0;
      }
    }
    return 'Rp $result';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER DASHBOARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.cyan,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Sales Data',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Track your transactions',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // SUMMARY
              Row(
                children: [
                  Expanded(
                    child: _InfoCard(
                      title: 'Items Sold',
                      value: '$totalItemsSold',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _InfoCard(
                      title: 'Total Sales',
                      value: formatRupiah(totalSales),
                      highlight: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // FILTER BUTTONS
              Row(
                children: [
                  Expanded(
                    child: _FilterButton(
                      icon: Icons.calendar_today_outlined,
                      label: 'Filter by Date',
                      onTap: _filterByDate,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _FilterButton(
                      icon: Icons.filter_alt_outlined,
                      label: 'Filter by Item',
                      onTap: _filterByItem,
                    ),
                  ),
                ],
              ),

              if (selectedDate != null || selectedItem != null) ...[
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filter aktif: '
                      '${selectedDate != null ? _formatDate(selectedDate!) : ''} '
                      '${selectedItem ?? ''}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                    TextButton(
                      onPressed: _resetFilter,
                      child: const Text('Reset'),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 30),

              // SALES LIST
              ...filteredData.map(
                (day) => Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header tanggal
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 18,
                            color: Colors.cyan,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            day.date,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Card daftar item
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Header tabel
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      'Item Name',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      'Qty',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      'Total',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 1),

                            // Isi daftar item
                            ...day.items.map((item) => _SalesRow(item: item)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ======================
              // TOTAL KESELURUHAN
              // ======================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 24,
                ),
                decoration: BoxDecoration(
                  color: Colors.cyan.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.cyan.shade100),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Keseluruhan',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.cyan,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Barang Terjual:',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          '$totalItemsSold pcs',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Nominal Penjualan:',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          formatRupiah(totalSales),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ],
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

// =============================
// WIDGET TAMBAHAN
// =============================
class _InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final bool highlight;

  const _InfoCard({
    required this.title,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.black54, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: highlight ? Colors.cyan[700] : Colors.black87,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _FilterButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        side: const BorderSide(color: Colors.black12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      onPressed: onTap,
      icon: Icon(icon, color: Colors.black87, size: 20),
      label: Text(
        label,
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _SalesRow extends StatelessWidget {
  final SalesItem item;
  const _SalesRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFE0E0E0), width: 0.8),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                Text(
                  'Rp ${item.price.toStringAsFixed(0)}',
                  style: const TextStyle(color: Colors.black45, fontSize: 13),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.cyan.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${item.qty}',
                  style: const TextStyle(
                    color: Colors.cyan,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'Rp ${(item.price * item.qty).toStringAsFixed(0)}',
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================
// MODEL DATA
// =============================
class SalesDay {
  final String date;
  final List<SalesItem> items;

  SalesDay({required this.date, required this.items});
}

class SalesItem {
  final String name;
  final int price;
  final int qty;

  SalesItem({required this.name, required this.price, required this.qty});
}
