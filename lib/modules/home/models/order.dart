class Order {
  final String customerType;
  String status;
  final int orderNumber;
  int remainingTime;
  int botId; // Store the bot ID processing the order

  Order(
    this.customerType,
    this.status,
    this.orderNumber,
    this.remainingTime,
    this.botId,
  );
}
