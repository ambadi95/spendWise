

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendwise/src/core/config/tables.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OverviewController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    fetchTransactions();
    fetchMonthlyBudget();
  }

  final supabase = Supabase.instance.client;
  // Observable list of transactions
  var transactions = <Map<String, dynamic>>[].obs;
  var loading = true.obs;
  String currentUserName = '';
  double totalAmount = 0;
  int monthlyBudget = 0;


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
        .eq('user_id', userId).single();
    var data = response;
    monthlyBudget = data['monthly_budget'] ?? 0;
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
    final response = await supabase
        .from(TRANSACTIONS)
        .select()
        .eq('user_id', userId);

    totalAmount = response.fold<double>(
      0,
          (previousValue, element) =>
      previousValue + (element['amount'] as num).toDouble(),
    );
    transactions.value = List<Map<String, dynamic>>.from(response);

    loading.value = false;
  }

  Future<void> addExpense({
    required String title,
    required double amount,
    required String category,
    required String paymentMode
  }) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    final response = await supabase.from(TRANSACTIONS).insert({
      'user_id': userId,
      'title': title,
      'amount': amount,
      'category': category,
      'payment_type' : paymentMode,
      'payment_category' : 'HDFC Bank',
      'transaction_type' : 'DEBIT',
      'transaction_date': DateTime.now().toIso8601String(),
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
    required String paymentMode,
  }) async {
   final response = await supabase.from(TRANSACTIONS).update({
      'title': title,
      'amount': amount,
      'category': category,
      'payment_type' : paymentMode,
    }).eq('id', id).select();
   if(response.isNotEmpty){
     await fetchTransactions();
   }

  }

  Future<void> deleteExpense({required int id})async{
   final response = await supabase.from(TRANSACTIONS).delete().eq('id', id).select();
    if(response.isNotEmpty){
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

}