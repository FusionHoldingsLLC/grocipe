import 'package:hive/hive.dart';
import 'dart:convert';

part 'grocery_list.g.dart'; 

@HiveType(typeId: 13)
class GroceryListData {
  @HiveField(0)
  List<Grocery> items;

  GroceryListData({required this.items});

  factory GroceryListData.fromJson(Map<String, dynamic> json) {
    var itemsList = json['details'] as List<dynamic>;
    List<Grocery> groceries = itemsList.map((item) => Grocery.fromJson(item)).toList();
    return GroceryListData(items: groceries);
  }
}

@HiveType(typeId: 12)
class Grocery {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String? brandName;

  @HiveField(2)
  final String? itemName;

  @HiveField(3)
  final String? unit;

  @HiveField(4)
  final String? quantity;

  @HiveField(5)
  final String? price;

  @HiveField(6)
  final String? category;

  @HiveField(7)
  final String? subCategory;

  @HiveField(8)
  final String? store;

  @HiveField(9)
  final String? city;

  @HiveField(10)
  final String? imageData;

  Grocery({
    this.id,
    this.brandName,
    this.itemName,
    this.unit,
    this.quantity,
    this.price,
    this.category,
    this.subCategory,
    this.store,
    this.city,
    this.imageData,
  });

  factory Grocery.fromJson(Map<String, dynamic> json) {
    return Grocery(
      id: json['id'] as int?,
      brandName: json['brand_name'] as String?,
      itemName: json['item_name'] as String?,
      unit: json['unit'] as String?,
      quantity: json['quantity'] as String?,
      price: json['price'] as String?,
      category: json['category'] as String?,
      subCategory: json['sub_category'] as String?,
      store: json['store'] as String?,
      city: json['city'] as String?,
      imageData: json['image_data'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brand_name': brandName,
      'item_name': itemName,
      'unit': unit,
      'quantity': quantity,
      'price': price,
      'category': category,
      'sub_category': subCategory,
      'store': store,
      'city': city,
      'image_data': imageData,
    };
  }

  static List<Grocery> parseResponse(String jsonResponse) {
    final parsed = json.decode(jsonResponse).cast<Map<String, dynamic>>();
    return parsed.map<Grocery>((json) => Grocery.fromJson(json)).toList();
  }
}
