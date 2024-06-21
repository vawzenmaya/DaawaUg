import 'package:flutter/material.dart';

class PaymentOption extends StatelessWidget {
  const PaymentOption({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose a Donation Method'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Divider(color: Colors.grey),
          PaymentMethodItem(
            icon: Image.asset('assets/visa.png', width: 40, height: 40),
            title: 'VISA CARD',
            onTap: () {
              // Handle VISA card tap
            },
          ),
          const Divider(color: Colors.grey),
          PaymentMethodItem(
            icon: Image.asset('assets/mastercard.png', width: 40, height: 40),
            title: 'MASTER CARD',
            isChecked: false,
            onTap: () {
              // Handle MasterCard tap
            },
          ),
          const Divider(color: Colors.grey),
          PaymentMethodItem(
            icon: Image.asset('assets/paypal.png', width: 40, height: 40),
            title: 'PAYPAL',
            onTap: () {
              // Handle PayPal tap
            },
          ),
          const Divider(color: Colors.grey),
          PaymentMethodItem(
            icon: Image.asset('assets/mobile.png', width: 40, height: 40),
            title: 'MOBILE MONEY',
            onTap: () {
              // Handle Mobile Money tap
            },
          ),
          const Divider(color: Colors.grey),
        ],
      ),
    );
  }
}

class PaymentMethodItem extends StatelessWidget {
  final Image icon;
  final String title;
  final bool isChecked;
  final VoidCallback onTap;

  const PaymentMethodItem({
    super.key,
    required this.icon,
    required this.title,
    this.isChecked = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                icon,
                const SizedBox(width: 16.0),
                Text(title),
              ],
            ),
            if (isChecked) const Icon(Icons.check_circle, color: Colors.green),
          ],
        ),
      ),
    );
  }
}
