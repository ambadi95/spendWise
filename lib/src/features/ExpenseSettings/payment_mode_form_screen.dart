import 'package:flutter/material.dart';
import 'package:spendwise/src/features/ExpenseSettings/expenseSettings_controller.dart';

class PaymentModeForm extends StatefulWidget {
  const PaymentModeForm({super.key});

  @override
  State<PaymentModeForm> createState() => _PaymentModeFormState();
}

class _PaymentModeFormState extends State<PaymentModeForm> {
  final controller = ExpenseSettingsController();

  final _formKey = GlobalKey<FormState>();

  String? _selectedType;
  final _titleController = TextEditingController();
  final _monthlyLimitController = TextEditingController();
  DateTime? _dueDate;
  DateTime? _billDate;

  Future<void> _pickDate(BuildContext context, bool isDueDate) async {
    final today = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: DateTime(today.year, today.month),
      lastDate: DateTime(today.year + 5),
      helpText: isDueDate ? "Select Due Date" : "Select Bill Generation Date",
    );
    if (picked != null) {
      setState(() {
        if (isDueDate) {
          _dueDate = picked;
        } else {
          _billDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Payment Mode")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Dropdown
              DropdownButtonFormField<String>(
                value: _selectedType,
                items: const [
                  DropdownMenuItem(
                      value: "Credit Card", child: Text("Credit Card")),
                  DropdownMenuItem(value: "Bank", child: Text("Bank")),
                  DropdownMenuItem(value: "Wallet", child: Text("Wallet")),
                ],
                onChanged: (value) {
                  setState(() => _selectedType = value);
                },
                decoration: const InputDecoration(
                  labelText: "Type",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null ? "Please select a type" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Give a Name",
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? "Enter a name" : null,
              ),
              const SizedBox(height: 16),
              // Credit Card-specific fields
              if (_selectedType == "Credit Card") ...[
                const SizedBox(height: 16),
                ListTile(
                  title: Text(
                    _dueDate == null
                        ? "Select Due Date"
                        : "Due Date: ${_dueDate!.day} of every month",
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () => _pickDate(context, true),
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: Text(
                    _billDate == null
                        ? "Select Bill Generation Date"
                        : "Bill Date: ${_billDate!.day} of every month",
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () => _pickDate(context, false),
                ),
                const SizedBox(height: 16),
              ],

              // Monthly Expense Limit (common)
              TextFormField(
                controller: _monthlyLimitController,
                decoration: const InputDecoration(
                  labelText: "Monthly Expense Limit",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Save data
                    controller.addPaymentMode(
                       type:  _selectedType!,
                       name:  _titleController.text,
                       monthlyLimit:  _monthlyLimitController.text,
                       cardBillDate:  _billDate?.day,
                       cardDue:  _dueDate?.day);
                  }
                },
                child: const Text("Save"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
