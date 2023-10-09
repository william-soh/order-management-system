import 'dart:async';

import 'package:feedme/modules/home/models/bot.dart';
import 'package:feedme/modules/home/models/order.dart';

import 'package:flutter/material.dart';

class OrderProvider extends ChangeNotifier {
  final List<Order> pendingOrders = [];
  final List<Order> processingOrders = [];
  final List<Order> completedOrders = [];
  final List<Bot> bots = [];
  int orderNumber = 1;

  final Map<Order, Timer> orderTimers =
      {}; // Create a map to keep track of timers for each order

  void processOrder(Bot bot, Order order) async {
    order.status = 'PROCESSING';

    if (pendingOrders.isNotEmpty) {
      pendingOrders.removeAt(0);
    }

    late Timer orderTimer; // Declare the timer variable

    try {
      orderTimer =
          Timer(Duration(seconds: order.customerType == 'VIP' ? 5 : 10), () {
        if (bot.processing == true) {
          order.status = 'COMPLETED';
          completedOrders.add(order);
          processingOrders.remove(order);
        }

        bot.processing = false;

        if (pendingOrders.isNotEmpty && order.status != 'PENDING') {
          final firstOrder = pendingOrders.first;

          bot.processing = true;
          firstOrder.remainingTime = firstOrder.customerType == "VIP" ? 5 : 10;
          processingOrders.add(firstOrder);
          firstOrder.botId = bot.id; // Add bot's ID to the order

          startOrderTimer(firstOrder);
          processOrder(bot, firstOrder);
        }

        notifyListeners();
      });
    } catch (e) {
      debugPrint('Timer canceled: $e');
    }
    // Store the timer in the orderTimers map for cancellation
    orderTimers[order] = orderTimer;

    notifyListeners();
  }

  void addBot() {
    final bot = Bot(bots.length + 1, false);
    bots.add(bot);

    if (pendingOrders.isNotEmpty) {
      final order = pendingOrders.first;

      bot.processing = true;
      order.botId = bot.id;
      order.remainingTime = order.customerType == 'VIP' ? 5 : 10;
      processingOrders.add(order);

      startOrderTimer(order);
      processOrder(bot, order);
    }

    notifyListeners();
  }

  void removeBot() {
    if (bots.isNotEmpty) {
      final botToRemove = bots.removeLast();

      if (processingOrders.isNotEmpty && botToRemove.processing == true) {
        botToRemove.processing = false;
        final lastProcessingOrder = processingOrders.last;

        if (lastProcessingOrder.status != "COMPLETED") {
          lastProcessingOrder.status = 'PENDING';
          pendingOrders.add(lastProcessingOrder);
        }

        // Cancel the timer associated with the order being removed
        if (orderTimers.containsKey(lastProcessingOrder)) {
          orderTimers[lastProcessingOrder]?.cancel();
          orderTimers.remove(lastProcessingOrder);
        }

        processingOrders.removeLast();
      }
      // Sort pendingOrders by order number
      pendingOrders.sort((a, b) => a.orderNumber.compareTo(b.orderNumber));
      notifyListeners();
    }
  }

  void submitOrder(String customerType) {
    final order = Order(customerType, "PENDING", orderNumber++,
        customerType == "VIP" ? 5 : 10, 0);
    if (customerType == "VIP") {
      int indexToInsert = 0;
      for (int i = 0; i < pendingOrders.length; i++) {
        if (pendingOrders[i].customerType != "VIP") {
          break;
        }
        indexToInsert++;
      }
      pendingOrders.insert(indexToInsert, order);
    } else {
      pendingOrders.add(order);
    }

    // Try to start processing if there are available bots
    for (final bot in bots) {
      if (!bot.processing) {
        bot.processing = true;
        pendingOrders.first.botId = bot.id;
        processingOrders.add(pendingOrders.first);
        startOrderTimer(order);
        processOrder(bot, order); // Pass the newly created order for processing
        break;
      }
    }
    notifyListeners();
  }

  // Helper method to start a timer for an order
  void startOrderTimer(Order order) {
    try {
      Timer.periodic(const Duration(seconds: 1), (timer) {
        if (order.remainingTime > 0) {
          if (!processingOrders.contains(order)) {
            // Check if the order has been removed from processingOrders
            timer.cancel();
            return;
          }

          order.remainingTime--;
        } else {
          if (orderTimers.containsKey(order)) {
            orderTimers
                .remove(order); // Remove the completed timer from the map
          }

          timer.cancel();
          notifyListeners();
        }
        // Store the timer in the orderTimers map
        orderTimers[order] = timer;
        notifyListeners();
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
