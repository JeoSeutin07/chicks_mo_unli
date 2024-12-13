import 'package:flutter/material.dart';
import 'clock_dialog.dart';

class ClockDialogManager {
  static void showClockInSuccess(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ClockDialog(
        message: 'Clocked In Successfully',
        timestamp: DateTime.now().toString(),
      ),
    );
  }

  static void showClockOutSuccess(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ClockDialog(
        message: 'Clocked Out Successfully',
        timestamp: DateTime.now().toString(),
      ),
    );
  }

  static void showClockOutConfirmation(
    BuildContext context, {
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) => ClockDialog(
        message: "You haven't Clocked Out yet.\nContinue Log Out?",
        timestamp: DateTime.now().toString(),
        showActions: true,
        onConfirm: onConfirm,
        onCancel: () => Navigator.of(context).pop(),
      ),
    );
  }
}
