import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocipe/blocs/recipe_bloc/recipe_bloc.dart';
import 'package:grocipe/models/recipe.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends BaseViewModel {
  TextEditingController searchController = TextEditingController();
  int currentIndex = 0;
  List<String> mealType = [];
  List<Recipe> filteredRecipes = [];
  List<Recipe> allRecipes = [];

  HomeViewModel() {
    searchController.addListener(onSearchChanged);
  }

  void initState(BuildContext context) {
    searchController.addListener(onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadRecipes(context);
    });
  }

  @override
  void dispose() {
    searchController.removeListener(onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  void loadRecipes(BuildContext context) {
    final recipeState = context.read<RecipeBloc>().state;
    if (recipeState is RecipeInitial) {
      context.read<RecipeBloc>().add(GetRecipesEvent());
    } else {
      filterRecipes();
    }
    notifyListeners();
  }

  void onSearchChanged() {
    filterRecipes();
    notifyListeners();
  }

  void filterRecipes() {
    filteredRecipes = allRecipes.where((recipe) {
      final nameMatches = recipe.name
          .toLowerCase()
          .contains(searchController.text.toLowerCase());
      final mealTypeMatches = currentIndex == 0 ||
          (recipe.mealTypes.isNotEmpty &&
              recipe.mealTypes[0].name.toLowerCase() ==
                  mealType[currentIndex].toLowerCase());
      return nameMatches && mealTypeMatches;
    }).toList();

    filteredRecipes.sort((a, b) => b.dateUpdated.compareTo(a.dateUpdated));
  }

  Future<void> refreshRecipes(BuildContext context) async {
    context.read<RecipeBloc>().add(GetRecipesEvent(forceRefresh: true));
    loadRecipes(context);
  }
}
