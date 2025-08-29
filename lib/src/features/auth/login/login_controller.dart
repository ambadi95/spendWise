import 'package:get/get.dart';
import 'package:spendwise/src/features/Dashboard/Dasboard.dart';
import 'package:spendwise/src/features/auth/login/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/auth_services.dart';

class LoginController extends GetxController {
  final _authService = AuthService();
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      if (event == AuthChangeEvent.signedIn) {
        Get.offAll(() => Dashboard());
      } else if (event == AuthChangeEvent.signedOut) {
        Get.offAll(() => LoginScreen());
      }
    });
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      final res = await _authService.signIn(
        email,
        password,
      );
      if (res.user != null) {
        isLoading.value = false;
        Get.offAll(() => Dashboard());
      }
    } on AuthApiException catch (e) {
      isLoading.value = false;
      Get.snackbar("Login Failed", e.message);
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Login Failed", 'Try again later');
    }
  }

  Future<void> googleLogin() async {
    try {
      isLoading.value = true;
      await _authService.signInWithGoogle();
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Login Failed", e.toString());
    }
  }
}
