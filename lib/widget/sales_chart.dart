import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SalesChart extends StatelessWidget {
  final Map<int, int> dailySales;

  const SalesChart({super.key, required this.dailySales});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // =============================
          // LABEL Sumbu Y vertikal
          // =============================
          const RotatedBox(
            quarterTurns: -1, // rotasi 90 derajat ke kiri
            child: Text(
              "Jumlah (juta)",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),

          const SizedBox(width: 4),

          // =============================
          // CHART AREA
          // =============================
          Expanded(
            child: LineChart(
              LineChartData(
                minY: 0,
                maxY: _getMaxY(),

                // =============================
                // TOOLTIP ANGKA DI TITIK
                // =============================
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    // versi aman: cuma pakai getTooltipItems
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        // konversi ke juta & floor 1 angka
                        double jt = spot.y / 1000000;
                        double floor1 = (jt * 10).floor() / 10;

                        String valueText = (floor1 % 1 == 0)
                            ? floor1.toInt().toString()
                            : floor1.toStringAsFixed(1).replaceAll('.', ',');

                        return LineTooltipItem(
                          valueText, // contoh: "7,2"
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),

                // =============================
                // GRID
                // =============================
                gridData: FlGridData(
                  show: true,
                  drawHorizontalLine: true,
                  drawVerticalLine: false,
                  horizontalInterval: _getInterval(),
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey.withOpacity(0.15),
                    strokeWidth: 1,
                  ),
                ),

                // =============================
                // TITLES
                // =============================
                titlesData: FlTitlesData(
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),

                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 20,
                      interval: 1,
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
                        return Text(
                          days[value.toInt()],
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      },
                    ),
                  ),

                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 20,
                      interval: _getInterval(),
                      getTitlesWidget: (value, meta) {
                        double jt = value / 1000000;
                        double floor1 = (jt * 10).floor() / 10;

                        String display;
                        if (floor1 % 1 == 0) {
                          display = floor1.toInt().toString();
                        } else {
                          display = floor1
                              .toStringAsFixed(1)
                              .replaceAll('.', ',');
                        }

                        return Text(
                          display,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.black54,
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // =============================
                // BORDER
                // =============================
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.grey.withOpacity(0.25)),
                ),

                // =============================
                // DATA GARIS
                // =============================
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    curveSmoothness: 0.32,
                    color: const Color(0xFF4D8DDA),
                    barWidth: 3,

                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, bar, index) =>
                          FlDotCirclePainter(
                            radius: 3.5,
                            color: Colors.white,
                            strokeWidth: 2,
                            strokeColor: const Color(0xFF4D8DDA),
                          ),
                    ),

                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF4D8DDA).withOpacity(0.35),
                          const Color(0xFF4D8DDA).withOpacity(0.05),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),

                    spots: List.generate(7, (i) {
                      final y = (dailySales[i] ?? 0).toDouble();
                      return FlSpot(i.toDouble(), y);
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =============================
  // INTERVAL RESPONSIF
  // =============================
  double _getInterval() {
    if (dailySales.isEmpty) return 1000000;

    double maxJt = _rawMax() / 1000000;

    if (maxJt <= 2) return 500000;
    if (maxJt <= 5) return 1000000;
    if (maxJt <= 10) return 2000000;
    if (maxJt <= 50) return 5000000;
    if (maxJt <= 100) return 10000000;
    return 20000000;
  }

  int _rawMax() {
    return dailySales.values.isEmpty
        ? 1000000
        : dailySales.values.reduce((a, b) => a > b ? a : b);
  }

  double _getMaxY() {
    double interval = _getInterval();
    int raw = _rawMax();
    return (raw / interval).ceil() * interval;
  }
}
