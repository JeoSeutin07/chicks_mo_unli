import 'package:flutter/material.dart';

class SalesTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableHeader(),
        ...List.generate(
          6,
          (index) => TableRow(
            date: '10-${(7 + index).toString().padLeft(2, '0')}-24',
            grossSales: '10,000',
            refunds: '0',
            netSales: '8,000',
            costOfGoods: '2,500',
            grossProfit: '7,500',
          ),
        ),
      ],
    );
  }
}

class TableHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Date', style: TextStyle(fontSize: 14)),
          Text('Gross Sales', style: TextStyle(fontSize: 14)),
          Text('Refunds', style: TextStyle(fontSize: 14)),
          Text('Net Sales', style: TextStyle(fontSize: 14)),
          Text('Cost of Goods', style: TextStyle(fontSize: 14)),
          Text('Gross Profit', style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}

class TableRow extends StatelessWidget {
  final String date;
  final String grossSales;
  final String refunds;
  final String netSales;
  final String costOfGoods;
  final String grossProfit;

  const TableRow({
    required this.date,
    required this.grossSales,
    required this.refunds,
    required this.netSales,
    required this.costOfGoods,
    required this.grossProfit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(date, style: TextStyle(fontSize: 8)),
          Text(grossSales, style: TextStyle(fontSize: 8)),
          Text(refunds, style: TextStyle(fontSize: 8)),
          Text(netSales, style: TextStyle(fontSize: 8)),
          Text(costOfGoods, style: TextStyle(fontSize: 8)),
          Text(grossProfit, style: TextStyle(fontSize: 8)),
        ],
      ),
    );
  }
}
