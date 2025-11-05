import 'package:enventory/Database/db_helper.dart';
import 'package:enventory/model/item_model.dart';
import 'package:enventory/model/penjualan_model.dart';
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
    items = await DbHelper.getAllItem();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Transaksi Penjualan'),
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
            const SizedBox(height: 6),
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
              items: items?.map((item) {
                return DropdownMenuItem(value: item, child: Text(item.name));
              }).toList(),
            ),

            SizedBox(height: 16),

            // Jumlah Terjual
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

            // Harga Satuan
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
                          qtyController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Isi semua data dengan benar!'),
                          ),
                        );
                        return;
                      }
                      final qty = int.tryParse(qtyController.text) ?? 0;

                      if (qty <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Jumlah terjual harus lebih dari 0!'),
                          ),
                        );
                        return;
                      }
                      // Kurangi stok barang
                      final newStock = selectedItem!.stock - qty;
                      if (newStock < 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Stok tidak mencukupi!'),
                          ),
                        );
                        return;
                      }
                      final updatedItem = ItemModel(
                        id: selectedItem!.id,
                        name: selectedItem!.name,
                        price: selectedItem!.price,
                        stock: newStock,
                      );

                      final CreateSales = SalesModel(
                        itemId: selectedItem!.id!,
                        quantity: int.parse(qtyController.text),
                        price: selectedItem!.price,
                      );
                      await DbHelper.updateItem(updatedItem);
                      await DbHelper.createSales(CreateSales);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Transaksi berhasil disimpan!'),
                        ),
                      );

                      Navigator.pop(
                        context,
                        true,
                      ); // kirim sinyal ke halaman sebelumnya
                    },
                    child: Text(
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
