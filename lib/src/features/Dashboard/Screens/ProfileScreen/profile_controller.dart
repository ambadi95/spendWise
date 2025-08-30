

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendwise/src/features/ExpenseSettings/expenseSettings_screen.dart';

class ProfileController extends GetxController {

List settings = [
  {
    'icon' : Icons.calendar_month,
    'title' : 'Monthly Expense Settings',
    'subTitle' : '>',
    'navTo' : ExpenseSettingsScreen()
  },
  {
    'icon' : Icons.category,
    'title' : 'Manage Categories',
    'subTitle' : '>',
    'navTo' : ''
  }
];


}