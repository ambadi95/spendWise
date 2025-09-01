import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:spendwise/src/core/config/tables.dart';

class ExpenseSettingsController extends GetxController {
  final supabase = Supabase.instance.client;
  RealtimeChannel? _subscription;

  /// Observables
  var loading = false.obs;
  var paymentModes = <Map<String, dynamic>>[].obs;

  /// Expense Settings
  var monthlyIncome = 0.obs;
  var monthlyBudget = 0.obs;
  var monthlySavings = 0.obs;
  var monthlyFixedExpenses = 0.obs;
  var paymentModeLimit = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _initData();
    _subscribeRealTime();
  }

  @override
  void onClose() {
    if (_subscription != null) {
      supabase.removeChannel(_subscription!);
    }
    super.onClose();
  }

  Future<void> _initData() async {
    await Future.wait([
      fetchSettings(),
    ]);
  }

  void _subscribeRealTime() {
    final user = supabase.auth.currentUser;
    if (user == null) return;
    _subscription = supabase
        .channel('public:expense_settings:user_id${user.id}')
        .onPostgresChanges(
          event: PostgresChangeEvent.all, // listen to INSERT, UPDATE, DELETE
          schema: 'public',
          table: 'expense_settings',
          filter: PostgresChangeFilter(type: PostgresChangeFilterType.eq, column: 'user_id', value: user.id),
          callback: (payload) {
            if (payload.newRecord.isNotEmpty) {
              monthlyIncome.value = payload.newRecord['monthly_income'];
              monthlyBudget.value =  payload.newRecord['monthly_budget'];
              monthlySavings.value =  payload.newRecord['monthly_savings'];
              monthlyFixedExpenses.value = payload.newRecord['monthly_fixed_expenses'];
              paymentModeLimit.value = payload.newRecord['payment_mode_limit'];
            }
          },
        ).subscribe();
  }

  /// Fetch Expense Settings
  Future<void> fetchSettings() async {
    _setLoading(true);

    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      _setLoading(false);
      return;
    }

    try {
      final response = await supabase
          .from('expense_settings')
          .select()
          .eq('user_id', userId)
          .single();

      monthlyIncome.value = response['monthly_income'] ?? 0;
      monthlyBudget.value = response['monthly_budget'] ?? 0;
      monthlySavings.value = response['monthly_savings'] ?? 0;
      monthlyFixedExpenses.value = response['monthly_fixed_expenses'] ?? 0;
      paymentModeLimit.value = response['payment_mode_limit'] ?? 0;
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch settings: $e");
    } finally {
      _setLoading(false);
    }
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

      paymentModes.value = List<Map<String, dynamic>>.from(response);
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
