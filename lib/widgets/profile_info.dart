import 'package:flutter/material.dart';

class ProfileInfo extends StatelessWidget {
  final String username;
  final String id;
  final String type;
  final String phone;
  final String email;
  final String facebook;

  // Constructor to accept these parameters
  const ProfileInfo({
    super.key,
    required this.username,
    required this.id,
    required this.type,
    required this.phone,
    required this.email,
    required this.facebook,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380, // Set the width of the widget
      //padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.center, // Center the Row's children
            children: [
              Icon(
                Icons.account_circle,
                size: 147,
              ),
              SizedBox(width: 10),
              Expanded(
                // Make the Column fill the remaining space
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.24,
                      ),
                    ),
                    Text(
                      id,
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 16,
                        letterSpacing: 0.16,
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
              ),
            ],
          ),
          SizedBox(height: 24),
          Container(
            width: 300, // Set the width of the contact information column
            child: Column(
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
                SizedBox(height: 16),
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
                SizedBox(height: 8),
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
          ),
        ],
      ),
    );
  }
}
