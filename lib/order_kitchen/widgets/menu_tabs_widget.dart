import 'package:flutter/material.dart';
import 'tickets_widget.dart';

class MenuTabsWidget extends StatefulWidget {
  const MenuTabsWidget({super.key});

  @override
  _MenuTabsWidgetState createState() => _MenuTabsWidgetState();
}

class _MenuTabsWidgetState extends State<MenuTabsWidget> {
  List<Order> orders = [];
  int currentTableNumber = 1;

  void addOrder(List<MenuItem> items) {
    setState(() {
      orders.add(Order(
        tableNumber: currentTableNumber++,
        items: items,
        timestamp: DateTime.now(),
      ));
    });
  }

  List<Widget> tabs = const [
    Tab(text: 'Menu'),
    Tab(text: 'Queue'),
    Tab(text: 'Served'),
  ];

  List<Widget> tabViews = [];

  @override
  void initState() {
    super.initState();
    tabViews = [
      MenuTabContent(
        onItemSelected: (item) {
          // Handle item selection
          print("Selected: ${item.title}");
        },
      ),
      const Center(child: Text('Queue Content')),
      const Center(child: Text('Served Content')),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TicketsWidget(
          orders: orders,
          currentTableNumber: currentTableNumber,
          onAddOrder: addOrder,
        ),
        DefaultTabController(
          length: tabs.length,
          child: Expanded(
            child: Column(
              children: [
                TabBar(
                  tabs: tabs,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.black54,
                  indicatorColor: const Color(0xFFFFF55E),
                ),
                Expanded(
                  child: Container(
                    color: const Color(0xFFFFF894),
                    child: TabBarView(
                      children: tabViews,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
          MenuItem(title: 'Unlimited Drumettes, rice & drinks', price: '249'),
          MenuItem(title: 'Unlimited Wings, rice & drinks', price: '289'),
          MenuItem(
              title: 'Unlimited Wings, rice, drinks & fries', price: '309'),
          MenuItem(title: 'Unlimited Wings only', price: '349'),
        ],
      ),
      MenuCategory(
        title: 'Refills',
        items: [
          MenuItem(title: 'Wings', price: ''),
          MenuItem(title: 'Drumettes', price: ''),
          MenuItem(title: 'Rice', price: ''),
          MenuItem(title: 'Fries', price: ''),
          MenuItem(title: 'Drinks', price: ''),
        ],
      ),
      MenuCategory(
        title: 'Ala Carte',
        items: [
          MenuItem(title: '1 Pound Wings', price: '189'),
          MenuItem(title: 'Barkada Meal', price: '339'),
          MenuItem(title: 'MM2', price: '99'),
        ],
      ),
      MenuCategory(
        title: 'Add-Ons',
        items: [
          MenuItem(title: 'Rice', price: '25'),
          MenuItem(title: 'Extra Dip', price: '25'),
          MenuItem(title: 'Fries', price: '60'),
          MenuItem(title: 'Refreshments', price: '69'),
          MenuItem(title: 'Soft Drinks', price: '100'),
          MenuItem(title: 'Chill Drinks', price: '75'),
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
            return MenuItemWidget(
              item: item,
              onSelected: onItemSelected,
            );
          }).toList(),
        ),
      ],
    );
  }
}

class MenuItemWidget extends StatelessWidget {
  final MenuItem item;
  final Function(MenuItem) onSelected;

  const MenuItemWidget({
    super.key,
    required this.item,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelected(item),
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
              item.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
                height: 1.5,
              ),
            ),
            if (item.price.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  item.price,
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

class MenuItem {
  final String title;
  final String price;

  MenuItem({required this.title, required this.price});
}
