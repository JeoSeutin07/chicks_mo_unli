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

  void addOrder(int tableNumber, String orderType) {
    setState(() {
      orders.add(Order(
        tableNumber: tableNumber,
        items: [],
        timestamp: DateTime.now(),
        orderType: orderType,
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
          // Show flavor selection popup
          showDialog(
            context: context,
            builder: (context) => FlavorSelectionScreen(
              onConfirm: (selectedFlavors) {
                // Handle flavor selection
                setState(() {
                  orders.last.items
                      .add(item.copyWith(flavors: selectedFlavors));
                });
                Navigator.pop(context);
              },
            ),
          );
        },
      ),
      const Center(child: Text('Queue Content')),
      const Center(child: Text('Served Content')),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3CB),
      body: SafeArea(
        child: Column(
          children: [
            TicketsWidget(
              orders: orders,
              onAddOrder: addOrder,
            ),
            const SizedBox(
                height: 10), // Add spacing between TicketsWidget and tabs
            DefaultTabController(
              length: tabs.length,
              child: Expanded(
                child: Column(
                  children: [
                    TabBar(
                      tabs: tabs,
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.black54,
                      indicator: BoxDecoration(
                        color: const Color(0xFFFFF894), // Highlighted tab color
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ), // Rounded tabs only at the top
                      ),
                      indicatorSize:
                          TabBarIndicatorSize.tab, // Full-width indicator
                    ),
                    Expanded(
                      child: Container(
                        color: const Color(
                            0xFFFFF894), // Background color same as selected tab
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
        ),
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
  final List<String> flavors;

  MenuItem({required this.title, required this.price, this.flavors = const []});

  MenuItem copyWith({List<String>? flavors}) {
    return MenuItem(
      title: title,
      price: price,
      flavors: flavors ?? this.flavors,
    );
  }
}

class FlavorSelectionScreen extends StatelessWidget {
  final Function(List<String>) onConfirm;

  const FlavorSelectionScreen({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFF3CB),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '--Flavors --',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Roboto',
                letterSpacing: 0.14,
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: const [
                  FlavorButton(label: 'Original'),
                  FlavorButton(label: 'Creamy Cheese'),
                  FlavorButton(label: 'Garlic parmesan'),
                  FlavorButton(label: 'Garlicky Butter'),
                  FlavorButton(label: "Jack Daniel's"),
                  FlavorButton(label: 'Cheesy Chicks'),
                  FlavorButton(label: 'Teriyaki'),
                  FlavorButton(label: 'Garlic Mayo'),
                  FlavorButton(label: 'Barbecue'),
                  FlavorButton(label: 'Macao Wings'),
                  FlavorButton(label: 'Salted Egg'),
                  FlavorButton(label: 'Honey Lemon'),
                  FlavorButton(label: 'Soy Garlic'),
                  FlavorButton(label: 'Salt & Pepper'),
                  FlavorButton(label: 'Jeju Wings'),
                  FlavorButton(label: 'American Mustard'),
                  FlavorButton(label: 'Vanila Cheese'),
                  FlavorButton(label: 'Swiss Cheese'),
                  FlavorButton(label: 'Hot Mayo'),
                  FlavorButton(label: 'Spicy Hot'),
                  FlavorButton(
                      label: 'Korean Spicy Chicken', isSmallText: true),
                  FlavorButton(label: 'Buffalo Wings'),
                  FlavorButton(label: 'Dynamite'),
                  FlavorButton(label: 'Hell Wings'),
                ],
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Collect selected flavors and pass them to the onConfirm callback
                List<String> selectedFlavors = [
                  'Original', // Example selected flavors
                  'Garlic parmesan'
                ];
                onConfirm(selectedFlavors);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFEF00),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                minimumSize: const Size(double.infinity, 30),
              ),
              child: const Text(
                'Confirm',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FlavorButton extends StatelessWidget {
  final String label;
  final bool isSmallText;

  const FlavorButton({
    super.key,
    required this.label,
    this.isSmallText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 78,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF894),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontSize: isSmallText ? 11 : 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Roboto',
            letterSpacing: isSmallText ? 0.11 : 0.14,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
