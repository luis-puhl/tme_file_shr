class User {
  String name = '', phone = '';
  List<Order> orders = [];

  @override
  String toString() {
    return "name: '$name', phone: '$phone', orders: ${orders.length}";
  }
}

enum OrderStatus {
  local,
  uploaded,
  printed,
  retrieved,
}

class Order {
  List<FileConfig> files = [];
  OrderStatus status = OrderStatus.local;
}

class FileConfig {
  String fileName = '', path = '', printSize = '';
  int qtd = 1;
}
