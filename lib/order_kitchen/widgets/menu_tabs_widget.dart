import 'package:flutter/material.dart';
import 'tickets_widget.dart';
import 'order_details_screen.dart';
import 'queue_tab_content.dart';
import 'serve_tab_content.dart'; // Add this import
import 'variation_selector.dart'; // Add this import

class MenuTabsWidget extends StatefulWidget {
  const MenuTabsWidget({super.key});

  @override
  _MenuTabsWidgetState createState() => _MenuTabsWidgetState();
}

class _MenuTabsWidgetState extends State<MenuTabsWidget>
    with SingleTickerProviderStateMixin {
  List<Order> orders = [];
  List<Order> kitchenOrders = [];
  List<Order> servedOrders = [];
  int currentTableNumber = 1;
  Order? currentOrder;
  late TabController _tabController;
  Map<Order, Stopwatch> orderTimers = {}; // Add this line
  bool showRefillTab = false; // Add a boolean to track the visibility of the refill tab

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: showRefillTab ? 4 : 3, vsync: this); // Update the initState method
    tabViews = [
      MenuTabContent(
        onItemSelected: (item) {
          if (currentOrder == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please create a table first.'),
              ),
            );
            return;
          }
          // Show flavor selection popup only for specific categories and items
          if (item.title.contains('Unlimited') ||
              item.title.contains('Wings') ||
              item.title.contains('Drumettes')) {
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
                  // Show drink selection popup if the item contains drinks
                  if (item.title.contains('drinks')) {
                    showDialog(
                      context: context,
                      builder: (context) => VariationSelector(
                        onConfirm: (selectedVariation) {
                          // Handle drink selection
                          setState(() {
                            orders.last.items.last = orders.last.items.last
                                .copyWith(drinkType: selectedVariation);
                          });
                          Navigator.pop(context);
                          showOrderDetailsModal(orders.last);
                        },
                      ),
                    );
                  } else {
                    showOrderDetailsModal(orders.last);
                  }
                },
              ),
            );
          } else if (item.title.contains('Drinks')) {
            showDialog(
              context: context,
              builder: (context) => VariationSelector(
                onConfirm: (selectedVariation) {
                  // Handle drink selection
                  setState(() {
                    orders.last.items
                        .add(item.copyWith(drinkType: selectedVariation));
                  });
                  Navigator.pop(context);
                  showOrderDetailsModal(orders.last);
                },
              ),
            );
          } else {
            setState(() {
              orders.last.items.add(item);
            });
            showOrderDetailsModal(orders.last);
          }
        },
      ),
      QueueTabContent(
        orders: kitchenOrders,
        onServeOrder: serveOrder,
        orderTimers: orderTimers, // Pass the order timers
      ),
      ServeTabContent(
        orders: servedOrders,
        onAddToOrder: addToOrder,
        onCheckOut: checkOut,
      ),
      if (showRefillTab)
        RefillTabContent(
          // Add your refill tab content here
        ),
    ];
  }

  void addOrder(int tableNumber, String orderType) {
    setState(() {
      currentOrder = Order(
        tableNumber: tableNumber,
        items: [],
        timestamp: DateTime.now(),
        orderType: orderType,
      );
      orders.add(currentOrder!);
    });
    Navigator.pop(context); // Dismiss the numpad
    showOrderDetailsModal(
        currentOrder!); // Show order details modal after creating an order
  }

  void sendToKitchen(Order order) {
    setState(() {
      kitchenOrders.add(order);
      currentOrder = null;
      orderTimers[order] = Stopwatch()
        ..start(); // Start the timer for the order
    });
    Navigator.pop(context); // Dismiss the modal
    _tabController.animateTo(1); // Switch to the Queue tab
  }

  void serveOrder(Order order) {
    setState(() {
      kitchenOrders.remove(order);
      servedOrders.add(order);
      orderTimers[order]?.stop(); // Stop the timer when the order is served
      _tabController.animateTo(2); // Switch to the Serve tab
    });
  }

  void addToOrder(Order order) {
    setState(() {
      currentOrder = order;
    });
    showOrderDetailsModal(order);
  }

  void checkOut(Order order) {
    // Implement the logic to check out
  }

  void showOrderDetailsModal(Order order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => OrderDetailsScreen(
        order: order,
        onSendToKitchen: () {
          sendToKitchen(order);
        },
        onRefill: () {
          setState(() {
            showRefillTab = true; // Set the boolean to true
          });
        },
      ),
    );
  }

  void selectTable(int tableNumber) {
    if (currentOrder != null && currentOrder!.tableNumber != tableNumber) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Change Table'),
          content: Text(
              'You have selected Table #$tableNumber. Do you want to switch to this table?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  currentTableNumber = tableNumber;
                  currentOrder = orders.firstWhere(
                      (order) => order.tableNumber == tableNumber,
                      orElse: () => Order(
                            tableNumber: tableNumber,
                            items: [],
                            timestamp: DateTime.now(),
                            orderType: 'Dine in',
                          ));
                });
                showOrderDetailsModal(currentOrder!);
              },
              child: const Text('Switch'),
            ),
          ],
        ),
      );
    } else {
      setState(() {
        currentTableNumber = tableNumber;
        currentOrder =
            orders.firstWhere((order) => order.tableNumber == tableNumber,
                orElse: () => Order(
                      tableNumber: tableNumber,
                      items: [],
                      timestamp: DateTime.now(),
                      orderType: 'Dine in',
                    ));
      });
      showOrderDetailsModal(currentOrder!);
    }
  }

  List<Widget> tabs = const [
    Tab(text: 'Menu'),
    Tab(text: 'Queue'),
    Tab(text: 'Served'),
  ];

  List<Widget> tabViews = [];

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
              onSelectTable: selectTable,
              onSendToQueue: sendToKitchen, // Add this line
            ),
            const SizedBox(
                height: 10), // Add spacing between TicketsWidget and tabs
            DefaultTabController(
              length: tabs.length,
              child: Expanded(
                child: Column(
                  children: [
                    TabBar(
                      controller: _tabController,
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
                          controller: _tabController,
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
      floatingActionButton: currentOrder != null
          ? FloatingActionButton(
              onPressed: () => showOrderDetailsModal(currentOrder!),
              child: const Icon(Icons.receipt),
              backgroundColor: Colors.yellow,
            )
          : null,
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
  final int quantity;
  final String? drinkType; // Add this line

  MenuItem({
    required this.title,
    required this.price,
    this.flavors = const [],
    this.quantity = 1,
    this.drinkType, // Add this line
  });

  MenuItem copyWith({List<String>? flavors, int? quantity, String? drinkType}) {
    // Modify this line
    return MenuItem(
      title: title,
      price: price,
      flavors: flavors ?? this.flavors,
      quantity: quantity ?? this.quantity,
      drinkType: drinkType ?? this.drinkType, // Add this line
    );
  }
}

class FlavorSelectionScreen extends StatefulWidget {
  final Function(List<String>) onConfirm;

  const FlavorSelectionScreen({super.key, required this.onConfirm});

  @override
  _FlavorSelectionScreenState createState() => _FlavorSelectionScreenState();
}

class _FlavorSelectionScreenState extends State<FlavorSelectionScreen> {
  List<String> selectedFlavors = [];

  void toggleFlavor(String flavor) {
    setState(() {
      if (selectedFlavors.contains(flavor)) {
        selectedFlavors.remove(flavor);
      } else {
        selectedFlavors.add(flavor);
      }
    });
  }

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
            Center(
              // Center the text
              child: const Text(
                'Flavors',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Roboto',
                  letterSpacing: 0.14,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  FlavorButton(
                    label: 'Original',
                    isSelected: selectedFlavors.contains('Original'),
                    onTap: () => toggleFlavor('Original'),
                  ),
                  FlavorButton(
                    label: 'Creamy Cheese',
                    isSelected: selectedFlavors.contains('Creamy Cheese'),
                    onTap: () => toggleFlavor('Creamy Cheese'),
                  ),
                  FlavorButton(
                    label: 'Garlic parmesan',
                    isSelected: selectedFlavors.contains('Garlic parmesan'),
                    onTap: () => toggleFlavor('Garlic parmesan'),
                  ),
                  FlavorButton(
                    label: 'Garlicky Butter',
                    isSelected: selectedFlavors.contains('Garlicky Butter'),
                    onTap: () => toggleFlavor('Garlicky Butter'),
                  ),
                  FlavorButton(
                    label: "Jack Daniel's",
                    isSelected: selectedFlavors.contains("Jack Daniel's"),
                    onTap: () => toggleFlavor("Jack Daniel's"),
                  ),
                  FlavorButton(
                    label: 'Cheesy Chicks',
                    isSelected: selectedFlavors.contains('Cheesy Chicks'),
                    onTap: () => toggleFlavor('Cheesy Chicks'),
                  ),
                  FlavorButton(
                    label: 'Teriyaki',
                    isSelected: selectedFlavors.contains('Teriyaki'),
                    onTap: () => toggleFlavor('Teriyaki'),
                  ),
                  FlavorButton(
                    label: 'Garlic Mayo',
                    isSelected: selectedFlavors.contains('Garlic Mayo'),
                    onTap: () => toggleFlavor('Garlic Mayo'),
                  ),
                  FlavorButton(
                    label: 'Barbecue',
                    isSelected: selectedFlavors.contains('Barbecue'),
                    onTap: () => toggleFlavor('Barbecue'),
                  ),
                  FlavorButton(
                    label: 'Macao Wings',
                    isSelected: selectedFlavors.contains('Macao Wings'),
                    onTap: () => toggleFlavor('Macao Wings'),
                  ),
                  FlavorButton(
                    label: 'Salted Egg',
                    isSelected: selectedFlavors.contains('Salted Egg'),
                    onTap: () => toggleFlavor('Salted Egg'),
                  ),
                  FlavorButton(
                    label: 'Honey Lemon',
                    isSelected: selectedFlavors.contains('Honey Lemon'),
                    onTap: () => toggleFlavor('Honey Lemon'),
                  ),
                  FlavorButton(
                    label: 'Soy Garlic',
                    isSelected: selectedFlavors.contains('Soy Garlic'),
                    onTap: () => toggleFlavor('Soy Garlic'),
                  ),
                  FlavorButton(
                    label: 'Salt & Pepper',
                    isSelected: selectedFlavors.contains('Salt & Pepper'),
                    onTap: () => toggleFlavor('Salt & Pepper'),
                  ),
                  FlavorButton(
                    label: 'Jeju Wings',
                    isSelected: selectedFlavors.contains('Jeju Wings'),
                    onTap: () => toggleFlavor('Jeju Wings'),
                  ),
                  FlavorButton(
                    label: 'American Mustard',
                    isSelected: selectedFlavors.contains('American Mustard'),
                    onTap: () => toggleFlavor('American Mustard'),
                  ),
                  FlavorButton(
                    label: 'Vanila Cheese',
                    isSelected: selectedFlavors.contains('Vanila Cheese'),
                    onTap: () => toggleFlavor('Vanila Cheese'),
                  ),
                  FlavorButton(
                    label: 'Swiss Cheese',
                    isSelected: selectedFlavors.contains('Swiss Cheese'),
                    onTap: () => toggleFlavor('Swiss Cheese'),
                  ),
                  FlavorButton(
                    label: 'Hot Mayo',
                    isSelected: selectedFlavors.contains('Hot Mayo'),
                    onTap: () => toggleFlavor('Hot Mayo'),
                  ),
                  FlavorButton(
                    label: 'Spicy Hot',
                    isSelected: selectedFlavors.contains('Spicy Hot'),
                    onTap: () => toggleFlavor('Spicy Hot'),
                  ),
                  FlavorButton(
                    label: 'Korean Spicy Chicken',
                    isSmallText: true,
                    isSelected:
                        selectedFlavors.contains('Korean Spicy Chicken'),
                    onTap: () => toggleFlavor('Korean Spicy Chicken'),
                  ),
                  FlavorButton(
                    label: 'Buffalo Wings',
                    isSelected: selectedFlavors.contains('Buffalo Wings'),
                    onTap: () => toggleFlavor('Buffalo Wings'),
                  ),
                  FlavorButton(
                    label: 'Dynamite',
                    isSelected: selectedFlavors.contains('Dynamite'),
                    onTap: () => toggleFlavor('Dynamite'),
                  ),
                  FlavorButton(
                    label: 'Hell Wings',
                    isSelected: selectedFlavors.contains('Hell Wings'),
                    onTap: () => toggleFlavor('Hell Wings'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                widget.onConfirm(selectedFlavors);
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
  final bool isSelected;
  final VoidCallback onTap;

  const FlavorButton({
    super.key,
    required this.label,
    this.isSmallText = false,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 78,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : const Color(0xFFFFF894),
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
      ),
    );
  }
}

class OrderItem {
  final String name;
  final int quantity;
  final List<String> flavors; // Add this line

  const OrderItem({
    required this.name,
    required this.quantity,
    this.flavors = const [], // Add this line
  });
}

class RefillTabContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Refill Tab Content'),
    );
  }
}
