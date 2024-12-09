import 'package:flutter/material.dart';

class TransactionCard extends StatelessWidget {
  final String title;
  final String amount;
  final bool isExpense;

  const TransactionCard({
    Key? key,
    required this.title,
    required this.amount,
    required this.isExpense,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3CB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Expanded(
            child: Text(
              amount,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: isExpense
                    ? const Color(0xFFE74C3C)
                    : const Color(0xFFFFF3CB),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
