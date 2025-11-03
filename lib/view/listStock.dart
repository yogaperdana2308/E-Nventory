import 'package:enventory/Database/db_helper.dart';
import 'package:enventory/model/item_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListStock extends StatefulWidget {
  const ListStock({super.key});

  @override
  State<ListStock> createState() => _ListStockState();
}

class _ListStockState extends State<ListStock> {
  late Future<List<ItemModel>> _listItem;
  final TextEditingController searchController = TextEditingController();
  final currencyFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  List<ItemModel> filteredItems = [];
  int totalStock = 0;
  int totalItems = 0;
  List<ItemModel> lowStockItems = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  // Ambil data dari database dan hitung rekap
  void getData() async {
    _listItem = DbHelper.getAllItem();
    final allItems = await _listItem;

    setState(() {
      totalItems = allItems.length;
      totalStock = allItems.fold(0, (sum, item) => sum + item.stock);
      lowStockItems = allItems.where((item) => item.stock < 10).toList();
    });
  }

  // CREATE / UPDATE ITEM
  void _showItemDialog({ItemModel? existingItem}) {
    final nameController = TextEditingController(
      text: existingItem?.name ?? '',
    );
    final stockController = TextEditingController(
      text: existingItem?.stock.toString() ?? '',
    );
    final priceController = TextEditingController(
      text: existingItem?.price.toString() ?? '',
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
            onPressed: () async {
              if (nameController.text.isEmpty ||
                  stockController.text.isEmpty ||
                  priceController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Semua kolom wajib diisi!')),
                );
                return;
              }

              final newItem = ItemModel(
                id: existingItem?.id,
                name: nameController.text,
                stock: int.parse(stockController.text),
                price: int.parse(priceController.text),
              );

              if (existingItem == null) {
                await DbHelper.createItem(newItem);
              } else {
                await DbHelper.updateItem(newItem);
              }

              getData();
              Navigator.pop(context);
            },
            child: Text(existingItem == null ? 'Simpan' : 'Update'),
          ),
        ],
      ),
    );
  }

  // DELETE ITEM
  void _deleteItem(ItemModel item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Item'),
        content: Text('Apakah kamu yakin ingin menghapus "${item.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await DbHelper.deleteItem(item.id!);
              getData();
              Navigator.pop(context);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  // FILTER (Pencarian)
  void _filterItems(String query, List<ItemModel> allItems) {
    final results = allItems
        .where((item) => item.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    setState(() {
      filteredItems = results;
    });
  }

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
              // HEADER UTAMA
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
              const SizedBox(height: 16),

              // REKAPAN
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildRekapCard(
                    title: 'Total Item',
                    value: '$totalItems',
                    color: Colors.cyan,
                    icon: Icons.inventory_2,
                  ),
                  _buildRekapCard(
                    title: 'Total Stock',
                    value: '$totalStock pcs',
                    color: Colors.orange,
                    icon: Icons.storage_rounded,
                  ),
                ],
              ),

              if (lowStockItems.isNotEmpty) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.redAccent),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '⚠️ Stok Menipis (< 10)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        ),
                      ),
                      const SizedBox(height: 6),
                      ...lowStockItems.map(
                        (e) => Text(
                          '• ${e.name} (${e.stock} pcs)',
                          style: const TextStyle(color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 16),

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
                  onChanged: (query) async {
                    final allItems = await DbHelper.getAllItem();
                    _filterItems(query, allItems);
                  },
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
                child: FutureBuilder<List<ItemModel>>(
                  future: _listItem,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('Tidak ada data'));
                    }

                    final data = searchController.text.isEmpty
                        ? snapshot.data!
                        : filteredItems;

                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final item = data[index];
                        return _InventoryItemCard(
                          item: item,
                          onEdit: () => _showItemDialog(existingItem: item),
                          onDelete: () => _deleteItem(item),
                          currencyFormat: currencyFormat,
                        );
                      },
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

  // Widget kecil untuk kartu rekap
  Widget _buildRekapCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: 18,
              ),
            ),
            Text(
              title,
              style: TextStyle(color: Colors.grey[700], fontSize: 13),
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
  final ItemModel item;
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
    final isLowStock = item.stock < 10;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLowStock ? Colors.red.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
        border: isLowStock ? Border.all(color: Colors.redAccent) : null,
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
                  item.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'Stock: ${item.stock}',
                      style: TextStyle(
                        color: isLowStock ? Colors.red : Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('|'),
                    const SizedBox(width: 8),
                    Text(
                      currencyFormat.format(item.price),
                      style: const TextStyle(color: Colors.cyan),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
