import 'package:flutter/material.dart';

class InventoryCard extends StatefulWidget {
  final String itemName;
  final double startingStock;
  final double restock;
  final double totalStock;
  final double remainingStock;
  final VoidCallback onAddStock;
  final VoidCallback onEndInventory;
  final VoidCallback onCancel;

  const InventoryCard({
    Key? key,
    required this.itemName,
    required this.startingStock,
    required this.restock,
    required this.totalStock,
    required this.remainingStock,
    required this.onAddStock,
    required this.onEndInventory,
    required this.onCancel,
  }) : super(key: key);

  @override
  _InventoryCardState createState() => _InventoryCardState();
}

class _InventoryCardState extends State<InventoryCard> {
  final TextEditingController _controller = TextEditingController();
  
  // Function to handle number button tap
  void _onNumberPressed(String number) {
    setState(() {
      _controller.text = _controller.text + number;
    });
  }

  // Function to handle backspace functionality
  void _onBackspacePressed() {
    setState(() {
      _controller.text = _controller.text.isNotEmpty ? _controller.text.substring(0, _controller.text.length - 1) : '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
      maxHeight: 655, // Adjust the height limit as needed
      ),
      padding: const EdgeInsets.fromLTRB(10, 31, 17, 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xFFF5F2EC),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStockDetails(),
          const SizedBox(height: 10),
          _buildNumberPad(),
          const SizedBox(height: 20),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildStockDetails() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.itemName,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, fontFamily: 'Inter'),
          ),
          const SizedBox(height: 5),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: const Color(0xFFE8E9F1),
            ),
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFF15CCCC),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text('Starting Stock: ${widget.startingStock}kg', style: const TextStyle(fontSize: 12, fontFamily: 'Inter')),
          const SizedBox(height: 5),
          Text('Restock: ${widget.restock}kg', style: const TextStyle(fontSize: 12, fontFamily: 'Inter')),
          const SizedBox(height: 5),
          Text('Total Stock: ${widget.totalStock}kg', style: const TextStyle(fontSize: 12, fontFamily: 'Inter')),
          const SizedBox(height: 5),
          Text('Remaining Stock: ${widget.remainingStock}kg', style: const TextStyle(fontSize: 12, fontFamily: 'Inter')),
        ],
      ),
    );
  }

  Widget _buildNumberPad() {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: Colors.white,
    ),
    padding: const EdgeInsets.all(8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          '-- Restock Quantity --',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.14),
        ),
        const SizedBox(height: 10),
        // Display for restock quantity
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: const Color(0xFFC7C6C4),
          ),
          child: Text(
            _controller.text, // Display the entered restock quantity
            style: const TextStyle(fontSize: 14, letterSpacing: 0.14),
          ),
        ),
        const SizedBox(height: 10),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Center the row items
              children: [
                _buildNumberPadButton('1'),
                _buildNumberPadButton('2'),
                _buildNumberPadButton('3'),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Center the row items
              children: [
                _buildNumberPadButton('4'),
                _buildNumberPadButton('5'),
                _buildNumberPadButton('6'),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Center the row items
              children: [
                _buildNumberPadButton('7'),
                _buildNumberPadButton('8'),
                _buildNumberPadButton('9'),
              ],
            ),
            const SizedBox(height: 10),
            Row(
  mainAxisAlignment: MainAxisAlignment.center, // Center the row items
  children: [
    _buildNumberPadButton(''), // Empty space for alignment
    _buildNumberPadButton('0'),
    const SizedBox(width: 50), // Space for backspace button
    GestureDetector(
      onTap: _onBackspacePressed, // Call backspace function
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: const Icon(Icons.backspace),
      ),
    ),
  ],
)

          ],
        ),
      ],
    ),
  );
}

Widget _buildNumberPadButton(String number) {
  return Expanded(
    child: GestureDetector(
      onTap: () => _onNumberPressed(number), // Update display when number is pressed
      child: Container(
        height: 50, // Maintain consistent height
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        alignment: Alignment.center,
        child: Text(
          number,
          style: const TextStyle(fontSize: 14, letterSpacing: 0.14),
        ),
      ),
    ),
  );
}


  Widget _buildActionButtons() {
  return Center(
    child: SizedBox(
      width: 220, // Increased the width for better button layout
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: widget.onAddStock,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFEF00),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10), // Consistent padding
                  ),
                  child: const Text(
                    'Add Stock',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14, // Increased font size for readability
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8), // Spacing between buttons
              Expanded(
                child: ElevatedButton(
                  onPressed: widget.onEndInventory,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF28A745),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: const Text(
                    'End Inventory',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15), // Increased spacing between rows
          ElevatedButton(
            onPressed: widget.onCancel,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC3545),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
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
