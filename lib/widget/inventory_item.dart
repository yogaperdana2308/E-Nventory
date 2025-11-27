import 'package:flutter/material.dart';

class InventoryItem extends StatelessWidget {
  final String name;
  final int stock;
  final String status;
  final Color statusColor;
  final Color statusTextColor;

  /// Tambahan: Widget tambahan yang muncul DI BAWAH "Stok"
  final Widget? extraInfo;

  const InventoryItem({
    super.key,
    required this.name,
    required this.stock,
    required this.status,
    required this.statusColor,
    required this.statusTextColor,
    this.extraInfo, // <-- Tambahan
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment:
            CrossAxisAlignment.start, // <-- supaya kolom kiri tinggi
        children: [
          // ==========================
          //    KIRI (Nama + Stok + Extra Info)
          // ==========================
          Row(
            children: [
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // NAMA BARANG
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),

                  // STOK
                  Text(
                    "Stok: $stock unit",
                    style: TextStyle(color: Colors.grey[600]),
                  ),

                  // EXTRA INFO (HANYA MUNCUL JIKA ADA)
                  if (extraInfo != null) ...[
                    const SizedBox(height: 6),
                    extraInfo!,
                  ],
                ],
              ),
            ],
          ),

          // ==========================
          //    KANAN (Status Badge)
          // ==========================
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusTextColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
