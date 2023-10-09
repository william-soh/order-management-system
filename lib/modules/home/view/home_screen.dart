import 'package:feedme/modules/home/provider/order_provider.dart';
import 'package:feedme/modules/home/view/component/container_list_widget.dart';
import 'package:feedme/modules/home/view/component/order_timer_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("McDonald's Order Processing"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Bots: ${orderProvider.bots.length}"),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: orderProvider.addBot,
                    child: const Text("+ Bot"),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: orderProvider.removeBot,
                    child: const Text("- Bot"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => orderProvider.submitOrder("Normal"),
              child: const Text("New Normal Order"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => orderProvider.submitOrder("VIP"),
              child: const Text("New VIP Order"),
            ),
            ContainerListWidget(
              title: "Pending Orders:",
              widget: ListView.builder(
                itemCount: orderProvider.pendingOrders.length,
                itemBuilder: (context, index) {
                  final order = orderProvider.pendingOrders[index];

                  return ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 0.0,
                      horizontal: 15.0,
                    ),
                    title: Text(
                      "Order #${order.orderNumber} - ${order.customerType}",
                      style: const TextStyle(fontSize: 12),
                    ),
                    subtitle: Text(
                      "Status: ${order.status}",
                      style: const TextStyle(fontSize: 12),
                    ),
                  );
                },
              ),
            ),
            ContainerListWidget(
              title: "Processing Orders:",
              widget: ListView.builder(
                itemCount: orderProvider.bots.length,
                itemBuilder: (context, botIndex) {
                  final bot = orderProvider.bots[botIndex];
                  final botOrders = orderProvider.processingOrders
                      .where((order) => order.botId == bot.id)
                      .toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 10.0, bottom: 10.0),
                        child: Text(
                          "Bot #${bot.id.toString()} - ${bot.processing ? 'Processing' : 'Idle'}",
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: botOrders.length,
                        itemBuilder: (context, orderIndex) {
                          final order = botOrders[orderIndex];

                          return ListTile(
                            dense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 0.0,
                              horizontal: 15.0,
                            ),
                            title: Text(
                              "Order #${order.orderNumber} - ${order.customerType}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                            subtitle: bot.processing
                                ? OrderTimerWidget(order: order)
                                : const SizedBox.shrink(),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
            ContainerListWidget(
                title: "Completed Orders:",
                widget: ListView.builder(
                  itemCount: orderProvider.completedOrders.length,
                  itemBuilder: (context, index) {
                    final order = orderProvider.completedOrders[index];

                    return ListTile(
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0.0,
                        horizontal: 15.0,
                      ),
                      title: Text(
                        "Order #${order.orderNumber} - ${order.customerType}",
                        style: const TextStyle(fontSize: 12),
                      ),
                    );
                  },
                ))
          ],
        ),
      ),
    );
  }
}
