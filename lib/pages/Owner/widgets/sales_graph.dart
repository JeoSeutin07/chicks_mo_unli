import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SalesGraph extends StatelessWidget {
  final String selectedMetric;

  const SalesGraph({Key? key, required this.selectedMetric}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF81807E),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            selectedMetric,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: LineChart(
              LineChartData(
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (touchTooltipItem) => Color(0xFFD8D5A8),
                    fitInsideHorizontally: true,
                  ),
                ),
                minX: 8,
                maxX: 24,
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1000,
                      reservedSize: 40,
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false, // Disable right side titles
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false, // Disable top side titles
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        return Text('${value.toInt()}:00');
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      FlSpot(0, 1000),
                      FlSpot(1, 2500),
                      FlSpot(2, 3000),
                      FlSpot(3, 1000),
                      FlSpot(4, 200),
                      FlSpot(5, 3000),
                      FlSpot(6, 1000),
                      FlSpot(7, 2500),
                      FlSpot(8, 3000),
                    ],
                    isCurved: false,
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFFFEF00).withOpacity(1.0),
                          Color(0xFFD8D5A8).withOpacity(0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    color: Color(0xFFFFEF00),
                    barWidth: 2,
                    dotData: FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
