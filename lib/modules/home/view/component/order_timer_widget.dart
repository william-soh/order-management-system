import 'package:feedme/modules/home/models/order.dart';
import 'package:flutter/material.dart';

class OrderTimerWidget extends StatelessWidget {
  final Order order;

  const OrderTimerWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final minutes = order.remainingTime ~/ 60;
    final seconds = order.remainingTime % 60;

    return Text(
      "Remaining Time: ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}",
      style: const TextStyle(fontSize: 12),
    );
  }
}
