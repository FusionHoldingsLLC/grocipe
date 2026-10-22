import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocipe/api/api_urls.dart';
import 'package:grocipe/api/network.dart';
import 'package:grocipe/models/recipe.dart';

class RecipeService {
  final Ref ref;

  RecipeService(this.ref);

  Network get network => ref.read(networkProvider);

  Future<List<Recipe>> getRecipes() async {
    final res = await network.call(
      UrlConfig.getRecipes,
      RequestMethod.get,
      showLog: true,
    );

    List<dynamic> jsonList = jsonDecode(jsonEncode(res.data));
    List<Recipe> recipes =
        jsonList.map((json) => Recipe.fromJson(json)).toList();
    return recipes;
  }

  Future<Recipe> addtRecipeUrl(String url) async {
    Map<String, dynamic>? queryParams = {"url": url};

    final res = await network.call(
      UrlConfig.addRecipeUrl(url),
      queryParams: queryParams,
      RequestMethod.post,
      showLog: true,
    );

    Recipe recipe = Recipe.fromJson(res.data);
    return recipe;
  }
}

final recipeService = Provider<RecipeService>((ref) => RecipeService(ref));
