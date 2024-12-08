import 'package:chicks_mo_unli/pages/Cash_Flow/widgets/period_selector.dart';
import 'package:flutter/material.dart';
import 'widgets/balance_section.dart';
import 'widgets/stats_section.dart';
import 'widgets/transaction_history.dart';
import 'widgets/action_buttons.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 412),
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(
          children: [
            Container(
              color: Color(0xFFFFF894),
              padding:
                  const EdgeInsets.only(bottom: 20), // Updated bottom padding
              child: Column(
                children: [
                  PeriodSelector(),
                  BalanceSection(),
                  StatsSection(),
                ],
              ),
            ),
            TransactionHistory(),
            ActionButtons(),
          ],
        ),
      ),
    );
  }
}
