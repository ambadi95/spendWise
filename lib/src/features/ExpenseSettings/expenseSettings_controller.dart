import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:spendwise/src/core/config/tables.dart';

class ExpenseSettingsController extends GetxController {
  final supabase = Supabase.instance.client;

  /// Observables
  var loading = false.obs;
  var paymentModes = <Map<String, dynamic>>[].obs;

  /// Expense Settings
  int monthlyIncome = 0;
  int monthlyBudget = 0;
  int monthlySavings = 0;
  int monthlyFixedExpenses = 0;

  @override
  void onInit() {
    super.onInit();
    _initData();
  }

  Future<void> _initData() async {
    await Future.wait([
      fetchSettings(),
      fetchPaymentModes(),
    ]);
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

      monthlyIncome = response['monthly_income'] ?? 0;
      monthlyBudget = response['monthly_budget'] ?? 0;
      monthlySavings = response['monthly_savings'] ?? 0;
      monthlyFixedExpenses = response['monthly_fixed_expenses'] ?? 0;
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
        await fetchPaymentModes(); // refresh list
        Get.back();
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
