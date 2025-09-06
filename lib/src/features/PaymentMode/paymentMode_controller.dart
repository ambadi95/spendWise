import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:spendwise/src/core/config/tables.dart';

class PaymentModeController extends GetxController {
  final supabase = Supabase.instance.client;

  /// Observables
  var loading = false.obs;
  var paymentModes = <Map<String, dynamic>>[].obs;
  var paymentModesTransactions = <Map<String, dynamic>>[].obs;

  /// Expense Settings
  int monthlyIncome = 0;
  int monthlyBudget = 0;
  int monthlySavings = 0;
  int monthlyFixedExpenses = 0;
  double totalAmount = 0;
  RxDouble totalSpend = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _initData();
  }

  Future<void> _initData() async {
    await Future.wait([
      fetchPaymentModes(),
    ]);
  }

  ///update Monthly Fixed Expense in DB
  Future<void> updateFixedExpenses(int monthlyFixed, String userId) async {
    await supabase
        .from(EXPENSESETTINGS)
        .update({'payment_mode_limit': monthlyFixed}).eq('user_id', userId);
  }

  /// Fetch Payment Modes
  Future<void> fetchPaymentModes() async {
    _setLoading(true);

    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      _setLoading(false);
      return;
    }

    try {
      final response =
          await supabase.from(PAYMENTMODE).select().eq('user_id', userId);

      totalAmount = response.fold<double>(
        0,
        (previousValue, element) =>
            previousValue +
            (element['monthly_expense_limit'] as num).toDouble(),
      );

      paymentModes.value = List<Map<String, dynamic>>.from(response);

      await updateFixedExpenses(totalAmount.toInt(), userId);
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch payment modes: $e");
    } finally {
      _setLoading(false);
    }
  }

  /// Add Payment Mode
  Future<void> addPaymentMode({
    required String type,
    required String name,
    required String monthlyLimit,
    int? cardDue,
    int? cardBillDate,
  }) async {
    _setLoading(true);

    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      _setLoading(false);
      return;
    }

    try {
      final response = await supabase.from(PAYMENTMODE).insert({
        'user_id': userId,
        'type': type,
        'name': name,
        'monthly_expense_limit': monthlyLimit,
        'card_bill_date': cardBillDate,
        'due_date': cardDue,
      }).select();

      if (response.isNotEmpty) {
        await fetchPaymentModes();
        Get.snackbar(
          "Added Successfully",
          "Expense Added Successfully",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
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
  Future<void> deletePaymentMode({required int id}) async {
    _setLoading(true);

    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      _setLoading(false);
      return;
    }

    try {
      final response =
          await supabase.from(PAYMENTMODE).delete().eq('id', id).select();

      if (response.isNotEmpty) {
        await fetchPaymentModes();
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

  ///update Monthly Fixed Expense in DB
  Future<void> getTransactionsByPaymentMode(int id) async {
    _setLoading(true);

    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      _setLoading(false);
      return;
    }
    var response =
        await supabase.from(TRANSACTIONS).select().eq('payment_mode_id', id);
    if (response.isNotEmpty) {
      _setLoading(false);
      totalSpend.value = response.fold<double>(
        0,
            (previousValue, element) =>
        previousValue +
            (element['amount'] as num).toDouble(),
      );
      paymentModesTransactions.value =
          List<Map<String, dynamic>>.from(response);
    }
    _setLoading(false);
  }

  /// Helper: manage loading state
  void _setLoading(bool value) {
    loading.value = value;
  }
}
