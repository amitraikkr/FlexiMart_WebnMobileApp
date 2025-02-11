import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../Const/api_config.dart';
import '../../Screens/Orders/order_details_screen.dart';
import '../../../Repository/constant_functions.dart';

class CustomerOrdersScreen extends StatefulWidget {
  const CustomerOrdersScreen({Key? key}) : super(key: key);

  @override
  _CustomerOrdersScreenState createState() => _CustomerOrdersScreenState();
}

class _CustomerOrdersScreenState extends State<CustomerOrdersScreen> {
  List<Map<String, dynamic>> orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      final today = DateTime.now();
      final startDate = today.subtract(const Duration(days: 30)); // Last 30 days
      
      final uri = Uri.parse(
        '${APIConfig.url}/orders/by-date?start_date=${DateFormat('yyyy-MM-dd').format(startDate)}&end_date=${DateFormat('yyyy-MM-dd').format(today)}'
      );
      
      print('Fetching orders from: $uri'); // Debug URL

      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': await getAuthToken(),
        },
      );

      print('Response status: ${response.statusCode}'); // Debug status
      print('Response body: ${response.body}'); // Debug response

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          orders = List<Map<String, dynamic>>.from(data['data']);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch orders');
      }
    } catch (e) {
      print('Error fetching orders: $e'); // Debug error
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Customer Orders",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 2.0,
      ),
      body: isLoading 
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: orders.isEmpty
                  ? const Center(
                      child: Text(
                        "No orders available",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        final orderDate = DateTime.parse(order["created_at"]);
                        final formattedDate = DateFormat('dd MMM yyyy').format(orderDate);
                        final formattedTime = DateFormat('hh:mm a').format(orderDate);

                        return OrderCard(
                          order: order,
                          orderDate: formattedDate,
                          orderTime: formattedTime,
                        );
                      },
                    ),
            ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final String orderDate;
  final String orderTime;

  const OrderCard({
    Key? key,
    required this.order,
    required this.orderDate,
    required this.orderTime,
  }) : super(key: key);

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'new':
        return Colors.blue;
      case 'processing':
      case 'processed': // Handle both variations
        return Colors.orange;
      case 'delivering':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _formatStatus(String? status) {
    if (status == null) return 'N/A';
    
    // Convert first letter to uppercase, rest to lowercase
    return status.length > 0 
        ? status[0].toUpperCase() + status.substring(1).toLowerCase()
        : status;
  }

  @override
  Widget build(BuildContext context) {
    final status = order["order_status"] as String?;
    final formattedStatus = _formatStatus(status);
    
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetailsScreen(order: order),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Icon(Icons.shopping_cart, color: Colors.blueAccent, size: 40),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          order["customer_name"]?.toString() ?? 'No Name',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getStatusColor(status).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _getStatusColor(status),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            formattedStatus,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: _getStatusColor(status),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Date: $orderDate",
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Text(
                      "Time: $orderTime",
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}