import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendwise/src/features/ExpenseSettings/expenseSettings_controller.dart';

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
              const SizedBox(
                height: 50,
              ),
              const Text('My Expense Settings',style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),),
              const SizedBox(
                height: 10,
              ),
              Text('Monthly Income : ${controller.monthlyIncome.toString()}'),
              const SizedBox(
                height: 10,
              ),
              Text('Monthly Budget : ${controller.monthlyBudget.toString()}'),
              const SizedBox(
                height: 10,
              ),
              Text(
                  'Monthly Fixed Expenses : ${controller.monthlyFixedExpenses.toString()}'),
              const SizedBox(
                height: 10,
              ),
              Text('Monthly Savings : ${controller.monthlySavings.toString()}'),
            ],
          );
        }
      }),
    ));
  }
}
