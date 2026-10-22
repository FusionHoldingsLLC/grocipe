class SingleOrderItem {
  int? id;
  String? brandName;
  String? itemName;
  String? unit;
  String? quantity;
  double? price;
  String? category;
  String? subCategory;
  String? store;
  String? city;
  String? imageData;

  SingleOrderItem({
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

  factory SingleOrderItem.fromJson(Map<String, dynamic> json) {
    return SingleOrderItem(
      id: json['id'],
      brandName: json['brand_name'],
      itemName: json['item_name'],
      unit: json['unit'],
      quantity: json['quantity'],
      price: (json['price'] != null) ? json['price'].toString().replaceAll('\$', '').toDouble() : null,
      category: json['category'],
      subCategory: json['sub_category'],
      store: json['store'],
      city: json['city'],
      imageData: json['image_data'],
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
}

extension StringParsing on String {
  double? toDouble() {
    return double.tryParse(this);
  }
}
