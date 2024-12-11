import 'package:flutter/material.dart';

class MenuTabsWidget extends StatefulWidget {
  const MenuTabsWidget({super.key});

  @override
  _MenuTabsWidgetState createState() => _MenuTabsWidgetState();
}

class _MenuTabsWidgetState extends State<MenuTabsWidget> {
  List<Widget> tabs = const [
    Tab(text: 'Menu'),
    Tab(text: 'Queue'),
    Tab(text: 'Served'),
  ];

  List<Widget> tabViews = [
    MenuTabContent(
      onItemSelected: (item) {
        // Handle item selection
        print("Selected: ${item.title}");
      },
    ),
    const Center(child: Text('Queue Content')),
    const Center(child: Text('Served Content')),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Column(
        children: [
          TabBar(
            tabs: tabs,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black54,
            indicatorColor: const Color(0xFFFFF55E),
          ),
          Container(
            height: 475,
            color: const Color(0xFFFFF894),
            child: TabBarView(
              children: tabViews,
            ),
          ),
        ],
      ),
    );
  }
}

class MenuTabContent extends StatelessWidget {
  final Function(MenuItem) onItemSelected;

  const MenuTabContent({super.key, required this.onItemSelected});

  Future<List<MenuCategory>> fetchMenuCategories() async {
    // Simulate fetching data from a local source
    await Future.delayed(const Duration(seconds: 1));
    return [
      MenuCategory(
        title: 'Eat All-You-Can',
        items: [
          MenuItem(
              title: 'Unlimited Drumettes, rice & drinks',
              price: '249',
              onSelected: onItemSelected),
          MenuItem(
              title: 'Unlimited Wings, rice & drinks',
              price: '289',
              onSelected: onItemSelected),
          MenuItem(
              title: 'Unlimited Wings, rice, drinks & fries',
              price: '309',
              onSelected: onItemSelected),
          MenuItem(
              title: 'Unlimited Wings only',
              price: '349',
              onSelected: onItemSelected),
        ],
      ),
      MenuCategory(
        title: 'Refills',
        items: [
          MenuItem(title: 'Wings', price: '', onSelected: onItemSelected),
          MenuItem(title: 'Drumettes', price: '', onSelected: onItemSelected),
          MenuItem(title: 'Rice', price: '', onSelected: onItemSelected),
          MenuItem(title: 'Fries', price: '', onSelected: onItemSelected),
          MenuItem(title: 'Drinks', price: '', onSelected: onItemSelected),
        ],
      ),
      MenuCategory(
        title: 'Ala Carte',
        items: [
          MenuItem(
              title: '1 Pound Wings', price: '189', onSelected: onItemSelected),
          MenuItem(
              title: 'Barkada Meal', price: '339', onSelected: onItemSelected),
          MenuItem(title: 'MM2', price: '99', onSelected: onItemSelected),
        ],
      ),
      MenuCategory(
        title: 'Add-Ons',
        items: [
          MenuItem(title: 'Rice', price: '25', onSelected: onItemSelected),
          MenuItem(title: 'Extra Dip', price: '25', onSelected: onItemSelected),
          MenuItem(title: 'Fries', price: '60', onSelected: onItemSelected),
          MenuItem(
              title: 'Refreshments', price: '69', onSelected: onItemSelected),
          MenuItem(
              title: 'Soft Drinks', price: '100', onSelected: onItemSelected),
          MenuItem(
              title: 'Chill Drinks', price: '75', onSelected: onItemSelected),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MenuCategory>>(
      future: fetchMenuCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error fetching menu items'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No menu items available'));
        } else {
          return ListView.builder(
            padding: const EdgeInsets.all(5),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final category = snapshot.data![index];
              return MenuSection(
                title: category.title,
                items: category.items,
                onItemSelected: onItemSelected,
              );
            },
          );
        }
      },
    );
  }
}

class MenuCategory {
  final String title;
  final List<MenuItem> items;

  MenuCategory({required this.title, required this.items});
}

class MenuSection extends StatelessWidget {
  final String title;
  final List<MenuItem> items;
  final Function(MenuItem) onItemSelected;

  const MenuSection({
    super.key,
    required this.title,
    required this.items,
    required this.onItemSelected,
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
          children: items.map((item) {
            return item; // Each MenuItem is clickable as a whole
          }).toList(),
        ),
      ],
    );
  }
}

class MenuItem extends StatelessWidget {
  final String title;
  final String price;
  final Function(MenuItem) onSelected;

  const MenuItem({
    super.key,
    required this.title,
    required this.price,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelected(this),
      child: Container(
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
      ),
    );
  }
}
