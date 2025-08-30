import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendwise/src/features/auth/login/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignupController extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;

  var isLoading = false.obs;

  // Email/Password signup
  Future<void> signUp(
      String email, String password, String phone, String fullName) async {
    try {
      isLoading.value = true;

      final response = await _supabase.auth
          .signUp(email: email, password: password, data: {
            'phone' : phone,
            'full_name' : fullName
      });

      if (response.user != null) {
        Get.snackbar(
          "Sign Up Success",
          "Please check your email for confirmation",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Navigate to login screen
        Get.offAll(() => const LoginScreen());
      } else {
        Get.snackbar(
          "Sign Up Failed",
          "Unknown error occurred",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } on AuthApiException catch (e) {
      Get.snackbar(
        "Sign Up Failed",
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Sign Up Failed",
        "Try again later",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

// Optional: reuse login & google login methods here
}
