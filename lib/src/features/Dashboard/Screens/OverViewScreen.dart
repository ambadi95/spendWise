import 'package:flutter/material.dart';
import '../../../services/auth_services.dart';

class OverviewScreen extends StatelessWidget {
  final double budget = 20000;
  final double expenses = 12500;

  final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 40, left: 10, right: 10  ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(onPressed: ()=>{_authService.signOut(context)}, icon: const Icon(Icons.logout))
              ],
            ),
            // Expenses / Budget Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.teal.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Expenses / Budget",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text("₹$expenses / ₹$budget",
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: expenses / budget,
                    color: Colors.teal,
                    backgroundColor: Colors.grey[300],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text("Recent Transactions",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.shopping_cart, color: Colors.teal),
                      title: Text("Transaction ${index + 1}"),
                      subtitle: Text("Description for transaction ${index + 1}"),
                      trailing: Text("- ₹${(index + 1) * 500}"),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}