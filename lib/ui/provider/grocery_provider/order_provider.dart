// ignore_for_file: unused_local_variable

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocipe/models/order.dart';
import 'package:grocipe/models/states/app_state.dart';
import 'package:grocipe/services/grocery_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

class OrderProvider extends StateNotifier<AppState<Order>> {
  final Ref ref;
  Box<Order>? _groceryorderBox;

  OrderProvider(this.ref) : super(InitialAppState());

  GroceryService get service => ref.read(groceryService);

  String _sortingCriteria = 'None';

  Future<void> _ensureBoxIsReady() async {
    if (_groceryorderBox == null || !_groceryorderBox!.isOpen) {
      await _initializeBox();
    }
  }

  Future<void> _initializeBox() async {
    try {
      if (Hive.isBoxOpen('groceryOrdersCache')) {
        _groceryorderBox = Hive.box('groceryOrdersCache');
        print('Box already open');
      } else {
        _groceryorderBox = await Hive.openBox('groceryOrdersCache');
        print('Box initialized successfully');
      }
    } catch (e) {
      print('Error initializing box: $e');
    }
  }

  Future<List<Order>?> getGroceryOrder() async {
    state = LoadingAppState();
    try {
      final res = await service.getGroceryOrder();
      state = ListAppState(List.from(res));
      return res;
    } catch (error) {
      if (!hasData) state = FailureAppState(error);
      return null;
    }
  }

  bool isCompletedTab = false;
  List<OrderItem>? orderItems = [];
  Order order = Order();

  Future<Order?> getSingleGroceryOrder(String id) async {
    await _ensureBoxIsReady();
    await _loadCachedOrder("groceryOrdersCache");
    if (order.orderItems?.isEmpty ?? true) {
      await _fetchOrderInBackground(id);
    }
    return order;
  }

  /// Load cached order data
  Future<void> _loadCachedOrder(String id) async {
    print(id);
    final cachedOrder = _groceryorderBox?.get(id);
    print("This is the cached data $cachedOrder");
    if (cachedOrder != null) {
      order = cachedOrder;
      orderItems = cachedOrder.orderItems;
      state = SuccessAppState(order);
    } else {
      state = LoadingAppState();
    }
  }

  Future<void> _fetchOrderInBackground(String id) async {
    try {
      final res = await service.getSingleGroceryOrder(id);
      print(res);

      print(res.orderItems?.length);
      print(order.orderItems?.length);

      bool needsUpdate = false;

      if (res.orderItems?.length != (orderItems?.length ?? 0)) {
        needsUpdate = true;
      } else {
        for (int i = 0; i < res.orderItems!.length; i++) {
          if (res.orderItems![i].itemQuantity !=
              order.orderItems![i].itemQuantity) {
            needsUpdate = true;
            break;
          }
        }
      }

      if (needsUpdate) {
        print('Fetched new order data from the network: $res');
        try {
          await _groceryorderBox?.put(id, res);
        } catch (error) {
          print("Error inserting data into box ${error}");
        }
        order = res;
        orderItems = res.orderItems;
        state = SuccessAppState(res);
        print("Updated cached order data: ${_groceryorderBox?.get(id)}");
      } else {
        print('Cached order is up-to-date, no need to fetch from the network.');
      }
    } catch (error) {
      if (error.toString() == "User don't have any order created") {
        state = SuccessAppState(Order(orderCompleted: true));
      } else {
        print('Error fetching order from network: $error');
        if (order == null) {
          state = FailureAppState(error);
        } else {
          state = SuccessAppState(Order(orderCompleted: true));
        }
      }
    }
  }

  Future<bool> getSingleGroceryOrderBool(String id) async {
    state = LoadingAppState();
    try {
      final res = await service.getSingleGroceryOrder(id);
      if (res.orderCompleted ?? false) {
        state = SuccessAppState(res);
        orderItems = [];
        order = res;
        return true;
      } else {
        state = SuccessAppState(res);
        orderItems = res.orderItems;
        order = res;
        return false;
      }
    } catch (error) {
      if (error.toString() == "User dont have any order created") {
        return true;
      } else {
        if (!hasOrder) state = FailureAppState(error);
      }

      return false;
    }
  }

  List<OrderItem> filterOrders(List<OrderItem> orders, bool isCompleted) {
    return orders.where((order) => order.itemCompleted == isCompleted).toList();
  }

  bool hasAllOrderComplete(List<OrderItem> orders) {
    List<OrderItem> completedOrders = filterOrders(orders, true);
    List<OrderItem> incompleteOrders = filterOrders(orders, false);

    return completedOrders.isNotEmpty && incompleteOrders.isEmpty;
  }

  bool get hasData => state is ListAppState<Order>;
  bool get hasOrder => state is SuccessAppState<Order>;

  Future updateOrderItemCompletionStatus(
      OrderItem orderItem, bool isCompleted) async {
    if (orderItems != null) {
      for (var item in orderItems!) {
        if (item.id == orderItem.id) {
          item.itemCompleted = isCompleted;
          break;
        }
      }

      order = order.copyWith(orderItems: orderItems);

      try {
        state = LoadingAppState();
        var response =
            await ref.read(groceryService).updateGroceryOrder(order.toApiMap());
        getSingleGroceryOrder("");

        state = SuccessAppState(response);
      } catch (e) {
        if (!hasOrder) state = FailureAppState(e);
        return null;
      }
    }
  }

  Future markOrderAsDone() async {
    order = order.copyWith(orderCompleted: true);

    try {
      var response =
          await ref.read(groceryService).updateGroceryOrder(order.toApiMap());
    } catch (e) {
      if (!hasOrder) state = FailureAppState(e);
      return null;
    }
  }

  void sortOrders(String criteria) {
    _sortingCriteria = criteria;
    if (orderItems != null) {
      switch (criteria) {
        case 'By Aisle':
          orderItems!.sort((a, b) {
            final categoryA = a.grocery?.category ?? '';
            final categoryB = b.grocery?.category ?? '';
            return categoryA.compareTo(categoryB);
          });
          break;
      }
      order = order.copyWith(orderItems: orderItems);
      state = SuccessAppState(order);
    }
  }

  String get sortingCriteria => _sortingCriteria;
}

final orderProvider = StateNotifierProvider<OrderProvider, AppState<Order>>(
    (ref) => OrderProvider(ref));
