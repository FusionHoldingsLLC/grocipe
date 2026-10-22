import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocipe/models/grocery_list.dart';
import 'package:grocipe/api/network.dart';
import 'package:grocipe/api/api_urls.dart';
import 'package:grocipe/models/order.dart';

class GroceryService {
  final Ref ref;

  GroceryService(this.ref);

  Network get network => ref.read(networkProvider);

  Future<List<Grocery>> searchGrocery(Map<String, dynamic> data) async {
    final res = await network.call(
      UrlConfig.searchGrocery,
      RequestMethod.get,
      queryParams: data,
      showLog: true,
    );
    List<Grocery> response = Grocery.parseResponse(jsonEncode(res.data));

    return response;
  }

  Future<Order> getSingleGroceryOrder(String groceryIds) async {
    final res = await network.call(
      UrlConfig.getSingleGroceryOrder,
      RequestMethod.get,
      showLog: true,
    );

    return Order.fromJson(res.data);
  }

  Future<void> createGroceryOrder(Map<String, dynamic> data) async {
    final res = await network.call(
      UrlConfig.createGroceryOrder,
      RequestMethod.post,
      data: data,
      showLog: true,
    );
    return (res.data);
  }

  Future<Order> updateGroceryOrder(Map<String, dynamic> data) async {
    final res = await network.call(
      UrlConfig.updateGroceryOrder,
      RequestMethod.patch,
      data: data,
      showLog: true,
    );

    return Order.fromJson(res.data);
  }

  Future<List<Order>> getGroceryOrder() async {
    final res = await network.call(
      UrlConfig.getGroceryOrder,
      RequestMethod.get,
      showLog: true,
    );

    List<dynamic> jsonList = jsonDecode(jsonEncode(res.data));
    List<Order> orders = jsonList.map((json) => Order.fromJson(json)).toList();
    return orders;
  }

  Future<void> deleteGroceryOrder(String orderNumber) async {
    Map<String, dynamic> data = {"order_number": orderNumber};
    final res = await network.call(
      UrlConfig.deleteGroceryOrder,
      RequestMethod.delete,
      showLog: true,
      queryParams: data,
    );
    return jsonDecode(res.data);
  }
}

final groceryService = Provider<GroceryService>((ref) => GroceryService(ref));
