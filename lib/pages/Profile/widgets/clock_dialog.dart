import 'package:flutter/material.dart';

class ClockDialog extends StatelessWidget {
  final String message;
  final String timestamp;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool showActions;

  const ClockDialog({
    Key? key,
    required this.message,
    required this.timestamp,
    this.onConfirm,
    this.onCancel,
    this.showActions = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFFFFF894),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontFamily: 'Inter',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 7),
            Text(
              timestamp,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF797B7E),
                fontWeight: FontWeight.w400,
                fontFamily: 'Inter',
              ),
            ),
            if (showActions) ...[
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: onCancel,
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: onConfirm,
                    child: const Text('Confirm'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
