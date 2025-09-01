import 'package:flutter/material.dart';
import '../../core/utils.dart';
import 'monthlyFixedExpense_controller.dart';

class MonthlyFixedExpenseForm extends StatefulWidget {
  const MonthlyFixedExpenseForm({super.key});

  @override
  State<MonthlyFixedExpenseForm> createState() => _MonthlyFixedExpenseFormState();
}

class _MonthlyFixedExpenseFormState extends State<MonthlyFixedExpenseForm> {
  final controller = MonthlyFixedExpenseController();

  final _formKey = GlobalKey<FormState>();

  String? _selectedType;
  final _titleController = TextEditingController();
  final _amount = TextEditingController();
  DateTime? _dueDate;
  DateTime? _endDate;

  Future<void> _pickDate(BuildContext context, bool isDueDate) async {
    final today = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: DateTime(today.year, today.month),
      lastDate: DateTime(today.year + 40),
      helpText: isDueDate ? "Select Due Date" : "Expense End Date",
    );
    if (picked != null) {
      setState(() {
        if (isDueDate) {
          _dueDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Expense")),
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
                      value: "Loan", child: Text("Loan")),
                  DropdownMenuItem(value: "EMI", child: Text("EMI")),
                  DropdownMenuItem(value: "Credit Card", child: Text("Credit Card")),
                  DropdownMenuItem(value: "Gold", child: Text("Gold")),
                  DropdownMenuItem(value: "SIP", child: Text("SIP")),
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
                    _endDate == null
                        ? "End"
                        : "End Date: ${formatFriendlyDate(_endDate.toString())}",
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () => _pickDate(context, false),
                ),
                const SizedBox(height: 16),

              // Monthly Expense Limit (common)
              TextFormField(
                controller: _amount,
                decoration: const InputDecoration(
                  labelText: "Amount",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Save data
                    controller.addMonthlyExpense(
                       type:  _selectedType!,
                       name:  _titleController.text,
                       amount:  _amount.text,
                       endDate:  _endDate.toString(),
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
