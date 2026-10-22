import 'package:grocipe/models/recipe.dart';
import 'package:grocipe/models/recipe_flow/add_instruction.dart';
import 'package:grocipe/models/recipe_flow/add_recipe.dart';

abstract class RecipeRepo {
  Future<Recipe> createRecipe({
    required AddRecipeData addRecipeData,
    required AddInstructionData addInstructionData,
    required String mealType,
  });

  Future<Recipe> createRecipewithUrl({required String url});

  Future<Map<String, dynamic>> getUserprofile();

  Future<Recipe> updateRecipe(Map<String, dynamic> req);

  Future<List<Recipe>> getRecipes();

  Future<List<Recipe>?> deleteRecipe({required int id});

  Future<List<Recipe>> getCachedRecipes();
}
