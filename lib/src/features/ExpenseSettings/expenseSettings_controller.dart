

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ExpenseSettingsController extends GetxController{

  @override
  void onInit() {
    super.onInit();
    fetchSettings();
  }

  final supabase = Supabase.instance.client;
  var loading = true.obs;
  int monthlyIncome = 0;
  int monthlyBudget = 0;
  int monthlySavings = 0;
  int monthlyFixedExpenses = 0;

  Future<void> fetchSettings() async {
    loading.value = true;
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      loading.value = false;
      return;
    }
    final response = await supabase
        .from('expense_settings')
        .select()
        .eq('user_id', userId).single();
    var data = response;
    monthlyIncome = data['monthly_income'];
     monthlyBudget = data['monthly_budget'];
    monthlySavings = data['monthly_savings'];
    monthlyFixedExpenses = data['monthly_fixed_expenses'];
    print(data);
    loading.value = false;
  }


}