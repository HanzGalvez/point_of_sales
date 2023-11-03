import 'package:flutter/material.dart';

import '../screen/order_screen.dart';

class MyFloatingActionOrder extends StatelessWidget {
  const MyFloatingActionOrder({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      foregroundColor: Colors.white,
      backgroundColor: Colors.green[700],
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OrderScreen(),
          ),
        );
      },
      child: const Icon(
        Icons.shopping_cart_outlined,
      ),
    );
  }
}
