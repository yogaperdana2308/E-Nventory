import 'package:enventory/Service/firebase.dart';
import 'package:enventory/model/item_firebase.dart';
import 'package:enventory/model/item_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StockScreenfirebase extends StatefulWidget {
  const StockScreenfirebase({super.key});

  @override
  State<StockScreenfirebase> createState() => _StockScreenFirebaseState();
}

class _StockScreenFirebaseState extends State<StockScreenfirebase> {
  String formatItemDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return "-";

    try {
      DateTime date = DateFormat('dd/MM/yyyy').parse(dateString);
      return DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(date);
    } catch (e) {
      return dateString;
    }
  }

  late Future<List<ItemFirebase>> _listItem;

  final TextEditingController searchController = TextEditingController();

  final currencyFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  // Gabungkan item duplikat (nama + tanggal sama)
  List<ItemFirebase> mergeDuplicateItems(List<ItemFirebase> items) {
    final Map<String, ItemFirebase> grouped = {};

    for (var item in items) {
      final normalizedName = item.name.trim().toLowerCase().replaceAll(
        RegExp(r'\s+'),
        ' ',
      );
      final key = "${normalizedName}_${item.date ?? ''}";

      if (grouped.containsKey(key)) {
        grouped[key] = ItemFirebase(
          id: grouped[key]!.id,
          name: grouped[key]!.name,
          stock: grouped[key]!.stock + item.stock,
          modal: grouped[key]!.modal,
          price: grouped[key]!.price,
          date: grouped[key]!.date,
        );
      } else {
        grouped[key] = item;
      }
    }

    return grouped.values.toList();
  }

  List<ItemFirebase> filteredItems = [];
  int totalStock = 0;
  int totalItems = 0;
  List<ItemFirebase> lowStockItems = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  // Ambil data dari Firebase
  void getData() async {
    _listItem = firebaseService.getAllItems();
    final allItems = await _listItem;

    setState(() {
      totalItems = allItems.length;
      totalStock = allItems.fold(0, (sum, item) => sum + item.stock);
      lowStockItems = allItems.where((item) => item.stock < 10).toList();
    });
  }

  // ============================================================
  // CREATE / UPDATE ITEM
  // ============================================================
  void _showItemDialog({ItemFirebase? existingItem}) {
    final nameController = TextEditingController(
      text: existingItem?.name ?? '',
    );
    final stockController = TextEditingController(
      text: existingItem?.stock.toString() ?? '',
    );
    final priceController = TextEditingController(
      text: existingItem?.price.toString() ?? '',
    );
    final modalController = TextEditingController(
      text: existingItem?.modal.toString() ?? '',
    );
    final dateController = TextEditingController(
      text: existingItem?.date ?? '',
    );

    Future<void> selectDate(BuildContext context) async {
      final picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );

      if (picked != null) {
        setState(() {
          dateController.text = DateFormat('dd/MM/yyyy').format(picked);
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
                decoration: InputDecoration(labelText: 'Stok'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: modalController,
                decoration: InputDecoration(
                  labelText: 'Modal',
                  prefixText: 'Rp ',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(
                  labelText: 'Harga Jual',
                  prefixText: 'Rp ',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: dateController,
                decoration: InputDecoration(
                  labelText: 'Tanggal',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_month_outlined),
                    onPressed: () => selectDate(context),
                  ),
                ),
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

              final item = ItemFirebase(
                id: existingItem?.id,
                name: nameController.text,
                stock: int.parse(stockController.text),
                modal: int.parse(modalController.text),
                price: int.parse(priceController.text),
                date: DateFormat(
                  'dd/MM/yyyy',
                ).format(DateFormat('dd/MM/yyyy').parse(dateController.text)),
              );

              if (existingItem == null) {
                await firebaseService.createItem(item);
              } else {
                await firebaseService.updateItem(item);
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

  // ============================================================
  // DELETE ITEM
  // ============================================================
  // void _deleteItem(ItemFirebase item) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: Text('Hapus Item'),
  //       content: Text('Hapus item "${item.name}" ?'),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: Text('Batal'),
  //         ),
  //         ElevatedButton(
  //           style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
  //           onPressed: () async {
  //             await firebaseService.deleteItem(item.id!);
  //             getData();
  //             Navigator.pop(context);
  //           },
  //           child: Text('Hapus'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // ============================================================
  // FILTER
  // ============================================================
  void _filterItems(String query, List<ItemFirebase> allItems) {
    final result = allItems
        .where((item) => item.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    setState(() {
      filteredItems = result;
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
                padding: EdgeInsets.symmetric(horizontal: 0),
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
                    final allItems = await firebaseService.getAllItems();
                    _filterItems(query, allItems);
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: "Cari item...",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),

              // ITEM LIST
              Expanded(
                child: FutureBuilder<List<ItemFirebase>>(
                  future: _listItem,
                  builder: (context, snap) {
                    if (!snap.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }

                    final list = searchController.text.isEmpty
                        ? mergeDuplicateItems(snap.data!)
                        : mergeDuplicateItems(filteredItems);

                    if (list.isEmpty) {
                      return Center(child: Text("Tidak ada data"));
                    }

                    return ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final item = list[index];

                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(
                              item.name,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              "Stok: ${item.stock} | Harga: ${currencyFormat.format(item.price)}",
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () =>
                                      _showItemDialog(existingItem: item),
                                ),
                                // IconButton(
                                //   icon: Icon(Icons.delete, color: Colors.red),
                                //   onPressed: () => _deleteItem(item),
                                // ),
                              ],
                            ),
                          ),
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
