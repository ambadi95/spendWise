import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendwise/src/core/widgets/SlidableCard.dart';
import 'monthlyFixedExpense_controller.dart';
import 'monthlyFixed_expense_form_screen.dart';

class MonthlyFixedExpenseScreen extends StatelessWidget {
  const MonthlyFixedExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MonthlyFixedExpenseController controller =
        Get.put(MonthlyFixedExpenseController());
    return Scaffold(
      body: Obx(() {
        if (controller.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              const Text(
                'Monthly Expenses',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Expense : ${controller.totalAmount}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  InkWell(
                      child: const Card(
                        color: Colors.teal,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.add),
                        ),
                      ),
                      onTap: () async {
                        await Get.to(const MonthlyFixedExpenseForm());
                        controller.fetchMonthlyExpense();
                      }),
                ],
              ),
              controller.expenses.isNotEmpty
                  ? ListView.builder(
                      itemCount: controller.expenses.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, index) {
                        return SlidableCard(
                          onPressDelete: (_) => controller.deletePaymentMode(
                              id: controller.expenses[index]['id']),
                          title: Text(controller.expenses[index]['name']),
                          subTitle:
                              Text(controller.expenses[index]['type']),
                          trailing: Text(
                              'Limit : ${controller.expenses[index]['amount']}'),
                        );
                      })
                  : const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Center(child: Text('No Expenses Added')),
                    ),
              const SizedBox(height: 10),
              // PaymentModeAddButton(
              //     onTap: () async {

              //     })
            ],
          ),
        );
      }),
    );
  }
}
