import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendwise/src/core/constants.dart';
import 'common_edit_update_controller.dart';

class CommonEditUpdateScreen extends StatefulWidget {
  final int? initialNumber;
  final String? title;
  final ExpenseType? type;

  const CommonEditUpdateScreen(
      {super.key, this.initialNumber, this.title = 'Sample', this.type});

  @override
  State<CommonEditUpdateScreen> createState() => _NumberInputScreenState();
}

class _NumberInputScreenState extends State<CommonEditUpdateScreen> {
  final CommonEditUpdateController controller =
      Get.put(CommonEditUpdateController());
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    // Prefill with initial value if available
    _textController =
        TextEditingController(text: widget.initialNumber?.toString() ?? "");
    if (widget.initialNumber != null) {
      controller.setNumber(widget.initialNumber!);
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isUpdate = widget.initialNumber != null;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 50,
            ),
            Text(
              widget.title!,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _textController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: "Enter ${widget.title!}",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async{
                if(isUpdate) {
                  if (widget.type == ExpenseType.MONTHLY_INCOME) {
                    await controller.updateMonthlyIncome(_textController.text);
                  } else if(widget.type == ExpenseType.MONTHLY_BUDGET) {
                    await controller.updateMonthlyBudget(_textController.text);
                  } else{
                    await controller.updateMonthlySavings(_textController.text);
                  }
                }else{
                  if (widget.type == ExpenseType.MONTHLY_INCOME) {
                    await controller.addMonthlyIncome(_textController.text);
                  } else if(widget.type == ExpenseType.MONTHLY_BUDGET) {
                    await controller.addMonthlyBudget(_textController.text);
                  }else {
                    await controller.addMonthlySavings(_textController.text);
                  }
                }
              },
              child: Text(isUpdate ? "Update" : "Save"),
            ),
          ],
        ),
      ),
    );
  }
}
