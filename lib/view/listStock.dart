import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const InventoryApp());
}

class InventoryApp extends StatelessWidget {
  const InventoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventory Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.cyan,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
      ),
      home: const ListStock(),
    );
  }
}

class ListStock extends StatefulWidget {
  const ListStock({super.key});

  @override
  State<ListStock> createState() => _InventoryDashboardState();
}

class _InventoryDashboardState extends State<ListStock> {
  final TextEditingController searchController = TextEditingController();
  final currencyFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  List<Map<String, dynamic>> items = [
    {'name': 'Minyak Goreng', 'stock': 42, 'price': 32000},
    {'name': 'Gula Pasir 1kg', 'stock': 89, 'price': 14000},
    {'name': 'Beras 5kg', 'stock': 67, 'price': 70000},
  ];

  List<Map<String, dynamic>> filteredItems = [];

  @override
  void initState() {
    super.initState();
    filteredItems = List.from(items);
  }

  // ======================
  // CREATE / UPDATE
  // ======================
  void _showItemDialog({Map<String, dynamic>? existingItem, int? index}) {
    final nameController = TextEditingController(
      text: existingItem?['name'] ?? '',
    );
    final stockController = TextEditingController(
      text: existingItem?['stock']?.toString() ?? '',
    );
    final priceController = TextEditingController(
      text: existingItem?['price']?.toString() ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(existingItem == null ? 'Tambah Item Baru' : 'Edit Item'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nama Barang'),
              ),
              TextField(
                controller: stockController,
                decoration: const InputDecoration(
                  labelText: 'Stok',
                  suffixText: 'pcs',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: 'Harga',
                  prefixText: 'Rp ',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isEmpty ||
                  stockController.text.isEmpty ||
                  priceController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Semua kolom wajib diisi!')),
                );
                return;
              }

              final newItem = {
                'name': nameController.text,
                'stock': int.tryParse(stockController.text) ?? 0,
                'price': int.tryParse(priceController.text) ?? 0,
              };

              setState(() {
                if (existingItem == null) {
                  items.add(newItem);
                } else {
                  items[index!] = newItem;
                }
                filteredItems = List.from(items);
              });

              Navigator.pop(context);
            },
            child: Text(existingItem == null ? 'Simpan' : 'Update'),
          ),
        ],
      ),
    );
  }

  // ======================
  // DELETE
  // ======================
  void _deleteItem(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Item'),
        content: Text(
          'Apakah kamu yakin ingin menghapus "${items[index]['name']}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() {
                items.removeAt(index);
                filteredItems = List.from(items);
              });
              Navigator.pop(context);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  // ======================
  // FILTER
  // ======================
  void _filterItems(String query) {
    final results = items.where((item) {
      return item['name'].toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredItems = results;
    });
  }

  // ======================
  // SUMMARY
  // ======================
  num get totalItems => items.length;
  num get totalStock => items.fold(0, (sum, item) => sum + item['stock']);
  num get lowStock => items.where((item) => item['stock'] < 10).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showItemDialog(),
        label: const Text('Tambah Item'),
        icon: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00BCD4), Color(0xFF26C6DA)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Inventory List',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Manage your store items',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // SUMMARY
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _SummaryCard(title: 'Total Items', value: '$totalItems'),
                  _SummaryCard(
                    title: 'Total Stock',
                    value: '$totalStock',
                    valueColor: Colors.cyan,
                  ),
                  _SummaryCard(
                    title: 'Low Stock',
                    value: '$lowStock',
                    valueColor: Colors.orange,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // SEARCH BAR
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: _filterItems,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Cari item...',
                    icon: Icon(Icons.search),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // ITEM LIST
              Expanded(
                child: filteredItems.isEmpty
                    ? const Center(child: Text('Tidak ada data'))
                    : ListView.builder(
                        itemCount: filteredItems.length,
                        itemBuilder: (context, index) {
                          final item = filteredItems[index];
                          return _InventoryItemCard(
                            item: item,
                            onEdit: () => _showItemDialog(
                              existingItem: item,
                              index: index,
                            ),
                            onDelete: () => _deleteItem(index),
                            currencyFormat: currencyFormat,
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ======================
// SUMMARY CARD
// ======================
class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final Color? valueColor;

  const _SummaryCard({
    required this.title,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.black54, fontSize: 14),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                color: valueColor ?? Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================
// ITEM CARD
// ======================
class _InventoryItemCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final NumberFormat currencyFormat;

  const _InventoryItemCard({
    required this.item,
    required this.onEdit,
    required this.onDelete,
    required this.currencyFormat,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Detail barang
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'Stock: ${item['stock']}',
                      style: const TextStyle(color: Colors.orange),
                    ),
                    const SizedBox(width: 8),
                    const Text('|'),
                    const SizedBox(width: 8),
                    Text(
                      currencyFormat.format(item['price']),
                      style: const TextStyle(color: Colors.cyan),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Tombol aksi (Edit + Delete dalam 1 baris)
          Row(
            children: [
              IconButton(
                onPressed: onEdit,
                icon: const Icon(Icons.edit, color: Colors.cyan),
              ),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete, color: Colors.redAccent),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
