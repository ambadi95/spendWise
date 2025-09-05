import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendwise/src/core/config/tables.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OverviewController extends GetxController {


  final supabase = Supabase.instance.client;
  // Observable list of transactions
  var transactions = <Map<String, dynamic>>[].obs;
  var myPaymentModes = <Map<String, dynamic>>[].obs;
  var selectedMyPaymentMode = RxnString();
  var loading = true.obs;
  String currentUserName = '';
  var totalAmount = 0.0.obs;
  var monthlyBudget = 0.obs;

  @override
  void onInit() {
    super.onInit();
    myPaymentModes.value = [];
    fetchTransactions();
    fetchMonthlyBudget();
    getAllPaymentMode();
  }

  Future<void> fetchMonthlyBudget() async {
    loading.value = true;
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      loading.value = false;
      return;
    }
    final response = await supabase
        .from(EXPENSESETTINGS)
        .select()
        .eq('user_id', userId)
        .single();
    var data = response;
    monthlyBudget.value = data['monthly_budget'] ?? 0;
    loading.value = false;
  }

  // Fetch all transactions for the current user
  Future<void> fetchTransactions() async {
    loading.value = true;
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      transactions.value = [];
      loading.value = false;
      return;
    }
    currentUserName = supabase.auth.currentUser?.userMetadata?['full_name'];
    final response =
        await supabase.from(TRANSACTIONS).select().eq('user_id', userId);

    totalAmount.value = response.fold<double>(
      0,
      (previousValue, element) =>
          previousValue + (element['amount'] as num).toDouble(),
    );
    transactions.value = List<Map<String, dynamic>>.from(response);

    loading.value = false;
  }

  String? getPaymentModeName(List<Map<String, dynamic>> myPaymentModes, String? paymentMode) {
    if (paymentMode == null) return null; // optional → return null safely

    final mode = myPaymentModes.firstWhereOrNull(
          (item) => item['id'] == int.tryParse(paymentMode),
    );

    return mode?['name']; // returns null if not found
  }

  Future<void> addExpense(
      {required String title,
      required double amount,
      required String category,
      required String paymentType,
      required String? paymentMode
      }) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    final paymentModeName = getPaymentModeName(myPaymentModes, paymentMode);

    final response = await supabase.from(TRANSACTIONS).insert({
      'user_id': userId,
      'title': title,
      'amount': amount,
      'category': category,
      'payment_type': paymentType,
      'payment_mode' : paymentModeName,
      'transaction_type': 'DEBIT',
      'transaction_date': DateTime.now().toIso8601String(),
      'payment_mode_id' : paymentMode
    });

    if (response != null) {
      await fetchTransactions();
    }
  }

  Future<void> editExpense({
    required String id,
    required String title,
    required double amount,
    required String category,
    required String paymentType,
    required String? paymentMode
  }) async {

    final paymentModeName = getPaymentModeName(myPaymentModes, paymentMode);

    final response = await supabase
        .from(TRANSACTIONS)
        .update({
          'title': title,
          'amount': amount,
          'category': category,
          'payment_type': paymentType,
          'payment_mode' : paymentModeName,
          'payment_mode_id' : paymentMode
        })
        .eq('id', id)
        .select();
    if (response.isNotEmpty) {
      await fetchTransactions();
    }
  }

  Future<void> deleteExpense({required int id}) async {
    final response =
        await supabase.from(TRANSACTIONS).delete().eq('id', id).select();
    if (response.isNotEmpty) {
      Get.snackbar(
        "Deleted",
        "Expense Deleted Successfully",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      await fetchTransactions();
    }
  }

  Future<void> getAllPaymentMode() async {
    loading.value = true;
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;
    final response =
        await supabase.from(PAYMENTMODE).select().eq('user_id', userId);
    if (response.isNotEmpty) {
      myPaymentModes.value = List<Map<String, dynamic>>.from(response);
      loading.value = false;
    }
  }
}
