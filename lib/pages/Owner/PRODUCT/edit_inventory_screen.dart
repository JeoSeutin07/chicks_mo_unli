import 'package:flutter/material.dart';
import 'models/products.dart';
import 'services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditInventoryItemScreen extends StatefulWidget {
  final Product? product;
  final String category;

  const EditInventoryItemScreen({
    Key? key,
    this.product,
    required this.category,
  }) : super(key: key);

  @override
  _EditInventoryItemScreenState createState() =>
      _EditInventoryItemScreenState();
}

class _EditInventoryItemScreenState extends State<EditInventoryItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firebaseService = FirebaseService();
  late TextEditingController _skuController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _categoryController;
  bool _available = true;

  @override
  void initState() {
    super.initState();
    _skuController = TextEditingController(text: widget.product?.sku ?? '');
    _descriptionController =
        TextEditingController(text: widget.product?.description ?? '');
    _priceController =
        TextEditingController(text: widget.product?.price.toString() ?? '0');
    _categoryController = TextEditingController(text: widget.category);
    _available = widget.product?.available ?? true;
  }

  @override
  void dispose() {
    _skuController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      final product = Product(
        id: widget.product?.id ?? '',
        sku: _skuController.text,
        category: _categoryController.text,
        description: _descriptionController.text,
        price: int.tryParse(_priceController.text) ?? 0,
        stockUsage: widget.product?.stockUsage ?? {},
        image: widget.product?.image ?? '',
        available: _available,
      );

      if (widget.product == null) {
        await _firebaseService.addProduct(_categoryController.text, product);
      } else {
        await _firebaseService.updateProduct(
          _categoryController.text,
          widget.product!.id,
          product,
        );
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3CB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF3CB),
        title: Text(
          widget.product == null ? 'Add Item' : 'Edit Item',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Roboto',
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _skuController,
              decoration: const InputDecoration(
                labelText: 'SKU',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter SKU';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter description';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter price';
                }
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _CategoryTypeAhead(controller: _categoryController),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Available '),
              value: _available,
              onChanged: (bool value) {
                setState(() {
                  _available = value;
                });
              },
            ),
            const SizedBox(height: 32),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 4,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFEF00),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                onPressed: _saveProduct,
                child: const Text(
                  'Save Changes',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Inter',
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryTypeAhead extends StatelessWidget {
  final TextEditingController controller;

  const _CategoryTypeAhead({required this.controller});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _fetchCategories(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        return Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<String>.empty();
            }
            return snapshot.data!.where((String option) {
              return option.contains(textEditingValue.text.toLowerCase());
            });
          },
          onSelected: (String selection) {
            controller.text = selection;
          },
          fieldViewBuilder: (BuildContext context,
              TextEditingController fieldTextEditingController,
              FocusNode fieldFocusNode,
              VoidCallback onFieldSubmitted) {
            return TextFormField(
              controller: fieldTextEditingController,
              focusNode: fieldFocusNode,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter category';
                }
                return null;
              },
            );
          },
          optionsViewBuilder: (BuildContext context,
              AutocompleteOnSelected<String> onSelected,
              Iterable<String> options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4.0,
                child: Container(
                  color: Color(0x80FFF894), // 0x80 is the hex for 0.5 opacity
                  constraints: BoxConstraints(maxHeight: 200),
                  child: ListView.builder(
                    padding: EdgeInsets.all(8.0),
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final String option = options.elementAt(index);
                      return GestureDetector(
                        onTap: () {
                          onSelected(option);
                        },
                        child: ListTile(
                          title: Text(option),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<List<String>> _fetchCategories() async {
    final snapshot = await FirebaseFirestore.instance.collection('menu').get();
    return snapshot.docs.map((doc) => doc.id).toList();
  }
}
