// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';
import 'package:grocipe/helper/settings/constants.dart';
import 'package:grocipe/helper/third_party/cloudinary.dart';
import 'package:grocipe/helper/third_party/hive.dart';
import 'package:grocipe/models/recipe.dart';
import 'package:grocipe/models/recipe_flow/add_instruction.dart';
import 'package:grocipe/models/recipe_flow/add_recipe.dart';
import 'package:grocipe/models/user.dart';
import 'package:grocipe/repository/recipe_repo/recipe_repo.dart';
import 'package:http/http.dart' as http;

class RecipeDataProvider implements RecipeRepo {
  static final String _baseUrl = Constants.url;
  static const String _authHeader = "Authorization";
  static const String _contentType = "Content-Type";
  static const String _accept = "Accept";
  static const String _token = "token";

  static const Duration _cacheDuration = Duration(days: 1);

  static Map<String, String> _getHeaders() {
    final user = HiveFunction.getUser();
    return {
      _authHeader: "Bearer ${user.accessToken}",
      _accept: "application/json",
      _token: user.accessToken,
      _contentType: 'application/json'
    };
  }

  Future<dynamic> _makeRequest(
    String endpoint,
    String method, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint');
      final headers = _getHeaders();
      late http.Response res;

      switch (method) {
        case 'GET':
          res = await http.get(uri, headers: headers);
          break;
        case 'POST':
          res = await http.post(uri, headers: headers, body: json.encode(body));
          break;
        case 'PATCH':
          res =
              await http.patch(uri, headers: headers, body: json.encode(body));
          break;
        case 'DELETE':
          res = await http.delete(uri, headers: headers);
          break;
        default:
          throw Exception('Unsupported HTTP method');
      }

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return json.decode(res.body);
      } else {
        throw Exception('Request failed with status: ${res.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Recipe>> getCachedRecipes() async {
    return await HiveFunction.getRecipes();
  }

  @override
  Future<List<Recipe>> getRecipes({bool forceRefresh = false}) async {
    try {
      final cachedRecipes = await HiveFunction.getRecipes();
      final shouldFetch = forceRefresh || _shouldRefreshCache(cachedRecipes);

      if (shouldFetch) {
        final uri = Uri.parse('$_baseUrl/recipes/recipes');
        final headers = _getHeaders();
        final res = await http.get(uri, headers: headers);

        if (res.statusCode == 404) {
          // Clear Hive storage since recipes might have been deleted from another device
          await HiveFunction.clearRecipes();
          return [];
        }

        if (res.statusCode >= 200 && res.statusCode < 300) {
          final apiResponse = json.decode(res.body);
          if (apiResponse is List) {
            final recipes =
                apiResponse.map((json) => Recipe.fromJson(json)).toList();

            // Update each recipe individually
            for (var recipe in recipes) {
              await HiveFunction.updateRecipe(
                  recipe.copyWith(cacheTimestamp: DateTime.now()));
            }

            return recipes;
          } else {
            throw Exception('Unexpected response format');
          }
        } else {
          throw Exception('Request failed with status: ${res.statusCode}');
        }
      } else {
        return cachedRecipes;
      }
    } catch (e) {
      return await HiveFunction.getRecipes();
    }
  }

  bool _shouldRefreshCache(List<Recipe> cachedRecipes) {
    if (cachedRecipes.isEmpty) return true;
    final oldestCacheTimestamp = cachedRecipes
        .map((recipe) =>
            recipe.cacheTimestamp ?? DateTime.fromMillisecondsSinceEpoch(0))
        .reduce((a, b) => a.isBefore(b) ? a : b);
    return DateTime.now().difference(oldestCacheTimestamp) > _cacheDuration;
  }

  @override
  Future<Recipe> createRecipe({
    required AddRecipeData addRecipeData,
    required AddInstructionData addInstructionData,
    required String mealType,
  }) async {
    var images = '';

    if (addRecipeData.image != null) {
      String? imageUrl = await CloudinaryDev.uploadPicture(
        path: addRecipeData.image,
        folder: "your_folder",
        fileName: "your_file_name",
      );
      if (imageUrl != null) {
        // images.add({"url": imageUrl});
        images = imageUrl;
      }
    }

    final Map<String, dynamic> data = {
      ...addRecipeData.toMap(),
      ...addInstructionData.toMap(),
      "diet": "",

      "prep_time": addInstructionData.prepTime.inMinutes,
      "cook_time": addInstructionData.cookTime.inMinutes,
      "total_time": addInstructionData.cookTime.inMinutes +
          addInstructionData.prepTime.inMinutes,
      "meal_types": [
        {"name": mealType}
      ],
      "health_reports": [
        {"note": "No set"}
      ],
      "recipe_images": [
        {"image_data": images}
      ]
      // "nutritional_facts": addInstructionData.nutritions.to
    };
    final response = await _makeRequest('/recipes/create', 'POST', body: data)
        as Map<String, dynamic>;
    final newRecipe = Recipe.fromJson(response);
    await HiveFunction.addRecipe(
        newRecipe.copyWith(cacheTimestamp: DateTime.now()));
    return newRecipe;
  }

  @override
  Future<Recipe> createRecipewithUrl({required String url}) async {
    final response = await _makeRequest('/recipes/generate/$url', 'POST')
        as Map<String, dynamic>;
    final newRecipe = Recipe.fromJson(response);
    await HiveFunction.addRecipe(
        newRecipe.copyWith(cacheTimestamp: DateTime.now()));
    return newRecipe;
  }

  @override
  Future<Recipe> updateRecipe(Map<String, dynamic> req) async {
    final response = await _makeRequest('/recipes/update', 'PATCH', body: req)
        as Map<String, dynamic>;
    final updatedRecipe = Recipe.fromJson(response);
    await HiveFunction.updateRecipe(
        updatedRecipe.copyWith(cacheTimestamp: DateTime.now()));
    return updatedRecipe;
  }

  @override
  Future<List<Recipe>?> deleteRecipe({required int id}) async {
    try {
      final response =
          await _makeRequest('/recipes/delete?recipe_id=$id', 'DELETE')
              as Map<String, dynamic>;

      if (response['status'] == 200) {
        await HiveFunction.deleteRecipe(id);

        // Check if the recipe still exists in local storage after deletion
        final remainingRecipes = await HiveFunction.getRecipes();
        if (remainingRecipes.any((recipe) => recipe.id == id)) {
          return null;
        } else {
          return remainingRecipes;
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<Recipe> getRecipeById({required int id}) async {
    final response = await _makeRequest('/recipes/recipe?recipe_id=$id', 'GET')
        as Map<String, dynamic>;
    return Recipe.fromJson(response);
  }

  @override
  Future<Map<String, dynamic>> getUserprofile() async {
    return await _makeRequest('/api/v1/auth/me/', 'GET')
        as Map<String, dynamic>;
  }

  Future<String> checkAndRefreshToken({
    required http.Response response,
    required Future<Map<String, dynamic>> Function() funt,
  }) async {
    if (response.statusCode == 401) {
      final res = await http.post(
        Uri.parse('$_baseUrl/auth/refresh/'),
        headers: {
          _accept: "application/json",
          _contentType: 'application/json'
        },
        body:
            json.encode({'refresh_token': HiveFunction.getUser().refreshToken}),
      );
      if (res.statusCode >= 200 && res.statusCode < 300) {
        var body = json.decode(res.body);
        User user = HiveFunction.getUser().copyWith(
          accessToken: body['access_token'],
          refreshToken: body['refresh_token'],
        );
        await HiveFunction.insertUser(user);
        return json.encode(await funt());
      }
    }
    return response.body;
  }
}
