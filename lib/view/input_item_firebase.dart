import 'package:enventory/Service/firebase.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/item_firebase.dart';

class InputItemFirebase extends StatefulWidget {
  const InputItemFirebase({super.key});

  @override
  State<InputItemFirebase> createState() => _InputItemFirebaseState();
}

class _InputItemFirebaseState extends State<InputItemFirebase> {
  final _formKey = GlobalKey<FormState>();
  final _itemNameController = TextEditingController();
  final _purchasePriceController = TextEditingController();
  final _sellingPriceController = TextEditingController();
  final _stockQuantityController = TextEditingController();

  @override
  void dispose() {
    _itemNameController.dispose();
    _purchasePriceController.dispose();
    _sellingPriceController.dispose();
    _stockQuantityController.dispose();
    super.dispose();
  }

  // ============================
  //      SIMPAN KE FIREBASE
  // ============================
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      // Buat model item sebelum disimpan
      final item = ItemFirebase(
        name: _itemNameController.text.trim(),
        modal: int.parse(_purchasePriceController.text.trim()),
        price: int.parse(_sellingPriceController.text.trim()),
        stock: int.parse(_stockQuantityController.text.trim()),
        date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      );

      // Simpan ke Firestore
      await firebaseService.createItem(item);

      // Tampilkan pesan berhasil
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Item berhasil disimpan!'),
          backgroundColor: Colors.green,
        ),
      );

      // Kosongkan form
      _itemNameController.clear();
      _purchasePriceController.clear();
      _sellingPriceController.clear();
      _stockQuantityController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal menyimpan item: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F7),
      appBar: AppBar(
        title: const Text('Tambah Item', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            width: 400,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Nama Item
                  TextFormField(
                    controller: _itemNameController,
                    decoration: InputDecoration(
                      labelText: 'Nama Item *',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Nama item wajib diisi'
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // Harga Beli
                  TextFormField(
                    controller: _purchasePriceController,
                    decoration: InputDecoration(
                      labelText: 'Harga Beli *',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Harga Beli wajib diisi';
                      }
                      final price = double.tryParse(value);
                      if (price == null || price <= 0) {
                        return 'Harga Beli harus lebih dari 0';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Harga Jual
                  TextFormField(
                    controller: _sellingPriceController,
                    decoration: InputDecoration(
                      labelText: 'Harga Jual *',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Harga jual wajib diisi';
                      }
                      final price = double.tryParse(value);
                      if (price == null || price <= 0) {
                        return 'Harga Jual harus lebih dari 0';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Stok
                  TextFormField(
                    controller: _stockQuantityController,
                    decoration: InputDecoration(
                      labelText: 'Banyak Stok *',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Banyak Stok wajib diisi';
                      }
                      final qty = int.tryParse(value);
                      if (qty == null || qty <= 0) {
                        return 'Banyak Stok harus lebih dari 0';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Tombol Simpan
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF9800),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _submitForm,
                    child: const Text(
                      'Simpan',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
