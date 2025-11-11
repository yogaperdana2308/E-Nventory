import 'package:flutter/material.dart';

class tambahJualButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final Widget? tujuan;
  const tambahJualButton({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    this.tujuan,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Aksi saat ditekan
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => tujuan!),
        );
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(label)));
      },
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
