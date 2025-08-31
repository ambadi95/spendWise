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
                 'Monthly Income',
                controller.monthlyIncome.toString(),
                Icons.calendar_view_month
              ),
              _buildSettingsList(
                'Monthly Budget',
                controller.monthlyBudget.toString(),
                  Icons.show_chart
              ),
              _buildSettingsList(
                'Monthly Fixed Expenses',
                controller.monthlyFixedExpenses.toString(),
                Icons.area_chart
              ),
              _buildSettingsList(
                'Monthly Savings',
                controller.monthlySavings.toString(),
                Icons.savings_rounded
              ),
              const SizedBox(height: 10),
              // const Text(
              //   'My Payments Modes',
              //   style: TextStyle(
              //     fontSize: 18,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              // controller.paymentModes.isNotEmpty
              //     ? ListView.builder(
              //         itemCount: controller.paymentModes.length,
              //         shrinkWrap: true,
              //         itemBuilder: (BuildContext context, index) {
              //           return Card(
              //             child: ListTile(
              //               title: Text(controller.paymentModes[index]['name']),
              //               subtitle:
              //                   Text(controller.paymentModes[index]['type']),
              //               trailing: Text(
              //                   'Limit : ${controller.paymentModes[index]['monthly_expense_limit']}'),
              //             ),
              //           );
              //         })
              //     : const Padding(
              //         padding: EdgeInsets.all(10.0),
              //         child: Center(child: Text('No Payment Mode Added')),
              //       ),
              // const SizedBox(height: 10),
              // PaymentModeAddButton(
              //     onTap: () async {
              //     await Get.to(()=> const PaymentModeForm());
              //      controller.fetchPaymentModes();
              //     })
            ],
          );
        }
      }),
    ));
  }

  Widget _buildSettingsList(String title, String subtitle, IconData leadingIcon){
    return ListTile(
      title: Text(title),
      titleTextStyle: const TextStyle(
          color: Colors.teal,
          fontSize: 18,
          fontWeight: FontWeight.w600
      ),
      subtitle: Text(subtitle),
      subtitleTextStyle: const TextStyle(
        color: Colors.blueGrey,
        fontSize: 16,
          fontWeight: FontWeight.w400
      ),
      leading: Icon(leadingIcon, size: 30, color: Colors.teal, ),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.teal,),
    );
  }
}
