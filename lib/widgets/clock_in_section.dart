import 'package:flutter/material.dart';

class ClockInSection extends StatelessWidget {
  final String id;

  const ClockInSection({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFBD663),
              minimumSize: Size(258, 31),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Set Up Account'),
          ),
          SizedBox(height: 5),
          Container(
            width: double.infinity,
            height: 115,
            color: Color(0xFFFFEF00),
            child: Center(
              child: Text(
                'Clock In',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.48,
                ),
              ),
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Current Status: Clocked out',
            style: TextStyle(
              fontSize: 16,
              letterSpacing: 0.16,
            ),
          ),
          SizedBox(height: 128),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFF9A825),
              minimumSize: Size(359, 51),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Log out'),
          ),
        ],
      ),
    );
  }
}
