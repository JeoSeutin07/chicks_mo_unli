import 'package:flutter/material.dart';

class MenuTabsWidget extends StatelessWidget {
  const MenuTabsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
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
  const MenuTabContent({super.key});

  Future<List<MenuItem>> fetchMenuItems(String section) async {
    // Placeholder for database fetching logic
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
    if (section == 'Eat All-You-Can') {
      return [
        MenuItem(title: 'Unlimited Drummets, rice & drinks', price: '249'),
        MenuItem(title: 'Unlimited Wings, rice & drinks', price: '289'),
      ];
    } else if (section == 'Refills') {
      return [
        MenuItem(title: 'Wings', price: ''),
        MenuItem(title: 'Drum-mets', price: ''),
      ];
    } else if (section == 'Add-ons') {
      return [
        MenuItem(title: 'Extra Rice', price: '20'),
        MenuItem(title: 'Extra Sauce', price: '10'),
      ];
    } else if (section == 'Ala Carte') {
      return [
        MenuItem(title: 'Chicken Sandwich', price: '150'),
        MenuItem(title: 'Burger', price: '200'),
      ];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(5),
      children: [
        FutureBuilder<List<MenuItem>>(
          future: fetchMenuItems('Eat All-You-Can'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error fetching menu items'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No menu items available'));
            } else {
              return MenuSection(
                  title: 'Eat All-You-Can', items: snapshot.data!);
            }
          },
        ),
        FutureBuilder<List<MenuItem>>(
          future: fetchMenuItems('Refills'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error fetching menu items'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No menu items available'));
            } else {
              return MenuSection(title: 'Refills', items: snapshot.data!);
            }
          },
        ),
        FutureBuilder<List<MenuItem>>(
          future: fetchMenuItems('Add-ons'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error fetching menu items'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No menu items available'));
            } else {
              return MenuSection(title: 'Add-ons', items: snapshot.data!);
            }
          },
        ),
        FutureBuilder<List<MenuItem>>(
          future: fetchMenuItems('Ala Carte'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error fetching menu items'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No menu items available'));
            } else {
              return MenuSection(title: 'Ala Carte', items: snapshot.data!);
            }
          },
        ),
      ],
    );
  }
}

class MenuSection extends StatelessWidget {
  final String title;
  final List<MenuItem> items;

  const MenuSection({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Roboto',
            ),
          ),
        ),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 1.6,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          padding: const EdgeInsets.symmetric(horizontal: 10),
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
    super.key,
    required this.title,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFBD663),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 4),
            blurRadius: 6,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
              height: 1.5,
            ),
          ),
          if (price.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                price,
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Inter',
                  color: Colors.black87,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
