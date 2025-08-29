

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OverviewController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    fetchTransactions();
  }

  final supabase = Supabase.instance.client;
  final supabaseTable = Supabase.instance.client;

  // Observable list of transactions
  var transactions = <Map<String, dynamic>>[].obs;
  var loading = true.obs;
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

    final response = await supabase
        .from('transactions')
        .select('*')
        .eq('user_id', userId);

    totalAmount = response.fold<double>(
      0,
          (previousValue, element) =>
      previousValue + (element['amount'] as num).toDouble(),
    );
    transactions.value = List<Map<String, dynamic>>.from(response);

    loading.value = false;
  }


}