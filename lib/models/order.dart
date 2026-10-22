import 'package:grocipe/models/grocery_list.dart';
import 'package:hive/hive.dart';

part 'order.g.dart'; // This file will be generated

@HiveType(typeId: 30) // Unique type ID for Order
class Order {
  @HiveField(0)
  int? id;

  @HiveField(1)
  DateTime? orderDate;

  @HiveField(2)
  bool? orderCompleted;

  @HiveField(3)
  String? orderTotal;

  @HiveField(4)
  List<OrderItem>? orderItems;

  Order({
    this.id,
    this.orderDate,
    this.orderCompleted,
    this.orderTotal,
    this.orderItems,
  });

  Order copyWith({
    int? id,
    DateTime? orderDate,
    bool? orderCompleted,
    String? orderTotal,
    List<OrderItem>? orderItems,
  }) {
    return Order(
      id: id ?? this.id,
      orderDate: orderDate ?? this.orderDate,
      orderCompleted: orderCompleted ?? this.orderCompleted,
      orderTotal: orderTotal ?? this.orderTotal,
      orderItems: orderItems ?? this.orderItems,
    );
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      orderDate: json['order_date'] != null
          ? DateTime.parse(json['order_date'])
          : null,
      orderCompleted: json['order_completed'],
      orderTotal: json['order_total'],
      orderItems: json['order_items'] != null
          ? (json['order_items'] as List)
              .map((item) => OrderItem.fromJson(item))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_date': orderDate?.toIso8601String(),
      'order_completed': orderCompleted,
      'order_total': orderTotal,
      'order_items': orderItems?.map((item) => item.toJson()).toList(),
    };
  }

  Map<String, dynamic> toApiMap() {
    return {
      'id': id,
      'order_date': orderDate?.toIso8601String(),
      'order_completed': orderCompleted,
      'order_total': orderTotal,
      'order_items': orderItems?.map((item) => item.toApiMap()).toList(),
    };
  }
}

@HiveType(typeId: 31) // Unique type ID for OrderItem
class OrderItem {
  @HiveField(0)
  int? id;

  @HiveField(1)
  int? itemId;

  @HiveField(2)
  int? itemQuantity;

  @HiveField(3)
  String? itemPrice;

  @HiveField(4)
  bool? itemCompleted;

  @HiveField(5)
  Grocery? grocery; // Ensure Grocery class is also adapted

  OrderItem({
    this.id,
    this.itemId,
    this.itemQuantity,
    this.itemPrice,
    this.itemCompleted,
    this.grocery,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      itemId: json['item_id'],
      itemQuantity: json['item_quantity'],
      itemPrice: json['item_price'],
      itemCompleted: json['item_completed'],
      grocery:
          json['grocery'] != null ? Grocery.fromJson(json['grocery']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'item_id': itemId,
      'item_quantity': itemQuantity,
      'item_price': itemPrice,
      'item_completed': itemCompleted,
      'grocery': grocery?.toJson(),
    };
  }

  Map<String, dynamic> toApiMap() {
    return {
      'id': id,
      'item_id': itemId,
      'item_quantity': itemQuantity,
      'item_price': itemPrice,
      'item_completed': itemCompleted,
      'grocery_id': grocery?.id,
    };
  }
}
