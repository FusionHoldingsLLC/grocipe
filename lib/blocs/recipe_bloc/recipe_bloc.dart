import 'package:bloc/bloc.dart';
import 'package:grocipe/models/recipe.dart';
import 'package:grocipe/models/recipe_flow/add_instruction.dart';
import 'package:grocipe/models/recipe_flow/add_recipe.dart';
import 'package:grocipe/repository/recipe_repo/recipe_implementation.dart';
import 'package:meta/meta.dart';
part 'recipe_event.dart';
part 'recipe_state.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final RecipeRepoImp recipeRepo;

  RecipeBloc({required this.recipeRepo}) : super(RecipeInitial()) {
    on<CreateRecipeEvent>(_createRecipe);
    on<CreateRecipewithURLEvent>(_createRecipeUrl);
    on<UpdateRecipeEvent>(_updateRecipe);
    on<GetRecipesEvent>(_getRecipes);
    on<GetRecipeByIdEvent>(_getRecipeById);
    on<DeleteRecipeEvent>(_deleteRecipe);
    on<ClearRecipeEvent>(_clear);
  }

  Future<void> _clear(ClearRecipeEvent event, Emitter<RecipeState> emit) async {
    emit(const RecipesLoaded(recipes: [], message: "Recipes cleared"));
  }

  Future<void> _createRecipe(
      CreateRecipeEvent event, Emitter<RecipeState> emit) async {
    emit(RecipeProcessing(isCreating: true, recipes: state.recipes));

    try {
      final newRecipe = await recipeRepo.createRecipe(
        addRecipeData: event.addRecipeData,
        addInstructionData: event.addInstructionData,
        mealType: event.mealType,
      );

      final updatedRecipes = List<Recipe>.from(state.recipes ?? [])
        ..add(newRecipe);
      emit(RecipesLoaded(
        message: "Recipe Created Successfully",
        recipes: updatedRecipes,
      ));
    } catch (e) {
      emit(RecipeError(
        message: "Failed to create recipe: ${e.toString()}",
        recipes: state.recipes,
      ));
    }
  }

  Future<void> _createRecipeUrl(
      CreateRecipewithURLEvent event, Emitter<RecipeState> emit) async {
    emit(RecipeProcessing(isCreating: true, recipes: state.recipes));

    try {
      final newRecipe = await recipeRepo.createRecipewithUrl(url: event.url);
      final updatedRecipes = List<Recipe>.from(state.recipes ?? [])
        ..add(newRecipe);
      emit(RecipesLoaded(
        message: "Recipe Created Successfully",
        recipes: updatedRecipes,
      ));
    } catch (e) {
      emit(RecipeError(
        message: "Failed to create recipe: ${e.toString()}",
        recipes: state.recipes,
      ));
    }
  }

  Future<void> _updateRecipe(
      UpdateRecipeEvent event, Emitter<RecipeState> emit) async {
    emit(RecipeProcessing(isUpdating: true, recipes: state.recipes));

    try {
      final updatedRecipe = await recipeRepo.updateRecipe(event.EditReq);
      final updatedRecipes = state.recipes
              ?.map((recipe) =>
                  recipe.id == updatedRecipe.id ? updatedRecipe : recipe)
              .toList() ??
          [];

      emit(RecipesLoaded(
        message: "Recipe Updated Successfully",
        recipes: updatedRecipes,
      ));
    } catch (e) {
      emit(RecipeError(
        message: "Failed to update recipe: ${e.toString()}",
        recipes: state.recipes,
      ));
    }
  }

  Future<void> _getRecipes(
      GetRecipesEvent event, Emitter<RecipeState> emit) async {
    print("RecipeBloc: Handling GetRecipesEvent");

    // First, emit cached data
    final cachedRecipes = await recipeRepo.getCachedRecipes();
    if (cachedRecipes.isNotEmpty) {
      print("RecipeBloc: Emitting cached recipes");
      emit(RecipesLoaded(
          recipes: cachedRecipes,
          message: "Cached Recipes Loaded",
          isCached: true));
    } else {
      emit(RecipeProcessing(isFetching: true, recipes: state.recipes));
    }

    // Then, fetch from API
    try {
      print("RecipeBloc: Fetching recipes from API");
      final recipes =
          await recipeRepo.getRecipes(forceRefresh: event.forceRefresh);
      print("RecipeBloc: Received ${recipes.length} recipes from API");

      if (recipes.isEmpty) {
        print("RecipeBloc: Emitting RecipeEmpty");
        emit(RecipeEmpty());
      } else {
        print("RecipeBloc: Emitting updated RecipesLoaded");
        emit(RecipesLoaded(
            recipes: recipes, message: "Recipes Updated", isCached: false));
      }
    } catch (e) {
      print("RecipeBloc: Error - ${e.toString()}");
      // Only emit error if we didn't emit cached data earlier
      if (cachedRecipes.isEmpty) {
        emit(RecipeError(
          message: "Failed to fetch recipes: ${e.toString()}",
          recipes: state.recipes,
        ));
      }
    }
  }

  Future<void> _getRecipeById(
      GetRecipeByIdEvent event, Emitter<RecipeState> emit) async {
    emit(RecipeProcessing(isFetching: true, recipes: state.recipes));

    try {
      final recipe = await recipeRepo.getRecipeById(id: event.id);
      emit(RecipeLoaded(
          recipe: recipe, message: "Recipe Loaded", recipes: state.recipes));
    } catch (e) {
      emit(RecipeError(
        message: "Failed to fetch recipe: ${e.toString()}",
        recipes: state.recipes,
      ));
    }
  }

  Future<void> _deleteRecipe(
      DeleteRecipeEvent event, Emitter<RecipeState> emit) async {
    emit(RecipeProcessing(isDeleting: true, recipes: state.recipes));

    try {
      final remainingRecipes = await recipeRepo.deleteRecipe(id: event.id);
      if (remainingRecipes != null) {
        if (remainingRecipes.isEmpty) {
          emit(RecipeEmpty());
        } else {
          emit(RecipesLoaded(
            message: "Recipe Deleted Successfully",
            recipes: remainingRecipes,
          ));
        }
      } else {
        emit(RecipeError(
          message: "Failed to delete recipe",
          recipes: state.recipes,
        ));
      }
    } catch (e) {
      emit(RecipeError(
        message: "Failed to delete recipe: ${e.toString()}",
        recipes: state.recipes,
      ));
    }
  }
}
