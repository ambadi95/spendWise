import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendwise/src/core/config/database.dart';
import 'package:spendwise/src/features/Dashboard/Dasboard.dart';
import 'package:spendwise/src/features/auth/login/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseConfig.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    final currentUser = supabase.auth.currentUser;
    return GetMaterialApp(
      title: 'SpendWise',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: currentUser == null ? LoginScreen() : Dashboard(),
    );
  }
}

