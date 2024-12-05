import 'package:flutter/material.dart';

class ProfileInfo extends StatelessWidget {
  final String id;
  final String type;
  final String phone;
  final String email;
  final String facebook;

  // Constructor to accept these parameters
  const ProfileInfo({
    super.key,

    required this.id,
    required this.type,
    required this.phone,
    required this.email,
    required this.facebook,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.account_circle,
                size: 147,
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    id,
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.24,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    type,
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 16,
                      letterSpacing: 0.16,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Contact Information:',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 16,
                  letterSpacing: 0.16,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Phone: $phone',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 16,
                  letterSpacing: 0.16,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Email: $email',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 16,
                  letterSpacing: 0.16,
                ),
              ),
              SizedBox(height: 17),
              Text(
                'Facebook:',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 16,
                  letterSpacing: 0.16,
                ),
              ),
              SizedBox(height: 8),
              Text(
                facebook,
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 16,
                  letterSpacing: 0.16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
