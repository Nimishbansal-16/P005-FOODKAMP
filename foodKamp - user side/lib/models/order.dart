class OrderItem {
  String itemName;
  int price;
  String id;
  int count;

  OrderItem(this.id, this.itemName, this.count, this.price);
  
}

class Order{
  String orderId;
  String orderDate;
  double totalAmount;
  String status;
  List<OrderItem> items;
  String time_of_arrival;

  Order(this.items, this.orderDate, this.orderId, this.status, this.totalAmount, this.time_of_arrival);

}
