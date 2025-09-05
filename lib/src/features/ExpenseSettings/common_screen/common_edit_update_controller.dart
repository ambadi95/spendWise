import 'package:get/get.dart';
import 'package:spendwise/src/core/config/tables.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CommonEditUpdateController extends GetxController {
  final supabase = Supabase.instance.client;

  var number = 0.obs;

  void setNumber(int value) {
    number.value = value;
  }

  Future<void> addMonthlyIncome(String monthlyIncome) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;
    final response = await supabase
        .from(EXPENSESETTINGS)
        .insert({'monthly_income': monthlyIncome}).eq('user_id', user.id).select();
    if (response.isNotEmpty) {
      Get.back();
    }
  }

  Future<void> updateMonthlyIncome(String monthlyIncome) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;
    final response = await supabase
        .from(EXPENSESETTINGS)
        .update({'monthly_income': monthlyIncome}).eq('user_id', user.id).select();

    if (response.isNotEmpty) {
      Get.back();
    }
  }

  Future<void> addMonthlyBudget(String monthlyBudget) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;
    final response = await supabase
        .from(EXPENSESETTINGS)
        .insert({'monthly_budget': monthlyBudget}).eq('user_id', user.id).select();
    if (response.isNotEmpty) {
      Get.back();
    }
  }

  Future<void> updateMonthlyBudget(String monthlyBudget) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;
    final response = await supabase
        .from(EXPENSESETTINGS)
        .update({'monthly_budget': monthlyBudget}).eq('user_id', user.id).select();

    if (response.isNotEmpty) {
      Get.back();
    }
  }

  Future<void> addMonthlySavings(String savings) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;
    final response = await supabase
        .from(EXPENSESETTINGS)
        .insert({'monthly_savings': savings}).eq('user_id', user.id).select();
    if (response.isNotEmpty) {
      Get.back();
    }
  }

  Future<void> updateMonthlySavings(String savings) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;
    final response = await supabase
        .from(EXPENSESETTINGS)
        .update({'monthly_savings': savings}).eq('user_id', user.id).select();

    if (response.isNotEmpty) {
      Get.back();
    }
  }

}
