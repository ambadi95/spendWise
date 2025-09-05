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
  final RxString selectedPaymentType = 'Bank'.obs;
  final selectedMyPaymentMode = RxnString();

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

  bool validateForm() {
    if (titleController.text.isEmpty) {
      Get.snackbar("Error", "Title is required");
      return false;
    }

    if (amountController.text.isEmpty) {
      Get.snackbar("Error", "Amount is required");
      return false;
    }

    if (selectedPaymentType.value.isEmpty) {
      Get.snackbar("Error", "Payment type is required");
      return false;
    }

    if (selectedCategory.value.isEmpty) {
      Get.snackbar("Error", "Category is required");
      return false;
    }

    // Conditional check
    if ((selectedPaymentType.value.toLowerCase() == "bank" ||
        selectedPaymentType.value.toLowerCase() == "credit card") &&
        selectedMyPaymentMode.value == null) {
      Get.snackbar("Error", "Payment mode is required for bank or credit card");
      return false;
    }
    return true; // all good
  }

  @override
  Widget build(BuildContext context) {
    if (data != null) {
      titleController.text = data['title'];
      amountController.text = data['amount'].toString();
      selectedPaymentType.value = data['payment_type'];
      selectedCategory.value = data['category'];
      if(controller.myPaymentModes.isNotEmpty && data['payment_mode_id'] != null){
        selectedMyPaymentMode.value = data['payment_mode_id'].toString();
      }
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
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
                        value: selectedPaymentType.value,
                        items: paymentMode
                            .map(
                                (e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) selectedPaymentType.value = val;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Payment Type',
                        ),
                      ),
                      if(selectedPaymentType.value == 'Bank' || selectedPaymentType.value == 'Credit Card')
                      DropdownButtonFormField<String>(
                        value: selectedMyPaymentMode.value,
                        items: controller.myPaymentModes.where((item) => item['type'] == selectedPaymentType.value)
                            .map(
                                (e) => DropdownMenuItem<String>(value: e['id'].toString(), child: Text(e['name'])))
                            .toList(),
                        onChanged: (val) {
                          if (val != null)  selectedMyPaymentMode.value = val;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Payment Mode',
                          hintText: 'Select you Payment methods'
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

                  if (validateForm()) {
                    if (data != null) {
                      await controller.editExpense(
                          id: data['id'].toString(),
                          title: title,
                          amount: amount!,
                          category: category,
                          paymentType: selectedPaymentType.value,
                          paymentMode: selectedMyPaymentMode.value!
                      );
                    } else {
                      await controller.addExpense(
                          title: title,
                          amount: amount!,
                          category: category,
                          paymentType: selectedPaymentType.value,
                          paymentMode: selectedMyPaymentMode.value
                      );
                    }
                  }

                  // Clear fields after adding
                  titleController.clear();
                  amountController.clear();
                  selectedCategory.value = 'Food';

                  Get.back(); // Close the page
                },
                child: Text(data != null ? 'Update Expense' : 'Add Expense'),
              ),
              data != null
                  ? ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                        controller.deleteExpense(id: data['id']);
                        Get.back();
                      },
                      child: const Text('Delete Expense', style: TextStyle(
                        color: Colors.white
                      ),))
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
