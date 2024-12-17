import 'package:flutter/material.dart';
import 'period_selector.dart';
import 'metric_button.dart';
import 'sales_graph.dart';
import 'sales_table.dart';

class ReportsPage extends StatelessWidget {
  final String selectedMetric;
  final Function(String) onMetricChange;

  const ReportsPage({
    required this.selectedMetric,
    required this.onMetricChange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PeriodSelector(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MetricButton(
                  label: 'Gross Sales',
                  isSelected: selectedMetric == 'Gross Sales',
                  onTap: () => onMetricChange('Gross Sales'),
                ),
                MetricButton(
                  label: 'Net Sales',
                  isSelected: selectedMetric == 'Net Sales',
                  onTap: () => onMetricChange('Net Sales'),
                ),
                MetricButton(
                  label: 'Gross Profit',
                  isSelected: selectedMetric == 'Gross Profit',
                  onTap: () => onMetricChange('Gross Profit'),
                ),
                MetricButton(
                  label: 'Expenses',
                  isSelected: selectedMetric == 'Expenses',
                  onTap: () => onMetricChange('Expenses'),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                if (selectedMetric == 'Gross Sales') ...[
                  SalesGraph(selectedMetric: 'Gross Sales'),
                  SizedBox(height: 10),
                  SalesTable(),
                ] else if (selectedMetric == 'Net Sales') ...[
                  SalesGraph(selectedMetric: 'Net Sales'),
                  SizedBox(height: 10),
                  SalesTable(),
                ] else if (selectedMetric == 'Gross Profit') ...[
                  SalesGraph(selectedMetric: 'Gross Profit'),
                  SizedBox(height: 10),
                  SalesTable(),
                ] else if (selectedMetric == 'Expenses') ...[
                  SalesGraph(selectedMetric: 'Expenses'),
                  SizedBox(height: 10),
                  SalesTable(),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
