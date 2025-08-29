import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../services/auth_services.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  final supabase = Supabase.instance.client;
  final _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    final user = supabase.auth.currentUser;
    final profileImageUrl = user?.userMetadata?['avatar_url'];
    final fullName = user?.userMetadata?['full_name'];
    final email = user?.userMetadata?['email'];
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () => {_authService.signOut(context)},
                    icon: const Icon(Icons.logout))
              ],
            ),
            if (profileImageUrl != null)
              ClipOval(
                child: Image.network(
                  profileImageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 16),
            Text(
              fullName ?? '',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              email ?? '',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
