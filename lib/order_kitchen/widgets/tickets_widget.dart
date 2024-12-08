import 'package:flutter/material.dart';

class TicketsWidget extends StatelessWidget {
  const TicketsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              'Orders and Kitchen',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'On-Going Tickets',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'Roboto',
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                TicketItem(
                  title: 'Create Table',
                  onTap: () {},
                ),
                // Add more TicketItem widgets as needed
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TicketItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const TicketItem({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Material(
        color: const Color(0xFFFBD663),
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
