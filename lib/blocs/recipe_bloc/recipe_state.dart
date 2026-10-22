part of 'recipe_bloc.dart';

@immutable
abstract class RecipeState {
  final List<Recipe>? recipes;
  final String? message;

  const RecipeState({this.recipes, this.message});
}

class RecipeInitial extends RecipeState {}

class RecipeProcessing extends RecipeState {
  final bool isCreating;
  final bool isUpdating;
  final bool isFetching;
  final bool isDeleting;

  const RecipeProcessing({
    this.isCreating = false,
    this.isUpdating = false,
    this.isFetching = false,
    this.isDeleting = false,
    List<Recipe>? recipes,
  }) : super(recipes: recipes);
}

class RecipesLoaded extends RecipeState {
  final bool isCached;

  const RecipesLoaded({
    required List<Recipe> recipes,
    String? message,
    this.isCached = false,
  }) : super(recipes: recipes, message: message);
}

class RecipeLoaded extends RecipeState {
  final Recipe recipe;
  final String message;

  const RecipeLoaded(
      {required this.recipe, required this.message, List<Recipe>? recipes})
      : super(recipes: recipes);
}

class RecipeError extends RecipeState {
  final String message;

  const RecipeError({required this.message, List<Recipe>? recipes})
      : super(recipes: recipes);
}

class RecipeEmpty extends RecipeState {
  String? get message => null;
}
