import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendwise/src/core/widgets/SlidableCard.dart';
import 'payment_mode_form_screen.dart';
import 'paymentMode_controller.dart';

class PaymentModeScreen extends StatelessWidget {
  const PaymentModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PaymentModeController controller =
        Get.put(PaymentModeController());
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
                'Payment Modes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total limit : ${controller.totalAmount}',
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
                        await Get.to(const PaymentModeForm());
                        controller.fetchPaymentModes();
                      }),
                ],
              ),
              controller.paymentModes.isNotEmpty
                  ? ListView.builder(
                      itemCount: controller.paymentModes.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, index) {
                        return SlidableCard(
                          onPressDelete: (_) => controller.deletePaymentMode(
                              id: controller.paymentModes[index]['id']),
                          title: Text(controller.paymentModes[index]['name']),
                          subTitle:
                              Text(controller.paymentModes[index]['type']),
                          trailing: Text(
                              'Limit : ${controller.paymentModes[index]['monthly_expense_limit']}'),
                        );
                      })
                  : const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Center(child: Text('No Payment Mode Added')),
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
