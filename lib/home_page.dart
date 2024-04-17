import 'package:flutter/material.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:junkee_dealer/global.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> scheduledPickupOrders = [];

  @override
  void initState() {
    super.initState();
    fetchScheduledPickupOrders();
  }

  Future<void> fetchScheduledPickupOrders() async {
    final response = await http.get(Uri.parse('$baseurl/scheduled_pickup_orders'));
    if (response.statusCode == 200) {
      setState(() {
        scheduledPickupOrders = json.decode(response.body)['scheduled_pickup_orders'];
      });
    } else {
      print('Failed to fetch scheduled pickup orders. Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scheduled Pickup Orders'),
      ),
      body: ListView.builder(
        itemCount: scheduledPickupOrders.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> order = scheduledPickupOrders[index];
          return Card(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderDetailsPage(order: order),
                  ),
                );
              },
              child: ListTile(
                title: Text('Order ID: ${order['pickup_id']}'), // Update to pickup_id or relevant identifier
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('User ID: ${order['user_id']}'),
                    Text('Date: ${order['date']}'), // Change to the relevant date field
                    Text('Time: ${order['time']}'), // Change to the relevant time field
                    Text("Address: ${order['address']}"), // Change to the relevant address field
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


class OrderDetailsPage extends StatefulWidget {
  final Map<String, dynamic> order;

  OrderDetailsPage({required this.order});

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  Map<String, dynamic> itemizedBill = {};

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  Future<void> fetchItems() async {
    try {
      Map<String, dynamic> items = await fetchSelectedItemsWithPrices(widget.order['item_counts']);
      setState(() {
        itemizedBill = items;
      });
    } catch (e) {
      print('Error fetching items: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order ID: ${widget.order['pickup_id']}'),
            Text('User ID: ${widget.order['user_id']}'),
            Text('Date: ${widget.order['date']}'),
            Text('Time Slot: ${widget.order['time']}'),
            SizedBox(height: 16),
            Text('Items:'),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: itemizedBill.keys.map((item) {
                return Text('- $item (${itemizedBill[item]['count']})');
              }).toList(),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                acceptOrder();
              },
              child: Text('Accept Order'),
            ),
          ],
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> fetchSelectedItemsWithPrices(String itemCountsList) async {
    try {
      Map<String, List<String>> _itemLists = {
        'Paper': ['Newspaper', 'Magazine', 'Cardboard', 'Books', 'Office Paper', 'Paper Bags', 'Paper Cups', 'Paper Plates', 'Paper Towels', 'Paper Napkins', 'Paper Boxes', 'Paper Wrappers'],
        'Clothes': ['Item 4', 'Item 5', 'Item 6'],
        'Plastic': ['Item 7', 'Item 8', 'Item 9'],
        'E-waste': ['Item 10', 'Item 11', 'Item 12'],
        'Metal': ['Item 13', 'Item 14', 'Item 15'],
        'Glass': ['Item 16', 'Item 17', 'Item 18'],
        'Motor': ['Item 19', 'Item 20', 'Item 21'],
        'Other': ['Item 22', 'Item 23', 'Item 24'],
      };

      Map<String, double> itemRates = {
        'Newspaper': 2.0,
        'Magazine': 3.0,
        'Cardboard': 1.5,
        'Books': 4.0,
        'Office Paper': 2.5,
        'Paper Bags': 1.0,
        'Paper Cups': 1.2,
        'Paper Plates': 1.3,
        'Paper Towels': 1.0,
        'Paper Napkins': 1.0,
        'Paper Boxes': 1.5,
        'Paper Wrappers': 0.8,
        'Item 4': 2.5,
        'Item 5': 3.0,
        'Item 6': 2.0,
        'Item 7': 1.8,
        'Item 8': 2.0,
        'Item 9': 1.5,
        'Item 10': 3.0,
        'Item 11': 3.5,
        'Item 12': 4.0,
        'Item 13': 4.0,
        'Item 14': 4.5,
        'Item 15': 5.0,
        'Item 16': 3.5,
        'Item 17': 4.0,
        'Item 18': 3.0,
        'Item 19': 6.0,
        'Item 20': 7.0,
        'Item 21': 5.0,
        'Item 22': 2.0,
        'Item 23': 1.5,
        'Item 24': 2.5,
      };

      List<String> itemCountsListSplit = itemCountsList.split('|');

      Map<String, dynamic> itemizedBill = {};

      int categoryIndex = 0;
      _itemLists.forEach((category, items) {
        String categoryCounts = itemCountsListSplit[categoryIndex];
        for (int i = 0; i < items.length; i++) {
          int count = int.parse(categoryCounts[i]);
          if (count > 0) {
            double ratePerKg = itemRates[items[i]] ?? 0.0;
            double totalPrice = count * ratePerKg;
            itemizedBill[items[i]] = {'count': count, 'price': totalPrice}; // Store both count and price
          }
        }
        categoryIndex++;
      });

      return itemizedBill;
    } catch (e) {
      print('Error fetching selected items with prices: $e');
      throw e;
    }
  }

  Future<void> acceptOrder() async {
    var orderId = widget.order['pickup_id'];
    var userId = widget.order['user_id'];
    var scheduledDate = widget.order['date'].toString();
    var timeSlot = widget.order['time'].toString();
    var itemCounts = widget.order['item_counts'];
    var otp = widget.order['otp'];
    var dealerId='1';

    final response = await http.post(
      Uri.parse('$baseurl/accept_order'),
      body: jsonEncode({
        'order_id': orderId,
        'user_id': userId,
        'scheduled_date': scheduledDate,
        'time_slot': timeSlot,
        'item_counts': itemCounts,
        'otp': otp,
        'dealer_id': dealerId,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Handle success response
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Order Accepted'),
            content: Text('Order has been successfully accepted.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Handle failure response
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to accept order. Please try again.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}