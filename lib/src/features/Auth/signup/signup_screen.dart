import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendwise/src/features/auth/login/login_screen.dart';
import 'package:spendwise/src/features/auth/signup/signup_controller.dart';

class SignUpScreen extends StatelessWidget {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final fullName = TextEditingController();
  final phone = TextEditingController();
  final SignupController authC = Get.put(SignupController());

  SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Obx(() => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
             const SizedBox(
                height: 60,
              ),
              TextField(
                controller: fullName,
                decoration: const InputDecoration(labelText: "Full Name"),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phone,
                decoration: const InputDecoration(labelText: "Phone"),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passCtrl,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
              ),
              const SizedBox(height: 32),
              authC.isLoading.value
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: () {
                  final email = emailCtrl.text.trim();
                  final password = passCtrl.text.trim();
                  if (email.isNotEmpty && password.isNotEmpty) {
                    authC.signUp(email, password, phone.text, fullName.text);
                  } else {
                    Get.snackbar(
                      "Error",
                      "Email and password cannot be empty",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                },
                child: const Text("Sign Up"),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Get.offAll(() => const LoginScreen());
                },
                child: const Text("Already have an account? Login"),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
