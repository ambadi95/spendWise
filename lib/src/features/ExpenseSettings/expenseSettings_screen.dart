import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendwise/src/features/ExpenseSettings/expenseSettings_controller.dart';
import 'package:spendwise/src/features/ExpenseSettings/payment_mode_form_screen.dart';
import 'package:spendwise/src/features/ExpenseSettings/widgets/payment_mode_add_button.dart';

class ExpenseSettingsScreen extends StatelessWidget {
  const ExpenseSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ExpenseSettingsController());
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Obx(() {
        if (controller.loading.value) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                'My Expense Settings',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              // Use Card for better visual grouping
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16),
                  child: Column(
                    children: [
                      _buildSettingRow(
                          'Monthly Income', controller.monthlyIncome),
                      const Divider(),
                      _buildSettingRow(
                          'Monthly Budget', controller.monthlyBudget),
                      const Divider(),
                      _buildSettingRow('Monthly Fixed Expenses',
                          controller.monthlyFixedExpenses),
                      const Divider(),
                      _buildSettingRow(
                          'Monthly Savings', controller.monthlySavings),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'My Payments Modes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              controller.paymentModes.isNotEmpty
                  ? ListView.builder(
                      itemCount: controller.paymentModes.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, index) {
                        return Card(
                          child: ListTile(
                            title: Text(controller.paymentModes[index]['name']),
                            subtitle:
                                Text(controller.paymentModes[index]['type']),
                            trailing: Text(
                                'Limit : ${controller.paymentModes[index]['monthly_expense_limit']}'),
                          ),
                        );
                      })
                  : const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Center(child: Text('No Payment Mode Added')),
                    ),
              const SizedBox(height: 10),
              PaymentModeAddButton(
                  onTap: () async {
                  await Get.to(()=> const PaymentModeForm());
                   controller.fetchPaymentModes();
                  })
            ],
          );
        }
      }),
    ));
  }

  Widget _buildSettingRow(String title, int value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          '₹${value.toString()}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        )
      ],
    );
  }
}
