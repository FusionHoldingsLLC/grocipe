// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grocipe/models/recipe_flow/add_instruction.dart';
import 'package:grocipe/models/recipe_flow/add_recipe.dart';
import 'package:grocipe/models/recipe_flow/ingredient.dart';
import 'package:grocipe/models/recipe_flow/instruction.dart';
import 'package:grocipe/models/recipe_flow/nutrition.dart';

class RecipeProvider extends ChangeNotifier {
  List<Ingredient> ingredients = [];
  List<Instruction> instructions = [];
  List<Nutrition> nutritions = [];
  AddRecipeData? addRecipeData;
  AddInstructionData? addInstructionData;

  String? imageUrl;
  addImage(String url) {
    imageUrl = url;
    notifyListeners();
  }

  deleteImage() {
    imageUrl = null;
    notifyListeners();
  }

  inputRecipeData(AddRecipeData data) {
    addRecipeData = data;
    notifyListeners();
  }

  inputinstructionData(AddInstructionData data) {
    addInstructionData = data;
    notifyListeners();
  }

  addIngredient(Ingredient ingredient) {
    ingredients.add(ingredient);
    notifyListeners();
  }

  editIngredient(Ingredient ingredient, int index) {
    ingredients[index] = ingredient;

    notifyListeners();
  }

  deleteIngredient(int index) {
    ingredients.removeAt(index); // [index] = ingredient;
    // ingredients.add(ingredient);
    notifyListeners();
  }

  deleteInstruction(int index) {
    instructions.removeAt(index); // [index] = ingredient;
    // ingredients.add(ingredient);
    notifyListeners();
  }

  addNutrition(Nutrition nutrition) {
    nutritions.add(nutrition);
    notifyListeners();
  }

  editNutrition(Nutrition nutrition, int index) {
    nutritions[index] = nutrition;

    notifyListeners();
  }

  deleteNutrition(int index) {
    nutritions.removeAt(index); // [index] = ingredient;
    // ingredients.add(ingredient);
    notifyListeners();
  }

  addInstruction(Instruction instruction) {
    instructions.add(instruction);
    notifyListeners();
  }

  editInstruction(Instruction instruction, int index) {
    instructions[index] = instruction;
    notifyListeners();
  }

  clear() {
    ingredients = [];
    instructions = [];
    nutritions = [];
    addRecipeData = null;
    addInstructionData = null;
    imageUrl = null;
    notifyListeners();
  }

  getData() {
    return {
      'addRecipeData': addRecipeData,
      'addInstructionData': addRecipeData,
    };
  }
}
