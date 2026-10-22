// ignore_for_file: non_constant_identifier_names

part of 'recipe_bloc.dart';

@immutable
abstract class RecipeEvent {}

class CreateRecipeEvent extends RecipeEvent {
  final AddRecipeData addRecipeData;
  final AddInstructionData addInstructionData;
  final String mealType;

  CreateRecipeEvent({
    required this.addRecipeData,
    required this.addInstructionData,
    required this.mealType,
  });
}

class CreateRecipewithURLEvent extends RecipeEvent {
  final String url;

  CreateRecipewithURLEvent({required this.url});
}

class UpdateRecipeEvent extends RecipeEvent {
  final Map<String, dynamic> EditReq;

  UpdateRecipeEvent({required this.EditReq});
}

class GetRecipesEvent extends RecipeEvent {
  final bool forceRefresh;

  GetRecipesEvent({this.forceRefresh = false});
}

class GetRecipeByIdEvent extends RecipeEvent {
  final int id;

  GetRecipeByIdEvent({required this.id});
}

class DeleteRecipeEvent extends RecipeEvent {
  final int id;

  DeleteRecipeEvent({required this.id});
}

class ClearRecipeEvent extends RecipeEvent {}
