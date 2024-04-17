import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:junkee_dealer/global.dart';
import 'package:junkee_dealer/order_details.dart';

class CalendarPage extends StatefulWidget {
  int dealerId;

  CalendarPage({required this.dealerId});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  List<Map<String, dynamic>> dealerOrders = [];

  @override
  void initState() {
    super.initState();
    fetchDealerOrders();
  }

  // Function to fetch dealer orders
  Future<void> fetchDealerOrders() async {
    try {
      widget.dealerId=1;
      final response = await http.get(Uri.parse('$baseurl/dealer_orders/${widget.dealerId}'));
      if (response.statusCode == 200) {
        var data = json.decode(response.body)["dealer_orders"];
        setState(() {
          dealerOrders = List<Map<String, dynamic>>.from(data);
        });
      } else {
        print('Failed to fetch dealer orders: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: Text('Dealer Orders'),
      ),
      body: ListView.builder(
        itemCount: dealerOrders.length,
        itemBuilder: (context, index) {
          final order = dealerOrders[index];
          DateTime scheduleDate = DateTime.parse(order['scheduled_date']);
          String formattedDate = DateFormat('yyyy-MM-dd').format(scheduleDate);
          String formattedCurrentDate = DateFormat('yyyy-MM-dd').format(currentDate);
          bool isDueToday = formattedDate == formattedCurrentDate;
          //show the details of order, and of it is due we need to show address, otp enterinf and phone number
          return GestureDetector(
            onTap: () {
              // Navigate to the new page when the ListTile is clicked
              if (isDueToday) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderDetailPage(
                      order: order,
                      // Add more fields as needed
                    ),
                  ),
                );
              }
            },
            child: ListTile(
              title: Text('Order ID: ${order['order_id']}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                 <Widget>[
                  Text('Scheduled Date: ${order['scheduled_date']}'),
                  Text('User ID: ${order['user_id']}'),
                ],
              ),
              trailing: isDueToday ? Text('Due Today') : null,
            ),
          );
        },
      ),
    );
  }
}
