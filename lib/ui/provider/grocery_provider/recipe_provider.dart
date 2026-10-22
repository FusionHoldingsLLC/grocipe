import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocipe/models/grocery_list.dart';
import 'package:grocipe/models/recipe.dart';
import 'package:grocipe/models/states/app_state.dart';
import 'package:grocipe/services/recipe_service.dart';

class RecipeProvider extends StateNotifier<AppState<Recipe>> {
  final Ref ref;
  RecipeProvider(this.ref) : super(InitialAppState());

  RecipeService get service => ref.read(recipeService);

  Future getRecipes() async {
    state = LoadingAppState();
    try {
      final res = await service.getRecipes();
      state = ListAppState(List.from(res));
      return res;
    } catch (error) {
      if (!hasData) state = FailureAppState(error);
    }
  }

  Future addRecipeUrl(String url) async {
    state = LoadingAppState();
    try {
      final res = await service.addtRecipeUrl(url);
      await getRecipes();
      return res;
    } catch (error) {
      state = FailureAppState(error);
    }
  }

  bool get hasData => state is ListAppState<Grocery>;
}

final recipeProvider = StateNotifierProvider<RecipeProvider, AppState<Recipe>>(
    (ref) => RecipeProvider(ref));
