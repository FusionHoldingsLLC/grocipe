import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocipe/models/grocery_list.dart';
import 'package:grocipe/models/states/app_state.dart';
import 'package:grocipe/services/grocery_service.dart';

class GroceryProvider extends StateNotifier<AppState<Grocery>> {
  final Ref ref;
  GroceryProvider(this.ref) : super(InitialAppState());

  GroceryService get service => ref.read(groceryService);

  Future searchGrocery(String name, String store) async {
    Map<String, dynamic> data = {"item_name": name, "stores": store};
    state = LoadingAppState();
    try {
      final res = await service.searchGrocery(data);
      state = ListAppState(List.from(res));
      return res;
    } catch (error) {
      if (!hasData) state = FailureAppState(error);
    }
  }

  bool get hasData => state is ListAppState<Grocery>;
}

final groceryProvider =
    StateNotifierProvider<GroceryProvider, AppState<Grocery>>(
        (ref) => GroceryProvider(ref));
