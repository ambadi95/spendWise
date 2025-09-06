import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendwise/src/core/utils.dart';
import 'package:spendwise/src/core/widgets/SlidableCard.dart';
import 'package:spendwise/src/features/PaymentMode/paymentMode_controller.dart';

class PaymentModeDetailScreen extends StatelessWidget {
  final String title;
  final dynamic data;

  PaymentModeDetailScreen({super.key, required this.title, this.data});

  PaymentModeController controller = PaymentModeController();

  @override
  Widget build(BuildContext context) {
    controller.getTransactionsByPaymentMode(data['id']);
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: Obx(() {
            if (controller.loading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            return Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _detailsView('Monthly Limit',
                        data['monthly_expense_limit'].toString()),
                    if (data['type'] == 'Credit Card')
                      _detailsView(
                        'Bill Date',
                        '${dayWithSuffix(data['card_bill_date'])} of month',
                      ),
                    if (data['type'] == 'Credit Card')
                      _detailsView(
                        'Due Date',
                        '${dayWithSuffix(data['due_date'])} of month',
                      ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recent Transactions',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(
                      'Total Spend ${controller.totalSpend}',
                      style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                    ),
                  ],
                ),
                controller.paymentModesTransactions.isNotEmpty
                    ? ListView.builder(
                        itemCount: controller.paymentModesTransactions.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, index) {
                          return SlidableCard(
                            isActionEnabled: false,
                            title: Text(controller
                                .paymentModesTransactions[index]['title']),
                            subTitle: Text(controller
                                .paymentModesTransactions[index]['category']),
                            trailing: Text(
                                '- ${controller.paymentModesTransactions[index]['amount']}'),
                          );
                        })
                    : const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Center(child: Text('No Payment Mode Added')),
                      ),
              ],
            );
          })),
    );
  }

  Widget _detailsView(String title, String subTitle) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          subTitle,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ],
    );
  }
}
