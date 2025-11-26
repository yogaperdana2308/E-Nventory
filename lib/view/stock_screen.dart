import 'package:enventory/database/db_helper.dart';
import 'package:enventory/model/item_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListStock extends StatefulWidget {
  const ListStock({super.key});

  @override
  State<ListStock> createState() => _ListStockState();
}

class _ListStockState extends State<ListStock> {
  String formatItemDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return "-";

    try {
      DateTime date = DateFormat('dd/MM/yyyy').parse(dateString);
      return DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(date);
    } catch (e) {
      return dateString;
    }
  }

  late Future<List<ItemModel>> _listItem;
  final TextEditingController searchController = TextEditingController();
  final currencyFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  List<ItemModel> mergeDuplicateItems(List<ItemModel> items) {
    final Map<String, ItemModel> grouped = {};

    for (var item in items) {
      // Normalisasi nama: buang spasi depan/belakang + huruf kecil semua
      final normalizedName = item.name.trim().toLowerCase().replaceAll(
        RegExp(r'\s+'),
        ' ',
      );

      final date = item.date ?? "";

      final key = "${normalizedName}_$date";

      if (grouped.containsKey(key)) {
        // Tambah stok jika item dengan key yang sama sudah ada
        grouped[key]!.stock += item.stock;
      } else {
        // Simpan item pertama sebagai dasar (pakai nama aslinya)
        grouped[key] = ItemModel(
          id: item.id,
          name: item.name, // tetap tampilkan nama asli pertama kali diinput
          stock: item.stock,
          price: item.price,
          date: item.date,
        );
      }
    }

    return grouped.values.toList();
  }

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
    final dateController = TextEditingController(
      text: existingItem?.date.toString() ?? '',
    );
    Future<void> selectDate(BuildContext context) async {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(), // default: hari ini
        firstDate: DateTime(2000), // batas awal
        lastDate: DateTime(2101), // batas akhir
      );

      if (pickedDate != null) {
        setState(() {
          dateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
        });
      }
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(existingItem == null ? 'Tambah Item Baru' : 'Edit Item'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Nama Barang'),
              ),
              TextField(
                controller: stockController,
                decoration: InputDecoration(
                  labelText: 'Stok',
                  suffixText: 'pcs',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(
                  labelText: 'Harga',
                  prefixText: 'Rp ',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: dateController,
                decoration: InputDecoration(
                  labelText: 'Tanggal',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_month_outlined, size: 16),
                    onPressed: () {
                      selectDate(context);
                    },
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isEmpty ||
                  stockController.text.isEmpty ||
                  priceController.text.isEmpty ||
                  dateController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Semua kolom wajib diisi!')),
                );
                return;
              }

              final newItem = ItemModel(
                id: existingItem?.id,
                name: nameController.text,
                stock: int.parse(stockController.text),
                price: int.parse(priceController.text),
                date: dateController.text,
              );
              print(newItem);

              final existing = await DbHelper.getItemByNameAndDate(
                nameController.text,
                dateController.text,
              );

              if (existing != null && existingItem == null) {
                // Item dengan nama & tanggal ini sudah ada
                final updated = ItemModel(
                  id: existing.id,
                  name: existing.name,
                  stock: existing.stock + int.parse(stockController.text),
                  price: int.parse(priceController.text),
                  date: existing.date,
                );

                await DbHelper.updateItem(updated);
              } else {
                if (existingItem == null) {
                  await DbHelper.createItem(newItem);
                } else {
                  await DbHelper.updateItem(newItem);
                }
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
        title: Text('Hapus Item'),
        content: Text('Apakah kamu yakin ingin menghapus "${item.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await DbHelper.deleteItem(item.id!);
              getData();
              Navigator.pop(context);
            },
            child: Text('Hapus'),
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
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue.withOpacity(0.6),
        onPressed: () => _showItemDialog(),
        label: Text('Tambah Item', style: TextStyle(color: Colors.white)),
        icon: Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER UTAMA
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 131, 179, 238),
                      Color(0xff6D94C5),
                      Color.fromARGB(255, 103, 148, 204),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Stock List',
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
              SizedBox(height: 16),

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
                SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.redAccent),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '⚠️ Stok Menipis (< 10)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        ),
                      ),
                      SizedBox(height: 6),
                      ...lowStockItems.map(
                        (e) => Text(
                          '• ${e.name} (${e.stock} pcs)',
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              SizedBox(height: 16),

              // SEARCH BAR
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
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
                child: TextField(
                  controller: searchController,
                  onChanged: (query) async {
                    final allItems = await DbHelper.getAllItem();
                    _filterItems(query, allItems);
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Cari item...',
                    icon: Icon(Icons.search),
                  ),
                ),
              ),
              SizedBox(height: 10),

              // ITEM LIST
              Expanded(
                child: FutureBuilder<List<ItemModel>>(
                  future: _listItem,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('Tidak ada data'));
                    }
                    final original = searchController.text.isEmpty
                        ? snapshot.data!
                        : filteredItems;
                    final data = mergeDuplicateItems(original);

                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final item = data[index];

                        // Format tanggal barang
                        final itemDateFormatted = formatItemDate(item.date);

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // === Tanggal Input ===
                            Padding(
                              padding: EdgeInsets.only(
                                left: 4,
                                bottom: 6,
                                top: 6,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    size: 14,
                                    color: Colors.teal,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    itemDateFormatted,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // === Item Card ===
                            _InventoryItemCard(
                              item: item,
                              onEdit: () => _showItemDialog(existingItem: item),
                              onDelete: () => _deleteItem(item),
                              currencyFormat: currencyFormat,
                            ),

                            SizedBox(height: 8),
                          ],
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
        margin: EdgeInsets.symmetric(horizontal: 4),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            SizedBox(height: 6),
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
      margin: EdgeInsets.symmetric(vertical: 6),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLowStock ? Colors.red.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'Stock: ${item.stock}',
                      style: TextStyle(
                        color: isLowStock ? Colors.red : Colors.orange,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text('|'),
                    SizedBox(width: 8),
                    Text(
                      currencyFormat.format(item.price),
                      style: TextStyle(color: Colors.cyan),
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
                icon: Icon(Icons.edit, color: Colors.cyan),
              ),
              IconButton(
                onPressed: onDelete,
                icon: Icon(Icons.delete, color: Colors.redAccent),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
