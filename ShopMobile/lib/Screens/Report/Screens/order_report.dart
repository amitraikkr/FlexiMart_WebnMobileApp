//ignore_for_file: file_names, unused_element, unused_local_variable
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
// import 'package:mobile_pos/Provider/print_thermal_invoice_provider.dart';
// import 'package:mobile_pos/Provider/transactions_provider.dart';
// import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:nb_utils/nb_utils.dart';

// import '../../../PDF Invoice/generate_pdf.dart';
// import '../../../Provider/profile_provider.dart';
import '../../../constant.dart';
// import '../../../currency.dart';
// import '../../../model/print_transaction_model.dart';
// import '../../invoice_details/purchase_invoice_details.dart';
import '../../Orders/order_details_screen.dart';

final orderProvider = StateProvider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  return AsyncValue.data([
    {
      "customerName": "John Doe",
      "orderDate": DateTime.now().subtract(const Duration(hours: 2)),
      "status": "Delivered",
      "items": [
        {"name": "Product 1", "quantity": 2, "price": 25.0},
        {"name": "Product 2", "quantity": 1, "price": 30.0},
      ],
    },
    // Add more sample orders as needed
  ]);
});

class OrderReportScreen extends StatefulWidget {
  const OrderReportScreen({Key? key}) : super(key: key);

  @override
  State<OrderReportScreen> createState() => _OrderReportScreenState();
}

class _OrderReportScreenState extends State<OrderReportScreen> {
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  DateTime fromDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime toDate = DateTime.now();
  String selectedStatus = 'Delivered'; // Default status
  double totalOrders = 0;

  @override
  void initState() {
    super.initState();
    fromDateController.text = DateFormat.yMMMd().format(fromDate);
    toDateController.text = DateFormat.yMMMd().format(toDate);
  }

  @override
  Widget build(BuildContext context) {
    List<String> statusOptions = [
      'All',
      'New',
      'Processing',
      'Delivering',
      'Delivered',
      'Cancelled'
    ];

    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        title: Text(
          'Order Report',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 20.0,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Consumer(builder: (context, ref, __) {
        final orderData = ref.watch(orderProvider);

        return SingleChildScrollView(
          child: Column(
            children: [
              // Date Range and Status Filters
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Date Range Selectors
                    Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            textFieldType: TextFieldType.NAME,
                            readOnly: true,
                            controller: fromDateController,
                            decoration: InputDecoration(
                              labelText: 'From Date',
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                onPressed: () async {
                                  final DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: fromDate,
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime.now(),
                                  );
                                  if (picked != null) {
                                    setState(() {
                                      fromDate = picked;
                                      fromDateController.text = DateFormat.yMMMd().format(picked);
                                    });
                                  }
                                },
                                icon: const Icon(FeatherIcons.calendar),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: AppTextField(
                            textFieldType: TextFieldType.NAME,
                            readOnly: true,
                            controller: toDateController,
                            decoration: InputDecoration(
                              labelText: 'To Date',
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                onPressed: () async {
                                  final DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: toDate,
                                    firstDate: fromDate,
                                    lastDate: DateTime.now(),
                                  );
                                  if (picked != null) {
                                    setState(() {
                                      toDate = picked;
                                      toDateController.text = DateFormat.yMMMd().format(picked);
                                    });
                                  }
                                },
                                icon: const Icon(FeatherIcons.calendar),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Status Dropdown
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedStatus,
                          isExpanded: true,
                          items: statusOptions.map((String status) {
                            return DropdownMenuItem(
                              value: status,
                              child: Text(status),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                selectedStatus = newValue;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Orders List
              orderData.when(
                data: (orders) {
                  final filteredOrders = orders.where((order) {
                    final orderDate = order["orderDate"] as DateTime;
                    final orderStatus = order["status"] as String;
                    
                    bool dateInRange = orderDate.isAfter(fromDate.subtract(const Duration(days: 1))) && 
                                     orderDate.isBefore(toDate.add(const Duration(days: 1)));
                    bool statusMatch = selectedStatus == 'All' || orderStatus == selectedStatus;
                    
                    return dateInRange && statusMatch;
                  }).toList();

                  return filteredOrders.isEmpty
                      ? const Center(
                          child: Text(
                            'No orders found for selected criteria',
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredOrders.length,
                          itemBuilder: (context, index) {
                            final order = filteredOrders[index];
                            return OrderCard(order: order);
                          },
                        );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('Error: $error')),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderCard({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(order["customerName"]),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(DateFormat.yMMMd().format(order["orderDate"])),
            Text('Status: ${order["status"]}'),
          ],
        ),
        trailing: Text('\$${_calculateTotal(order["items"])}'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDetailsScreen(order: order),
            ),
          );
        },
      ),
    );
  }

  String _calculateTotal(List<dynamic> items) {
    double total = 0;
    for (var item in items) {
      total += (item["price"] * item["quantity"]);
    }
    return total.toStringAsFixed(2);
  }
}
