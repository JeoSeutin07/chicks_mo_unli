import 'package:flutter/material.dart';
import 'models/inventory_item.dart';
import 'services/inventory_service.dart';

class InventoryFormScreen extends StatefulWidget {
  final InventoryService inventoryService;
  final InventoryItem? item;

  const InventoryFormScreen({
    Key? key,
    required this.inventoryService,
    this.item,
  }) : super(key: key);

  @override
  _InventoryFormScreenState createState() => _InventoryFormScreenState();
}

class _InventoryFormScreenState extends State<InventoryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _minStockController;
  late TextEditingController _maxStockController;
  late TextEditingController _avgPriceController;
  String _selectedUnit = 'kg';
  String _selectedCategory = 'Perishable';

  final List<String> _units = ['kg', 'L', 'units', 'pieces'];
  final List<String> _categories = ['Perishable', 'Non-Perishable'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item?.name ?? '');
    _descriptionController =
        TextEditingController(text: widget.item?.description ?? '');
    _minStockController =
        TextEditingController(text: widget.item?.minimumStock.toString() ?? '');
    _maxStockController =
        TextEditingController(text: widget.item?.maximumStock.toString() ?? '');
    _avgPriceController =
        TextEditingController(text: widget.item?.averagePrice.toString() ?? '');
    _selectedUnit = widget.item?.unit ?? 'kg';
    _selectedCategory = widget.item?.category ?? 'Perishable';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFFFF3CB),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            widget.item != null ? 'Edit Item' : 'Add New Item',
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Color(0xFFFFF3CB),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Container(
            color: Color(0xFFFFF3CB),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Item Name *',
                            border: OutlineInputBorder(),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 20),
                            fillColor: Color(0xFFFFF3CB),
                            filled: true,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the item name';
                            }
                            final alphanumericRegex =
                                RegExp(r'^[a-zA-Z0-9. ]+$');
                            if (!alphanumericRegex.hasMatch(value)) {
                              return 'Item Name must be alphanumeric and can contain periods.';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedUnit,
                          decoration: const InputDecoration(
                            labelText: 'Unit',
                            border: OutlineInputBorder(),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 20),
                            fillColor: Color(0xFFFFF3CB),
                            filled: true,
                          ),
                          items: _units.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedUnit = newValue;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 13),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      fillColor: Color(0xFFFFF3CB),
                      filled: true,
                    ),
                    items: _categories.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedCategory = newValue;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 13),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      fillColor: Color(0xFFFFF3CB),
                      filled: true,
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 13),
                  TextFormField(
                    controller: _minStockController,
                    decoration: const InputDecoration(
                      labelText: 'Minimum Stock Allowed',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      fillColor: Color(0xFFFFF3CB),
                      filled: true,
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Required' : null,
                  ),
                  const SizedBox(height: 13),
                  TextFormField(
                    controller: _maxStockController,
                    decoration: const InputDecoration(
                      labelText: 'Maximum Stock Allowed',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      fillColor: Color(0xFFFFF3CB),
                      filled: true,
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Required' : null,
                  ),
                  const SizedBox(height: 13),
                  TextFormField(
                    controller: _avgPriceController,
                    decoration: const InputDecoration(
                      labelText: 'Average Price',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      fillColor: Color(0xFFFFF3CB),
                      filled: true,
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Required' : null,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _saveItem,
                    child: Text(widget.item != null ? 'Update' : 'Add'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFEF00),
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveItem() async {
    if (_formKey.currentState?.validate() ?? false) {
      final item = InventoryItem(
        id: widget.item?.id ?? '',
        name: _nameController.text,
        description: _descriptionController.text,
        minimumStock: double.tryParse(_minStockController.text) ?? 0,
        maximumStock: double.tryParse(_maxStockController.text) ?? 0,
        averagePrice: double.tryParse(_avgPriceController.text) ?? 0,
        unit: _selectedUnit,
        category: _selectedCategory,
        isArchived: widget.item?.isArchived ?? false,
      );

      if (widget.item != null) {
        await widget.inventoryService.updateInventoryItem(item);
      } else {
        await widget.inventoryService.addInventoryItem(item);
      }

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _minStockController.dispose();
    _maxStockController.dispose();
    _avgPriceController.dispose();
    super.dispose();
  }
}
