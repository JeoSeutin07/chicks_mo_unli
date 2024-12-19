import 'package:cloud_firestore/cloud_firestore.dart';

class DatabasePopulator {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> populateSampleData() async {
    await _firestore.collection('inventory').add({
      'name': 'Chicken Wings',
      'description': 'Fresh chicken wings',
      'averagePrice': 10.0,
      'isArchived': false,
      'maximumStock': 100.0,
      'minimumStock': 20.0,
      'unit': 'kg',
      'currentStock': 50.0,
      'stockByDay': {
        '2024-01-19': 50.0,
        '2024-01-18': 45.0,
        '2024-01-17': 40.0,
      },
      'stockByWeek': {
        '2024-W03': 150.0,
        '2024-W02': 140.0,
        '2024-W01': 130.0,
      },
      'stockByMonth': {
        '2024-01': 600.0,
        '2023-12': 550.0,
        '2023-11': 500.0,
      },
      'stockByYear': {
        '2024': 600.0,
        '2023': 6000.0,
      },
      'restockHistory': [
        {
          'date': '2024-01-19',
          'restockAmount': 10.0,
          'startingStock': 40.0,
          'newStock': 50.0,
          'action': 'restock',
          'changedBy': 'system',
        }
      ],
    });
  }
}
