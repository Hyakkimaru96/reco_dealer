import 'package:flutter/material.dart';

class OrderDetailPage extends StatelessWidget {
  final Map<String, dynamic> order;

  OrderDetailPage({required this.order});

  @override
  Widget build(BuildContext context) {
    // Access order details using this.order
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order ID: ${order['order_id']}'),
            SizedBox(height: 8),
            Text('User ID: ${order['user_id']}'),
            SizedBox(height: 8),
            Text('Scheduled Date: ${order['scheduled_date']}'),
            SizedBox(height: 8),
            Text('Addres: ${order['address']}'),
            // Display other order details as needed
          ],
        ),
      ),
    );
  }
}
