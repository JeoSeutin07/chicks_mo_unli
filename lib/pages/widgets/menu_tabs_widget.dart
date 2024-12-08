import 'package:flutter/material.dart';

class MenuTabsWidget extends StatelessWidget {
  const MenuTabsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'Menu'),
              Tab(text: 'Queue'),
              Tab(text: 'Served'),
            ],
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black54,
            indicatorColor: Color(0xFFFFF55E),
          ),
          Container(
            height: 475,
            color: const Color(0xFFFFF894),
            child: TabBarView(
              children: [
                MenuTabContent(),
                const Center(child: Text('Queue Content')),
                const Center(child: Text('Served Content')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MenuTabContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(5),
      children: [
        MenuSection(
          title: 'Eat All-You-Can',
          items: [
            MenuItem(title: 'Unlimited Drummets, rice & drinks', price: '249'),
            MenuItem(title: 'Unlimited Wings, rice & drinks', price: '289'),
          ],
        ),
        MenuSection(
          title: 'Refills',
          items: [
            MenuItem(title: 'Wings', price: ''),
            MenuItem(title: 'Drum-mets', price: ''),
          ],
        ),
      ],
    );
  }
}

class MenuSection extends StatelessWidget {
  final String title;
  final List<MenuItem> items;

  const MenuSection({
    Key? key,
    required this.title,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Roboto',
          ),
        ),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: items,
        ),
      ],
    );
  }
}

class MenuItem extends StatelessWidget {
  final String title;
  final String price;

  const MenuItem({
    Key? key,
    required this.title,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFBD663),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 4),
            blurRadius: 4,
          ),
        ],
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontFamily: 'Inter',
            ),
          ),
          if (price.isNotEmpty)
            Text(
              price,
              style: const TextStyle(
                fontSize: 15,
                fontFamily: 'Inter',
              ),
            ),
        ],
      ),
    );
  }
}
