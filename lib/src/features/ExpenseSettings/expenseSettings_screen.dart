import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendwise/src/core/constants.dart';
import 'package:spendwise/src/features/ExpenseSettings/common_screen/common_edit_update_screen.dart';
import 'package:spendwise/src/features/ExpenseSettings/expenseSettings_controller.dart';
import 'package:spendwise/src/features/MonthlyExpense/monthlyFixedExpense_screen.dart';

import '../PaymentMode/paymentMode_screen.dart';

class ExpenseSettingsScreen extends StatelessWidget {
  const ExpenseSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ExpenseSettingsController controller =
        Get.put(ExpenseSettingsController());
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
              _buildSettingsList(
                () {
                  Get.to( CommonEditUpdateScreen(
                    title: 'Monthly Income',
                    initialNumber: controller.monthlyIncome.toInt(),
                    type: ExpenseType.MONTHLY_INCOME
                  ));
                },
                'Monthly Income',
                controller.monthlyIncome.toString(),
                Icons.calendar_view_month,
              ),
              _buildSettingsList(() {
                Get.to( CommonEditUpdateScreen(
                  title: 'Monthly Budget',
                  initialNumber: controller.monthlyBudget.toInt(),
                    type: ExpenseType.MONTHLY_BUDGET
                ));
              }, 'Monthly Budget',
                  controller.monthlyBudget.toString(), Icons.show_chart),
              _buildSettingsList(() {
                Get.to( CommonEditUpdateScreen(
                    title: 'Monthly Savings',
                    initialNumber: controller.monthlySavings.toInt(),
                    type: ExpenseType.MONTHLY_SAVING
                ));
              }, 'Monthly Savings',
                  controller.monthlySavings.toString(), Icons.savings_rounded),
              _buildSettingsList(() {
               Get.to(const MonthlyFixedExpenseScreen());
              }, 'Monthly Fixed Expenses',
                  controller.monthlyFixedExpenses.toString(), Icons.payment_outlined),
              _buildSettingsList(() {
                Get.to(const PaymentModeScreen());
              }, 'Payment Modes',
                  'Total Limit : ${controller.paymentModeLimit}', Icons.payment_outlined),
              const SizedBox(height: 10),
            ],
          );
        }
      }),
    ));
  }

  Widget _buildSettingsList(
      Function() onTap, String title, String subtitle, IconData leadingIcon) {
    return ListTile(
      onTap: onTap,
      title: Text(title),
      titleTextStyle: const TextStyle(
          color: Colors.teal, fontSize: 18, fontWeight: FontWeight.w600),
      subtitle: Text(subtitle),
      subtitleTextStyle: const TextStyle(
          color: Colors.blueGrey, fontSize: 16, fontWeight: FontWeight.w400),
      leading: Icon(
        leadingIcon,
        size: 30,
        color: Colors.teal,
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.teal,
      ),
    );
  }
}
