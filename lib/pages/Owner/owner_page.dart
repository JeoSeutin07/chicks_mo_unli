import 'package:flutter/material.dart';
import 'widgets/sales_graph.dart';
import 'widgets/sales_table.dart';
import 'widgets/nav_item.dart';
import 'widgets/period_selector.dart';
import 'widgets/metric_button.dart';
import 'widgets/inventory_crud_page.dart';
import 'widgets/product_crud_page.dart';
import 'widgets/employee_crud_page.dart';
import 'widgets/reports_page.dart';

void main() => runApp(MaterialApp(home: OwnerDashboard()));

class OwnerDashboard extends StatefulWidget {
  @override
  _OwnerDashboardState createState() => _OwnerDashboardState();
}

class _OwnerDashboardState extends State<OwnerDashboard> {
  String selectedMetric = 'Gross Sales';
  String activePage = 'Reports';
  bool isFabOpen = false;

  final GlobalKey<NavigatorState> _nestedNavigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFFFFF3CB),
        ),
        child: Column(
          children: [
            // Remove the existing navigation menu
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Navigator(
                  key: _nestedNavigatorKey,
                  onGenerateRoute: (routeSettings) {
                    return MaterialPageRoute(
                        builder: (context) => ReportsPage(
                            selectedMetric: selectedMetric,
                            onMetricChange: _changeMetric));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: buildFab(),
    );
  }

  Widget buildFab() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isFabOpen) ...[
          buildFabOption(Icons.bar_chart, 'Reports', 'Reports'),
          buildFabOption(Icons.inventory_2, 'Inventory Items', 'Inventory'),
          buildFabOption(Icons.shopping_bag, 'Product Items', 'Products'),
          buildFabOption(Icons.people, 'Employee List', 'Employees'),
        ],
        FloatingActionButton(
          onPressed: toggleFab,
          backgroundColor: Color(0xFFFFF894),
          child: Icon(isFabOpen ? Icons.close : Icons.menu),
        ),
      ],
    );
  }

  Widget buildFabOption(IconData icon, String label, String page) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: FloatingActionButton.extended(
        onPressed: () => _navigateTo(page),
        backgroundColor: Color(0xFFFFF894),
        icon: Icon(icon),
        label: Text(label),
      ),
    );
  }

  void toggleFab() {
    setState(() {
      isFabOpen = !isFabOpen;
    });
  }

  void _navigateTo(String page) {
    setState(() {
      activePage = page;
      isFabOpen = false; // Close the FAB menu when navigating
    });

    Widget targetPage;
    switch (page) {
      case 'Reports':
        targetPage = ReportsPage(
          selectedMetric: selectedMetric,
          onMetricChange: _changeMetric,
        );
        break;
      case 'Inventory':
        targetPage = InventoryPage();
        break;
      case 'Products':
        targetPage = ProductPage();
        break;
      case 'Employees':
        targetPage = EmployeeListScreen();
        break;
      default:
        targetPage = Center(child: Text('Unknown Page'));
    }

    _nestedNavigatorKey.currentState?.pushReplacement(
      MaterialPageRoute(builder: (context) => targetPage),
    );
  }

  void _changeMetric(String metric) {
    setState(() {
      selectedMetric = metric;
    });

    // Ensure the ReportsPage is rebuilt with the new metric
    if (activePage == 'Reports') {
      _nestedNavigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(
          builder: (context) => ReportsPage(
            selectedMetric: selectedMetric,
            onMetricChange: _changeMetric,
          ),
        ),
      );
    }
  }
}

class NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(
            icon,
            size: 30,
            color: isActive ? Colors.black : Colors.grey,
          ),
          SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isActive ? Colors.black : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

// Reports Page with Period Selector and Graph
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
                SalesGraph(selectedMetric: selectedMetric),
                SizedBox(height: 10),
                SalesTable(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
