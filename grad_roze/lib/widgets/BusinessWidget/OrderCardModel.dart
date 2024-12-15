class OrderCardModel {
  final String orderId;
  final String customerUsername;
  final List<String> bouquetsId;
  final List<String> businessUsername;
  final int totalPrice;
  final String time;
  String status;
  int? businessSpecificTotal;

  OrderCardModel({
    required this.orderId,
    required this.customerUsername,
    required this.bouquetsId,
    required this.businessUsername,
    required this.totalPrice,
    required this.time,
    required this.status,
    this.businessSpecificTotal,
  });
}
