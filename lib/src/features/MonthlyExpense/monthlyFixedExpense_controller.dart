import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:spendwise/src/core/config/tables.dart';

class MonthlyFixedExpenseController extends GetxController {
  final supabase = Supabase.instance.client;

  /// Observables
  var loading = false.obs;
  var expenses = <Map<String, dynamic>>[].obs;

  double totalAmount = 0;

  @override
  void onInit() {
    super.onInit();
    _initData();
  }

  Future<void> _initData() async {
    await Future.wait([
      fetchMonthlyExpense(),
    ]);
  }

  ///update Monthly Fixed Expense in DB
  Future<void> updateFixedExpenses(int monthlyFixed, String userId) async{
    await supabase.from(EXPENSESETTINGS).update({
      'monthly_fixed_expenses' : monthlyFixed
    }).eq('user_id', userId);
  }

  /// Fetch Payment Modes
  Future<void> fetchMonthlyExpense() async {
    _setLoading(true);

    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      _setLoading(false);
      return;
    }

    try {
      final response =
      await supabase.from(MONTHLYFIXEDEXPENSE).select().eq('user_id', userId);

      totalAmount = response.fold<double>(
        0,
            (previousValue, element) =>
        previousValue + (element['amount'] as num).toDouble(),
      );

      expenses.value = List<Map<String, dynamic>>.from(response);

      await updateFixedExpenses(totalAmount.toInt(), userId);

    } catch (e) {
      Get.snackbar("Error", "Failed to fetch payment modes: $e");
    } finally {
      _setLoading(false);
    }
  }

  /// Add Payment Mode
  Future<void> addMonthlyExpense({
    required String type,
    required String name,
    required String amount,
    int? cardDue,
    int? loanAmount,
    String? endDate
  }) async {
    _setLoading(true);

    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      _setLoading(false);
      return;
    }

    try {
      final response = await supabase.from(MONTHLYFIXEDEXPENSE).insert({
        'user_id': userId,
        'type': type,
        'name': name,
        'amount': amount,
        'loan_amount': loanAmount,
        'due_date': cardDue,
        'end_date' : endDate,
      }).select();

      if (response.isNotEmpty) {
        await fetchMonthlyExpense();
        Get.snackbar(
          "Added Successfully",
          "Expense Added Successfully",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.back();
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to add payment mode: $e");
    } finally {
      _setLoading(false);
    }
  }

  /// Add Payment Mode
  Future<void> deletePaymentMode({
    required int id
  }) async {
    _setLoading(true);

    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      _setLoading(false);
      return;
    }

    try {
      final response = await supabase.from(MONTHLYFIXEDEXPENSE).delete().eq('id', id).select();

      if (response.isNotEmpty) {
        await fetchMonthlyExpense();
        Get.snackbar(
          "Deleted",
          "Expense Deleted Successfully",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to add payment mode: $e");
    } finally {
      _setLoading(false);
    }
  }


  /// Helper: manage loading state
  void _setLoading(bool value) {
    loading.value = value;
  }
}
