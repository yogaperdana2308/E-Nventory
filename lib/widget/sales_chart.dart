import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SalesChart extends StatelessWidget {
  const SalesChart({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: 10,

          // =====================
          // GRID GARIS
          // =====================
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            verticalInterval: 1,
            horizontalInterval: 2,
            getDrawingHorizontalLine: (value) =>
                FlLine(color: Colors.grey.withOpacity(0.15), strokeWidth: 1),
            getDrawingVerticalLine: (value) =>
                FlLine(color: Colors.grey.withOpacity(0.12), strokeWidth: 1),
          ),

          // =====================
          // TITIK Sumbu X & Y
          // =====================
          titlesData: FlTitlesData(
            show: true,

            // --- Sumbu X ---
            bottomTitles: AxisTitles(
              axisNameWidget: const Text(
                "Hari",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
              axisNameSize: 24,
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                reservedSize: 32,
                getTitlesWidget: (value, meta) {
                  const days = [
                    "Sen",
                    "Sel",
                    "Rab",
                    "Kam",
                    "Jum",
                    "Sab",
                    "Min",
                  ];
                  if (value.toInt() < 0 || value.toInt() > 6) {
                    return const Text("");
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      days[value.toInt()],
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  );
                },
              ),
            ),

            // --- Sumbu Y ---
            leftTitles: AxisTitles(
              axisNameWidget: const Text(
                "Jumlah",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
              axisNameSize: 24,
              sideTitles: SideTitles(
                showTitles: true,
                interval: 2,
                reservedSize: 40,
                getTitlesWidget: (value, meta) => Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 11, color: Colors.black87),
                ),
              ),
            ),

            // --- Hilangkan judul kanan & atas
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),

          // =====================
          // BORDER AREA CHART
          // =====================
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),

          // =====================
          // DATA GARIS
          // =====================
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              color: const Color(0xFF4D8DDA),
              barWidth: 4,
              dotData: FlDotData(show: true),

              belowBarData: BarAreaData(
                show: true,
                color: const Color(0xFF4D8DDA).withOpacity(0.15),
              ),

              spots: const [
                FlSpot(0, 2),
                FlSpot(1, 5),
                FlSpot(2, 3),
                FlSpot(3, 7),
                FlSpot(4, 6),
                FlSpot(5, 9),
                FlSpot(6, 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
