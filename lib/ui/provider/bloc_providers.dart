import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocipe/blocs/recipe_bloc/recipe_bloc.dart';
import 'package:grocipe/blocs/user_bloc/user_bloc.dart';
import 'package:grocipe/repository/recipe_repo/recipe_implementation.dart';
import 'package:grocipe/repository/user_repo/user_implementation.dart';
import 'package:provider/single_child_widget.dart';

class BlocProviders {
  static List<SingleChildWidget> providers = [
    BlocProvider(
      create: (context) =>
          RecipeBloc(recipeRepo: context.read<RecipeRepoImp>()),
    ),
    BlocProvider(
      create: (context) => UserBloc(userRepo: context.read<userRepoImp>()),
    ),
  ];
}
