import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendwise/src/core/utils.dart';
import 'package:spendwise/src/core/widgets/SlidableCard.dart';
import 'addexpense_screen.dart';
import 'overview_controller.dart';

class OverviewScreen extends StatelessWidget {
  final OverviewController controller = Get.put(OverviewController());

  OverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () async {
              await Get.to(AddExpenseScreen());
              await controller.fetchTransactions();
            }),
        body: Obx(() {
          if (controller.loading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.transactions.isEmpty) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                      child: Text(
                    'Welcome ${controller.currentUserName}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  )),
                  const SizedBox(
                    height: 20,
                  ),
                  const Center(child: Text('No transactions found.')),
                  const SizedBox(
                    height: 20,
                  ),
                  FloatingActionButton(
                      child: const Icon(Icons.add),
                      onPressed: () async {
                        await Get.to(AddExpenseScreen());
                        await controller.fetchTransactions();
                      }),
                ],
              ),
            );
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
                      Text(
                          "₹${controller.totalAmount} / ₹${controller.monthlyBudget}",
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value:
                            controller.totalAmount / controller.monthlyBudget.toInt(),
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
                controller.transactions.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: controller.transactions.length,
                          itemBuilder: (context, index) {
                            return SlidableCard(
                              onPressDelete: (_) => controller.deleteExpense(
                                  id: controller.transactions[index]['id']),
                              onTap: () {
                                Get.to(AddExpenseScreen(
                                  data: controller.transactions[index],
                                ));
                              },
                              title: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      controller.transactions[index]['title'],
                                      style: const TextStyle(
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                  ),
                                  const Text(' | '),
                                  Text(controller.transactions[index]
                                      ['category']),
                                ],
                              ),
                              subTitle: Row(
                                children: [
                                  Text(
                                      '${controller.transactions[index]['payment_type']} Transaction'),
                                ],
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(formatFriendlyDate(
                                      controller.transactions[index]
                                          ['transaction_date'])),
                                  Text(
                                      "- ₹${controller.transactions[index]['amount']}"),
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    : const Center(
                        child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('No Transactions yet'),
                      ))
              ],
            ),
          );
        }));
  }
}
