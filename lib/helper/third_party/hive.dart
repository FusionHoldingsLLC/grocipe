import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocipe/models/grocery_list.dart';
import 'package:grocipe/models/health.dart';
import 'package:grocipe/models/ingredient.dart';
import 'package:grocipe/models/instruction.dart';
import 'package:grocipe/models/meal_plan_menu.dart';
import 'package:grocipe/models/meal_type.dart';
import 'package:grocipe/models/nutrition.dart';
import 'package:grocipe/models/order.dart';
import 'package:grocipe/models/recipe.dart';
import 'package:grocipe/models/recipe_image.dart';
import 'package:grocipe/models/user.dart';
import 'package:grocipe/models/weekly_mealplan.dart';
import 'package:grocipe/local_storage/meal_plan_menu_adapter.dart';
import 'package:grocipe/local_storage/weeks_mealplan_adapter.dart';
import 'package:hive_flutter/adapters.dart';

class HiveFunction {
  static HiveFunction get _instance => HiveFunction._();
  factory HiveFunction() => _instance;
  static HiveFunction get instance => _instance;
  HiveFunction._();

  static const sessionStorage = "grocipe";
  static const _user = "user";
  static const _recipes = "recipes";
  static const _lastFetchTime = "last_fetch_time";
  static late Box _sessionBox;

  static Future init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(RecipeImageAdapter());
    Hive.registerAdapter(RecipeAdapter());
    Hive.registerAdapter(Instruction2Adapter());
    Hive.registerAdapter(IngredientAdapter());
    Hive.registerAdapter(HealthReportAdapter());
    Hive.registerAdapter(MealTypeAdapter());
    Hive.registerAdapter(NutritionalFactAdapter());
    Hive.registerAdapter(DayMealsDataAdapter());
    Hive.registerAdapter(MealAdapter());

    Hive.registerAdapter(GroceryListDataAdapter());
    Hive.registerAdapter(GroceryAdapter());

    Hive.registerAdapter(WeeklyMealPlanAdapter());
    Hive.registerAdapter(DayMealsAdapter());
    Hive.registerAdapter(ReqMealAdapter());
    Hive.registerAdapter(MealPlanMenuAdapter());

    Hive.registerAdapter(MealplanRecipeAdapter());
    Hive.registerAdapter(MealPlanIngredientAdapter());
    Hive.registerAdapter(MealPlanNutritionalFactsAdapter());
    Hive.registerAdapter(MealPlanIngredientsAdapter());
    Hive.registerAdapter(OrderAdapter());
    Hive.registerAdapter(OrderItemAdapter());

    _sessionBox = await Hive.openBox(sessionStorage);

    await MealPlanHiveService.init(_sessionBox);
    await MealPlanMenuHiveService.init(_sessionBox);
  }

  static Future<void> _ensureInitialized() async {
    if (!_sessionBox.isOpen) {
      await init();
    }
  }

  //Appstate functions
  Future<void> saveDataToDisk(String key, dynamic value) async {
    await _sessionBox.put(key, value);
  }

  dynamic getDataFromDisk(String key) {
    return _sessionBox.get(key);
  }

  // User-related methods
  static insertUser(User token) async {
    await _sessionBox.put(_user, token);
  }

  Future saveUserData(User? user) async {
    if (user == null) return;
    await _sessionBox.put(_user, user);
  }

  User? get user => _sessionBox.get(_user) as User?;
  Future clearSession() async => await _sessionBox.clear();

  static User getUser() {
    return _sessionBox.get(_user);
  }

  static void deleteUser() {
    _sessionBox.delete(_user);
  }

  static bool userExist() {
    return _sessionBox.get(_user) != null;
  }

  // Recipe-related methods
  static Future<void> insertRecipes(List<Recipe> recipes) async {
    await _ensureInitialized();
    final recipeBox = await Hive.openBox<Recipe>(_recipes);
    final batch = recipeBox.putAll(Map.fromEntries(recipes.map((recipe) =>
        MapEntry(recipe.id.toString(),
            recipe.copyWith(cacheTimestamp: DateTime.now())))));
    await batch;
    await _sessionBox.put(_lastFetchTime, DateTime.now());
  }

  static Future<List<Recipe>> getRecipes() async {
    await _ensureInitialized();
    final recipeBox = await Hive.openBox<Recipe>(_recipes);
    return recipeBox.values.toList();
  }

  static Future<void> updateRecipe(Recipe updatedRecipe) async {
    await _ensureInitialized();
    final recipeBox = await Hive.openBox<Recipe>(_recipes);
    await recipeBox.put(updatedRecipe.id.toString(),
        updatedRecipe.copyWith(cacheTimestamp: DateTime.now()));
  }

  static Future<void> deleteRecipe(int id) async {
    await _ensureInitialized();
    final recipeBox = await Hive.openBox<Recipe>(_recipes);
    await recipeBox.delete(id.toString());
  }

  static Future<void> addRecipe(Recipe newRecipe) async {
    await _ensureInitialized();
    final recipeBox = await Hive.openBox<Recipe>(_recipes);
    await recipeBox.put(newRecipe.id.toString(),
        newRecipe.copyWith(cacheTimestamp: DateTime.now()));
  }

  static Future<void> clearRecipes() async {
    await _ensureInitialized();
    final recipeBox = await Hive.openBox<Recipe>(_recipes);
    await recipeBox.clear();
    await _sessionBox.delete(_lastFetchTime);
  }

  // Language-related methods
  static void insertLanguage(String lang) {
    _ensureInitialized();
    _sessionBox.put("language", lang);
  }

  static String getLanguage() {
    _ensureInitialized();
    return _sessionBox.get("language", defaultValue: "en");
  }

  // Miscellaneous methods
  static void deleteApp() {
    _sessionBox.delete(sessionStorage);
  }

  static void deleteAllExceptUser() async {
    deleteUser();
    clearRecipes();
    deleteApp();
  }

  static void deleteAll() async {
    await _sessionBox.clear();
  }
}

final localStorageService = Provider<HiveFunction>((ref) => HiveFunction());
