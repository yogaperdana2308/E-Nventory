import 'package:enventory/database/db_helper.dart';
import 'package:enventory/model/item_model.dart';
import 'package:enventory/model/penjualan_model.dart';
import 'package:enventory/view/bottom_navigasi.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Untuk format Rupiah

class JualBarang extends StatefulWidget {
  const JualBarang({super.key});

  @override
  State<JualBarang> createState() => _JualBarangState();
}

class _JualBarangState extends State<JualBarang> {
  bool initialValue = false;
  // String? selectedItem;
  final TextEditingController qtyController = TextEditingController(text: '0');
  final TextEditingController priceController = TextEditingController(
    text: '0',
  );
  final TextEditingController dateControlller = TextEditingController();

  Future<void> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // default: hari ini
      firstDate: DateTime(2000), // batas awal
      lastDate: DateTime(2101), // batas akhir
    );

    if (pickedDate != null) {
      setState(() {
        dateControlller.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
  }

  double totalPrice = 0;

  List<ItemModel>? items;
  ItemModel? selectedItem;

  final currencyFormat = NumberFormat.currency(
    // locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 1,
  );

  void calculateTotal() {
    final qty = double.tryParse(qtyController.text) ?? 0;
    final price = double.tryParse(priceController.text) ?? 0;
    setState(() {
      totalPrice = qty * price;
    });
  }

  @override
  void initState() {
    super.initState();
    qtyController.addListener(calculateTotal);
    priceController.addListener(calculateTotal);
    getData();
  }

  @override
  void dispose() {
    qtyController.dispose();
    priceController.dispose();
    super.dispose();
  }

  getData() async {
    final allItems = await DbHelper.getAllItem();

    // Map untuk menampung item unik berdasarkan nama (case-insensitive)
    final Map<String, ItemModel> unique = {};

    for (var item in allItems) {
      // normalisasi nama: spasi berlebih dibuang, huruf kecil semua
      final key = item.name.trim().toLowerCase().replaceAll(
        RegExp(r'\s+'),
        ' ',
      );

      // kalau nama ini belum ada -> simpan
      if (!unique.containsKey(key)) {
        unique[key] = item;
      } else {
        // kalau mau, bisa tambahkan stok ke item pertama
        // unique[key]!.stock += item.stock;
      }
    }

    setState(() {
      items = unique.values.toList()
        ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Masukkan  Transaksi'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pilih Barang
            const Text(
              "Pilih Barang *",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            DropdownButtonFormField<ItemModel>(
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
              onChanged: (value) {
                setState(() {
                  selectedItem = value;
                  priceController.text = value?.price.toString() ?? '0';
                });
              },
              items: (items ?? []).map((item) {
                return DropdownMenuItem(value: item, child: Text(item.name));
              }).toList(),
            ),

            SizedBox(height: 12),
            Text("Tanggal *", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 6),
            TextField(
              controller: dateControlller,
              decoration: InputDecoration(
                hintText: 'Tanggal',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_month_outlined),
                  onPressed: () {
                    selectDate(context);
                  },
                ),
              ),
              keyboardType: TextInputType.number,
            ),

            SizedBox(height: 16),

            // Jumlah Terjual
            Text(
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

            // Harga Satuan
            const Text(
              "Harga Satuan *",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
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

            // Total Harga
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

            // Tombol Aksi
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Batal",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal[400],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () async {
                      if (selectedItem == null ||
                          totalPrice <= 0 ||
                          qtyController.text.isEmpty ||
                          dateControlller.text.isEmpty) {
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

                      final newStock = selectedItem!.stock - qty;
                      if (newStock < 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Stok tidak mencukupi!'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      // 🔹 Update item
                      final updatedItem = ItemModel(
                        id: selectedItem!.id,
                        name: selectedItem!.name,
                        modal: selectedItem!.modal,
                        price: selectedItem!.price,
                        date: selectedItem!.date,
                        stock: newStock,
                      );

                      // 🔹 Buat data penjualan
                      final createSales = SalesModel(
                        itemId: selectedItem!.id!,
                        quantity: qty,
                        price: selectedItem!.price,
                        date: DateFormat('yyyy-MM-dd').format(
                          DateFormat('dd/MM/yyyy').parse(dateControlller.text),
                        ),
                      );

                      // 🔹 Simpan ke database
                      await DbHelper.updateItem(updatedItem);
                      await DbHelper.createSales(createSales);

                      // ✅ Gunakan messenger dari root supaya tidak hilang karena pop
                      final messenger = ScaffoldMessenger.of(context);
                      messenger.showSnackBar(
                        const SnackBar(
                          content: Text('Transaksi berhasil disimpan!'),
                          backgroundColor: Colors.green,
                          duration: Duration(seconds: 1),
                        ),
                      );

                      // ✅ Tunggu snackbar tampil
                      await Future.delayed(const Duration(seconds: 1));

                      // ✅ Pastikan context masih aktif
                      if (!mounted) return;

                      // ✅ Navigasi pakai pushReplacementNamed biar dijamin pindah
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => NavBottom()),
                        (route) => false,
                      );
                    },

                    child: const Text(
                      'Simpan',
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
