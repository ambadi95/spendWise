

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OverviewController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    fetchTransactions();
  }

  final supabase = Supabase.instance.client;
  // Observable list of transactions
  var transactions = <Map<String, dynamic>>[].obs;
  var loading = true.obs;
  String currentUserName = '';
  double totalAmount = 0;

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
        .from('transactions')
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

    final response = await supabase.from('transactions').insert({
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
      // Refresh the transactions
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
    await supabase.from('transactions').update({
      'title': title,
      'amount': amount,
      'category': category,
      'payment_type' : paymentMode,
    }).eq('id', id);

    await fetchTransactions();
  }

}