import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({super.key});

  @override
  _CreateOrderScreenState createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final List<MenuItem> _selectedItems = [];

  Future<List<MenuItem>> fetchMenuItems() async {
    // Simulate fetching menu items
    await Future.delayed(const Duration(seconds: 1));
    return [
      MenuItem(title: 'Item 1', price: '10.00', onSelected: (isSelected) {}),
      MenuItem(title: 'Item 2', price: '15.00', onSelected: (isSelected) {}),
    ];
  }

  void _submitOrder() {
    // Simulate submitting order
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Order'),
      ),
      body: FutureBuilder<List<MenuItem>>(
        future: fetchMenuItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching menu items'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No menu items available'));
          } else {
            return ListView(
              children: snapshot.data!,
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _submitOrder,
        child: const Icon(Icons.check),
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final String title;
  final String price;
  final ValueChanged<bool> onSelected;

  const MenuItem({
    super.key,
    required this.title,
    required this.price,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(price),
      trailing: StatefulBuilder(
        builder: (context, setState) {
          bool isSelected = false;
          return Checkbox(
            onChanged: (bool? value) {
              setState(() {
                isSelected = value ?? false;
                onSelected(isSelected);
              });
            },
            value: isSelected,
          );
        },
      ),
    );
  }
}
