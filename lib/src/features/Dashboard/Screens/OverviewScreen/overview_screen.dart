import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'overview_controller.dart';

class OverviewScreen extends StatelessWidget {
  final double budget = 20000;
  final double expenses = 12500;

  final OverviewController controller = Get.put(OverviewController());

  OverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add), onPressed: () => {}),
        body: Obx(() {
          if (controller.loading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.transactions.isEmpty) {
            return const Center(child: Text('No transactions found.'));
          }
          return Padding(
            padding: const EdgeInsets.only(top: 40, left: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Expenses / Budget Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Expenses / Monthly Budget",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Text("₹$expenses / ₹$budget",
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: expenses / budget,
                        color: Colors.teal,
                        backgroundColor: Colors.grey[300],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Recent Transactions",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('Total spend ${controller.totalAmount.toString()}'),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.transactions.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.shopping_cart,
                              color: Colors.teal),
                          title: Text(controller.transactions[index]['title']),
                          subtitle:
                              Text(controller.transactions[index]['category']),
                          trailing: Text(
                              "- ₹${controller.transactions[index]['amount']}"),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          );
        }));
  }
}
