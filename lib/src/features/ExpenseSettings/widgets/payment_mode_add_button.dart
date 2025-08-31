

import 'package:flutter/material.dart';

class PaymentModeAddButton extends StatelessWidget {
   final VoidCallback  onTap;

   const PaymentModeAddButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: const Card(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
