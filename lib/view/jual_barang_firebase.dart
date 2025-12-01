import 'package:enventory/Service/firebase.dart';
import 'package:enventory/model/sales_model_firebase.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/item_firebase.dart';
import '../view/bottom_navigasi.dart';

class JualBarangFirebase extends StatefulWidget {
  const JualBarangFirebase({super.key});

  @override
  State<JualBarangFirebase> createState() => _JualBarangFirebaseState();
}

class _JualBarangFirebaseState extends State<JualBarangFirebase> {
  final qtyController = TextEditingController(text: '0');
  final priceController = TextEditingController(text: '0');
  final dateController = TextEditingController();

  double totalPrice = 0;
  List<ItemFirebase>? items; // ← awalnya null
  ItemFirebase? selectedItem;
  DateTime? earliestSellDate;

  DateTime? _parseItemDate(String? raw) {
    if (raw == null || raw.isEmpty) return null;

    try {
      // Coba format dd/MM/yyyy (dari StockScreenfirebase)
      return DateFormat('dd/MM/yyyy').parse(raw);
    } catch (_) {
      try {
        // Cadangan kalau ada data lama format yyyy-MM-dd
        return DateFormat('dd/MM?yyyy').parse(raw);
      } catch (_) {
        return null;
      }
    }
  }

  final currencyFormat = NumberFormat.currency(symbol: 'Rp ', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    qtyController.addListener(calculateTotal);
    priceController.addListener(calculateTotal);
    loadItems();
  }

  Future<void> loadItems() async {
    final data = await firebaseService.getAllItems();

    setState(() {
      items = data; // ← simpan hasil firebase
    });
  }

  void calculateTotal() {
    final qty = double.tryParse(qtyController.text) ?? 0;
    final price = double.tryParse(priceController.text) ?? 0;

    setState(() {
      totalPrice = qty * price;
    });
  }

  Future<void> selectDate(BuildContext context) async {
    if (earliestSellDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Pilih item terlebih dahulu!"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final DateTime minDate = earliestSellDate!;
    final DateTime today = DateTime.now();

    final initialPick = today.isBefore(minDate) ? minDate : today;

    final picked = await showDatePicker(
      context: context,
      initialDate: initialPick,
      firstDate: minDate, // tidak bisa pilih sebelum tanggal masuk barang
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  // =====================================================
  //                SIMPAN KE FIREBASE
  // =====================================================
  Future<void> saveTransaction() async {
    if (selectedItem == null ||
        qtyController.text.isEmpty ||
        priceController.text.isEmpty ||
        dateController.text.isEmpty ||
        totalPrice <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Isi semua data dengan benar!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final qty = int.tryParse(qtyController.text) ?? 0;

    if (qty <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Jumlah terjual harus lebih dari 0!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (selectedItem!.stock - qty < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Stok tidak mencukupi!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final formattedDate = DateFormat(
      'yyyy-MM-dd',
    ).format(DateFormat('dd/MM/yyyy').parse(dateController.text));

    final sales = SalesModelFirebase(
      itemId: selectedItem!.id!, // ← id pasti ada
      quantity: qty,
      price: selectedItem!.price,
      sales: qty * selectedItem!.price,
      date: formattedDate,
    );

    await firebaseService.createSales(sales);
    await firebaseService.reduceStock(selectedItem!.id!, qty);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Transaksi berhasil disimpan!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
      ),
    );

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => NavBottom()),
      (route) => false,
    );
  }

  // =====================================================
  //                       UI
  // =====================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Masukkan Transaksi'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pilih Barang * Firebase",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),

            DropdownButtonFormField<ItemFirebase>(
              decoration: InputDecoration(
                hintText: 'Pilih barang yang dijual',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              value: selectedItem,
              items: (items ?? [])
                  .map(
                    (item) =>
                        DropdownMenuItem(value: item, child: Text(item.name)),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) return;

                // parse tanggal dari item
                final parsedDate = _parseItemDate(value.date);

                if (parsedDate == null) {
                  // kalau tanggal di Firestore kosong / format aneh
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Tanggal barang tidak valid, cek kembali di menu Stock.",
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                setState(() {
                  selectedItem = value;
                  priceController.text = value.price.toString();
                  earliestSellDate =
                      parsedDate; // ← ini yang dipakai date picker
                });
              },
            ),

            const SizedBox(height: 12),
            const Text(
              "Tanggal *",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),

            TextField(
              controller: dateController,
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'Tanggal',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_month_outlined),
                  onPressed: () =>
                      selectDate(context), // ← pakai fungsi di atas
                ),
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              "Jumlah Terjual *",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),

            TextField(
              controller: qtyController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '0',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 16),
            const Text(
              "Harga Satuan *",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),

            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '0',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.teal[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.teal.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Total Harga",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currencyFormat.format(totalPrice),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[600],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      "Batal",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton(
                    onPressed: saveTransaction,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal[400],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      "Simpan",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
