// ignore_for_file: avoid_print

import 'package:grocipe/models/recipe.dart';
import 'package:grocipe/models/recipe_flow/add_instruction.dart';
import 'package:grocipe/models/recipe_flow/add_recipe.dart';
import 'package:grocipe/repository/recipe_repo/recipe_data_provider.dart';
import 'package:grocipe/repository/recipe_repo/recipe_repo.dart';

class RecipeRepoImp implements RecipeRepo {
  final RecipeDataProvider _recipeDataProvider = RecipeDataProvider();

  @override
  Future<Recipe> createRecipe({
    required AddRecipeData addRecipeData,
    required AddInstructionData addInstructionData,
    required String mealType,
  }) async {
    try {
      return await _recipeDataProvider.createRecipe(
        addRecipeData: addRecipeData,
        addInstructionData: addInstructionData,
        mealType: mealType,
      );
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getUserprofile() async {
    try {
      return await _recipeDataProvider.getUserprofile();
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<Recipe>> getCachedRecipes() async {
    try {
      return await _recipeDataProvider.getCachedRecipes();
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<Recipe>> getRecipes({bool forceRefresh = false}) async {
    try {
      return await _recipeDataProvider.getRecipes(forceRefresh: forceRefresh);
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<Recipe>?> deleteRecipe({required int id}) async {
    try {
      final remainingRecipes = await _recipeDataProvider.deleteRecipe(id: id);
      return remainingRecipes;
    } catch (e) {
      print("Error in RecipeRepoImp.deleteRecipe: ${e.toString()}");
      return null;
    }
  }

  @override
  Future<Recipe> updateRecipe(Map<String, dynamic> req) async {
    try {
      print(req);
      return await _recipeDataProvider.updateRecipe(req);
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<Recipe> createRecipewithUrl({required String url}) async {
    try {
      return await _recipeDataProvider.createRecipewithUrl(url: url);
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  Future<Recipe> getRecipeById({required int id}) async {
    try {
      return await _recipeDataProvider.getRecipeById(id: id);
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
