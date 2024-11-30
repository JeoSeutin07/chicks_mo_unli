import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EmployeeHeader extends StatelessWidget {
  final String employeeName;
  final DateTime currentTime;

  const EmployeeHeader({
    super.key,
    required this.employeeName,
    required this.currentTime,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: const Color(0xFFFFEF00),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                employeeName,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.1,
                  height: 20 / 10,
                  fontFamily: 'Roboto',
                ),
              ),
              Text(
                DateFormat('hh:mm a EEE MMM d').format(currentTime),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.1,
                  height: 20 / 10,
                  fontFamily: 'Roboto',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Expanded(
                child: Text(
                  'Orders and Kitchen',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.14,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
              Transform.rotate(
                angle: 3.141592653589793,
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
