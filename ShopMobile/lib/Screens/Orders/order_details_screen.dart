import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class OrderDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderDetailsScreen({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Debugging: Print the order map to check its contents
    print("Order data: $order");

    final orderDate = order["orderDate"];
    final formattedDate = orderDate != null ? DateFormat('dd MMM yyyy').format(orderDate) : "N/A";
    final formattedTime = orderDate != null ? DateFormat('hh:mm a').format(orderDate) : "N/A";

    double totalPrice = order["items"]?.fold(0.0, (sum, item) => sum + (item["price"] * item["quantity"])) ?? 0.0;

    // Add null check for status
    int currentStep = _getCurrentStep(order["status"] ?? "New");

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Order Details",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 2.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// **Order Progress**
            SizedBox(
              height: 100, // Adjust this value as needed
              child: Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                    primary: Colors.green,
                    onSurface: Colors.grey,
                  ),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 1.2, // Adjust this multiplier as needed
                    child: Stepper(
                      currentStep: currentStep,
                      steps: _buildSteps(currentStep),
                      type: StepperType.horizontal,
                      controlsBuilder: (BuildContext context, ControlsDetails details) {
                        return Container();
                      },
                    ),
                  ),
                ),
              ),
            ),

            /// **Update Status Button**
            Center(
              child: ElevatedButton.icon(
                onPressed: () => _showUpdateStatusDialog(context),
                icon: const Icon(Icons.update),
                label: const Text('Update Status'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// **Customer Details**
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Customer Information", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                    const Divider(),
                    Text("Name: ${order["customerName"] ?? "N/A"}", style: const TextStyle(fontSize: 16)),
                    Text("Phone: ${order["phone"] ?? "N/A"}", style: const TextStyle(fontSize: 16)),
                    Text("Address: ${order["address"] ?? "N/A"}", style: const TextStyle(fontSize: 16)),
                    Text("Order Date: $formattedDate", style: const TextStyle(fontSize: 16)),
                    Text("Order Time: $formattedTime", style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// **Ordered Items List**
            Expanded(
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Ordered Items", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                      const Divider(),
                      Expanded(
                        child: ListView.builder(
                          itemCount: order["items"]?.length ?? 0,
                          itemBuilder: (context, index) {
                            final item = order["items"][index];
                            return ListTile(
                              title: Text(item["name"] ?? "Unknown", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              subtitle: Text("Quantity: ${item["quantity"] ?? 0}"),
                              trailing: Text("\$${(item["price"] * item["quantity"]).toStringAsFixed(2)}"),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /// **Total Price**
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Total Price (Before Tax): \$${totalPrice.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Update the _getCurrentStep method to handle null more gracefully
  int _getCurrentStep(String status) {
    switch (status.toLowerCase()) {  // Convert to lowercase for case-insensitive comparison
      case "processed":
        return 1;
      case "delivering":
        return 2;
      case "delivered":
        return 3;
      default: // "New" or any unknown status
        return 0;
    }
  }

  // Update the _buildSteps method to highlight current step
  List<Step> _buildSteps(int currentStep) {
    return [
      Step(
        title: Text(
          "New",
          style: TextStyle(
            color: currentStep >= 0 ? Colors.green : Colors.grey,
            fontWeight: currentStep >= 0 ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        content: Container(),
        isActive: currentStep >= 0,
        state: currentStep > 0 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: Text(
          "Processed",
          style: TextStyle(
            color: currentStep >= 1 ? Colors.green : Colors.grey,
            fontWeight: currentStep >= 1 ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        content: Container(),
        isActive: currentStep >= 1,
        state: currentStep > 1 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: Text(
          "Delivering",
          style: TextStyle(
            color: currentStep >= 2 ? Colors.green : Colors.grey,
            fontWeight: currentStep >= 2 ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        content: Container(),
        isActive: currentStep >= 2,
        state: currentStep > 2 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: Text(
          "Delivered",
          style: TextStyle(
            color: currentStep >= 3 ? Colors.green : Colors.grey,
            fontWeight: currentStep >= 3 ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        content: Container(),
        isActive: currentStep >= 3,
        state: currentStep >= 3 ? StepState.complete : StepState.indexed,
      ),
    ];
  }

  // Add this method to show the status update dialog
  Future<void> _showUpdateStatusDialog(BuildContext context) async {
    String? selectedStatus = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Update Order Status',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildStatusOption(context, 'New'),
                _buildStatusOption(context, 'Processed'),
                _buildStatusOption(context, 'Delivering'),
                _buildStatusOption(context, 'Delivered'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );

    if (selectedStatus != null) {
      // Handle the status update here
      print('Selected status: $selectedStatus');
      // TODO: Implement your status update logic here
      // For example: updateOrderStatus(selectedStatus);
    }
  }

  // Helper method to build status option buttons
  Widget _buildStatusOption(BuildContext context, String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => Navigator.of(context).pop(status),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            side: const BorderSide(color: Colors.grey),
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            status,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}

class OrderCarousel extends StatefulWidget {
  final List<Map<String, dynamic>> orders;

  const OrderCarousel({Key? key, required this.orders}) : super(key: key);

  @override
  State<OrderCarousel> createState() => _OrderCarouselState();
}

class _OrderCarouselState extends State<OrderCarousel> {
  int currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  void nextOrder() {
    if (currentIndex < widget.orders.length - 1) {
      setState(() {
        currentIndex++;
      });
      _pageController.animateToPage(currentIndex,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void previousOrder() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
      _pageController.animateToPage(currentIndex,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // **Title**
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            "Latest Orders",
            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),

        // **Order Cards with Navigation Arrows**
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 130,
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.orders.length,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final order = widget.orders[index];
                  final formattedDate = DateFormat('dd MMM yyyy').format(order["orderDate"]);
                  final formattedTime = DateFormat('hh:mm a').format(order["orderDate"]);

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderDetailsScreen(order: order),
                        ),
                      );
                    },
                    child: OrderCard(
                      customerName: order["customerName"],
                      orderDate: formattedDate,
                      orderTime: formattedTime,
                      status: order["status"],
                    ),
                  );
                },
              ),
            ),

            // **Left Arrow**
            Positioned(
              left: 0,
              child: Visibility(
                visible: currentIndex > 0,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 24),
                  onPressed: previousOrder,
                ),
              ),
            ),

            // **Right Arrow**
            Positioned(
              right: 0,
              child: Visibility(
                visible: currentIndex < widget.orders.length - 1,
                child: IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, size: 24),
                  onPressed: nextOrder,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class OrderCard extends StatelessWidget {
  final String customerName;
  final String orderDate;
  final String orderTime;
  final String status;

  const OrderCard({
    Key? key,
    required this.customerName,
    required this.orderDate,
    required this.orderTime,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.grey.shade50,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      customerName,
                      style: const TextStyle(
                        fontSize: 16, 
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: status == "New" ? Colors.green.withOpacity(0.1) : Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: status == "New" ? Colors.green : Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        orderDate,
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        orderTime,
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Icon(Icons.arrow_forward, size: 16, color: Colors.grey),
                  Text(
                    " View Details",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}