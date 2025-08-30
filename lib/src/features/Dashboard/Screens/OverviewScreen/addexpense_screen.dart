import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'overview_controller.dart';

class AddExpenseScreen extends StatelessWidget {
  final dynamic data;
  AddExpenseScreen({super.key, this.data});

  final OverviewController controller = Get.find();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final RxString selectedCategory = 'Food'.obs;
  final RxString selectedPaymentMode = 'Bank'.obs;

  final List<String> categories = [
    'Food',
    'Travel',
    'Shopping',
    'Fuel',
    'Other',
  ];

  final List<String> paymentMode = [
    'Bank',
    'Credit Card',
    'Cash',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    if (data != null) {
      titleController.text = data['title'];
      amountController.text = data['amount'].toString();
    }
    return Scaffold(
      appBar:
          AppBar(title: Text(data != null ? 'Update Expense' : 'Add Expense')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount',
              ),
            ),
            const SizedBox(height: 16),
            Obx(() => Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: selectedCategory.value,
                      items: categories
                          .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) selectedCategory.value = val;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Category',
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedPaymentMode.value,
                      items: paymentMode
                          .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) selectedPaymentMode.value = val;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Payment Mode',
                      ),
                    ),
                  ],
                )),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                final title = titleController.text.trim();
                final amount = double.tryParse(amountController.text.trim());
                final category = selectedCategory.value;

                if (title.isEmpty || amount == null) {
                  Get.snackbar('Error', 'Please fill all fields');
                  return;
                }
                if (data != null) {
                  await controller.editExpense(
                      id: data['id'].toString(),
                      title: title,
                      amount: amount,
                      category: category,
                      paymentMode: selectedPaymentMode.value);
                } else {
                  await controller.addExpense(
                      title: title,
                      amount: amount,
                      category: category,
                      paymentMode: selectedPaymentMode.value);
                }

                // Clear fields after adding
                titleController.clear();
                amountController.clear();
                selectedCategory.value = 'Food';

                Get.back(); // Close the page
              },
              child: Text(data != null ? 'Update Expense' : 'Add Expense'),
            )
          ],
        ),
      ),
    );
  }
}
