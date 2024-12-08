import 'package:flutter/material.dart';
import 'transaction_card.dart';

class TransactionHistory extends StatelessWidget {
  const TransactionHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          const Text(
            'Transaction History',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.12,
              height: 2,
            ),
          ),
          SizedBox(
            height: 399,
            child: ListView(
              children: const [
                TransactionCard(
                  title: 'Expense Category',
                  amount: '- PHP 80',
                  isExpense: true,
                ),
                TransactionCard(
                  title: 'Harina',
                  amount: '- PHP 70',
                  isExpense: true,
                ),
                TransactionCard(
                  title: 'Utility Expense',
                  amount: '- PHP 1000',
                  isExpense: true,
                ),
                TransactionCard(
                  title: 'Salary Advance of Employee 1',
                  amount: '- PHP 500',
                  isExpense: true,
                ),
                TransactionCard(
                  title: 'Order #1 Sales',
                  amount: '+ PHP 1000',
                  isExpense: false,
                ),
                TransactionCard(
                  title: 'Mantika',
                  amount: '- PHP 80',
                  isExpense: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
