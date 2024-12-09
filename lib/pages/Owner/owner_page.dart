import 'package:flutter/material.dart';
import 'widgets/sales_graph.dart';
import 'widgets/sales_table.dart';
import 'widgets/nav_item.dart';
import 'widgets/period_selector.dart';

class OwnerDashboard extends StatefulWidget {
  @override
  _OwnerDashboardState createState() => _OwnerDashboardState();
}

class _OwnerDashboardState extends State<OwnerDashboard> {
  String selectedMetric = 'Gross Sales';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: Color(0xFFFFF3CB),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                NavItem(
                  icon: Icons.bar_chart,
                  label: 'Reports',
                ),
                NavItem(
                  icon: Icons.inventory_2,
                  label: 'Inventory Items',
                ),
                NavItem(
                  icon: Icons.shopping_bag,
                  label: 'Product Items',
                ),
                NavItem(
                  icon: Icons.people,
                  label: 'Employee List',
                ),
              ],
            ),
          ),
          PeriodSelector(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MetricButton(
                  label: 'Gross Sales',
                  isSelected: selectedMetric == 'Gross Sales',
                  onTap: () => setState(() => selectedMetric = 'Gross Sales'),
                ),
                MetricButton(
                  label: 'Net Sales',
                  isSelected: selectedMetric == 'Net Sales',
                  onTap: () => setState(() => selectedMetric = 'Net Sales'),
                ),
                MetricButton(
                  label: 'Gross Profit',
                  isSelected: selectedMetric == 'Gross Profit',
                  onTap: () => setState(() => selectedMetric = 'Gross Profit'),
                ),
                MetricButton(
                  label: 'Expenses',
                  isSelected: selectedMetric == 'Expenses',
                  onTap: () => setState(() => selectedMetric = 'Expenses'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  SalesGraph(selectedMetric: selectedMetric),
                  SizedBox(height: 10),
                  SalesTable(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MetricButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const MetricButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Color(0xFFFFF894),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
