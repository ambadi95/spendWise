import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendwise/src/features/Dashboard/Dasboard.dart';
import 'package:spendwise/src/features/auth/login/login_controller.dart';
import 'package:spendwise/src/features/auth/signup/signup_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    _setupAuthListener();
    super.initState();
  }

  final supabase = Supabase.instance.client;
  void _setupAuthListener() {
    supabase.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      if (event == AuthChangeEvent.signedIn) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Dashboard(),
          ),
        );
      }
    });
  }

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final LoginController authC = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email")),
            TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () => authC.login(
                    _emailController.text, _passwordController.text),
                child: const Text("Login")),
            Obx(() {
              if (authC.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              return const SizedBox();
            }),
            // Google login button
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.login),
              label: const Text("Continue with Google"),
              onPressed: authC.googleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),

            TextButton(
              onPressed: () => { Get.offAll(() => SignUpScreen())},
              child: const Text("Don’t have an account? Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}
