import 'dart:math';
import 'package:scoped_model/scoped_model.dart';

class User extends Model {
  String name = '', phone = '';
  List<Order> orders = [
    Order([
      FileConfig(),
    ]),
  ];

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

String orderStatusFmt(OrderStatus os) {
  switch (os) {
    case OrderStatus.local:
      return 'Não enviado';
    case OrderStatus.uploaded:
      return 'Enviado';
    case OrderStatus.printed:
      return 'Impresso';
    case OrderStatus.retrieved:
      return 'Finalizado';
    default:
      return os.toString();
  }
}

int getId() {
  Random r = Random.secure();
  return r.nextInt(1<<32);
}

class Order extends Model {
  List<FileConfig> files = [];
  OrderStatus status = OrderStatus.local;
  DateTime time = DateTime.now();
  int id = getId();

  Order(this.files);
  
  int get totalQtd => files.map((file) => file.qtd).reduce((qtd, acc) => qtd + acc);
  
  @override
  String toString() {
    return '$totalQtd cópia${totalQtd > 1 ? 's' : ''} em ${timeFmt(time)}';
  }

  String toLongSting() {
    return '$totalQtd cópia${totalQtd > 1 ? 's' : ''}\n'
      '${orderStatusFmt(status)}\n'
      '${timeFmt(time)}'
    ;
  }
}

class FileConfig extends Model {
  String fileName = '', path = '', printSize = '';
  int qtd = 1;
}

String timeFmt(DateTime time) {
  final now = DateTime.now();
  String year = (time.year != now.year) ? ('/' + time.year.toString()) : '';
  Function addZero = (int n) => (n < 9 ? '0' : '') + n.toString();

  return '${addZero(time.hour)}:${addZero(time.minute)} ${addZero(time.day)}/${addZero(time.month)}$year';
}
