import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:grocipe/app/app_widgets/app_input_field.dart';
import 'package:grocipe/app/app_widgets/image_render_widget.dart';
import 'package:grocipe/app/app_widgets/svg_render_widget.dart';
import 'package:grocipe/blocs/recipe_bloc/recipe_bloc.dart';
import 'package:grocipe/blocs/user_bloc/user_bloc.dart';
import 'package:grocipe/helper/constants/svg_path.dart';
import 'package:grocipe/helper/language_config/lang_extension.dart';
import 'package:grocipe/helper/settings/dev_functions.dart';
import 'package:grocipe/helper/settings/palette.dart';
import 'package:grocipe/helper/size_config/size_config.dart';
import 'package:grocipe/helper/utils/context_extension.dart';
import 'package:grocipe/models/recipe.dart';
import 'package:grocipe/navigation/route_names.dart';
import 'package:grocipe/ui/screens/home_screen/local_widget/add_recipe_popup.dart';
import 'package:grocipe/ui/screens/home_screen/local_widget/modify_recipe_popup.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  TextEditingController searchController = TextEditingController();
  int currentIndex = 0;
  List<String> mealType = [];
  List<Recipe> filteredRecipes = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRecipes();
    });
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  void _loadRecipes() {
    final recipeState = context.read<RecipeBloc>().state;
    if (recipeState is RecipeInitial) {
      context.read<RecipeBloc>().add(GetRecipesEvent());
    } else {
      filterRecipes();
    }
  }

  void _onSearchChanged() {
    filterRecipes();
  }

  void filterRecipes() {
    final recipes = context.read<RecipeBloc>().state.recipes ?? [];
    setState(() {
      filteredRecipes = recipes.where((recipe) {
        final nameMatches = recipe.name
            .toLowerCase()
            .contains(searchController.text.toLowerCase());
        final mealTypeMatches = currentIndex == 0 ||
            (recipe.mealTypes.isNotEmpty &&
                recipe.mealTypes[0].name.toLowerCase() ==
                    mealType[currentIndex].toLowerCase());
        return nameMatches && mealTypeMatches;
      }).toList();

      filteredRecipes.sort((a, b) => b.dateUpdated.compareTo(a.dateUpdated));
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final l10n = context.l10n;
    mealType = [
      l10n.all,
      "Brunch",
      l10n.breakfast,
      l10n.lunch,
      l10n.dinner,
      "Drink",
      "Snack",
      l10n.others
    ];
    filterRecipes();
  }

  Future<void> _refreshRecipes() async {
    context.read<RecipeBloc>().add(GetRecipesEvent(forceRefresh: true));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = context.l10n;

    return BlocBuilder<UserBloc, UserState>(
      builder: (context, userstate) {
        return BlocConsumer<RecipeBloc, RecipeState>(
          listener: (context, state) {
            if (state is RecipesLoaded) {
              filterRecipes();
            }
          },
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                leadingWidth: 400,
                leading: Row(
                  children: [
                    const Gap(20),
                    GestureDetector(
                      onTap: () {
                        context.goNamed(Routes.profile);
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: ImageRenderWidget.network(
                            imageUrl: userstate.user?.profilePictureUrl ??
                                DevFunction.getAnoymousProfile(),
                            placeholder: Row(
                              children: [
                                SvgRenderWidget(
                                  svgPath: "assets/svgs/user_icon.svg",
                                  color: context.colors.black,
                                  height: 35,
                                  width: 35,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Gap(10),
                    Text(
                      "${l10n.hello} ${userstate.user!.lastName} 👋",
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(
                              color: context.colors.black,
                              fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                actions: [
                  GestureDetector(
                    onTap: () {
                      showFlexibleBottomSheet(
                        bottomSheetColor: Colors.transparent,
                        initHeight: 0.25,
                        context: context,
                        builder:
                            (context, scrollController, bottomSheetOffset) {
                          return const AddRecipePopup();
                        },
                        anchors: [0, 0.5, 1],
                        isSafeArea: true,
                      );
                    },
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ImageRenderWidget.asset(
                            imagePath: "assets/images/icons/write.png",
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Gap(20)
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const Gap(10),
                    AppInputField(
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: l10n.searchPlaceholder,
                          fillColor: context.colors.greyOutline.withOpacity(.4),
                          prefixIcon: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Gap(10),
                              SvgRenderWidget(
                                  svgPath: "assets/svgs/search.svg"),
                            ],
                          ),
                          suffixIcon: searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear,
                                      color: Colors.red),
                                  onPressed: () {
                                    searchController.clear();
                                    filterRecipes();
                                  },
                                )
                              : null,
                        ),
                      ),
                    ),
                    const Gap(10),
                    SizedBox(
                      height: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            l10n.mealType,
                            style: context.textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 32,
                      margin: const EdgeInsets.only(top: 14),
                      child: ListView.separated(
                        physics: const PageScrollPhysics(),
                        shrinkWrap: false,
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (context, index) => const Gap(10),
                        itemCount: mealType.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                currentIndex = index;
                                filterRecipes();
                              });
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                color: currentIndex == index
                                    ? Palette.black
                                    : null,
                                borderRadius: BorderRadius.circular(14),
                                border: currentIndex != index
                                    ? Border.all(color: Palette.grey)
                                    : null,
                              ),
                              child: Center(
                                child: Text(
                                  mealType[index],
                                  style:
                                      context.textTheme.titleMedium?.copyWith(
                                    color: currentIndex == index
                                        ? Palette.white
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const Gap(10),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _refreshRecipes,
                        child: _buildRecipeList(state),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRecipeList(RecipeState state) {
    if (state is RecipeProcessing &&
        state.isFetching &&
        filteredRecipes.isEmpty) {
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          mainAxisExtent: 250,
        ),
        itemCount: 4,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                const Gap(10),
                Container(
                  width: double.infinity,
                  height: 20,
                  color: Colors.white,
                ),
                const Gap(10),
                Container(
                  width: double.infinity,
                  height: 20,
                  color: Colors.white,
                ),
              ],
            ),
          );
        },
      );
    } else if (filteredRecipes.isEmpty) {
      return ListView(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 25),
                SvgRenderWidget(
                  width: SizeConfig.widthOf(70),
                  height: SizeConfig.widthOf(70),
                  svgPath: SvgPath.itemEmpty,
                ),
                Text(
                  "No recipes found",
                  style: context.textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          mainAxisExtent: 250,
        ),
        itemCount: filteredRecipes.length,
        itemBuilder: (context, index) {
          Recipe recipe = filteredRecipes[index];
          return GestureDetector(
            onTap: () {
              context.go(
                '/main_screen/recipe/view',
                extra: recipe,
              );
            },
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Hero(
                          tag: recipe.id,
                          child: SizedBox(
                            height: 200,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: ImageRenderWidget.network(
                                imageUrl: recipe.recipeImages.isEmpty
                                    ? DevFunction.getAnoymousProfile()
                                    : recipe.recipeImages[0].imageData,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: context.colors.captionGrey.withOpacity(.15),
                          ),
                          child: IconButton(
                            onPressed: () {
                              showFlexibleBottomSheet(
                                bottomSheetColor: Colors.transparent,
                                initHeight: 0.3,
                                context: context,
                                builder: (context, scrollController,
                                    bottomSheetOffset) {
                                  return ModifyRecipe(recipe: recipe);
                                },
                                anchors: [0, 0.5, 1],
                                isSafeArea: true,
                              );
                            },
                            highlightColor: context.primaryColor,
                            icon: Icon(
                              Icons.more_horiz,
                              color: context.colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        recipe.name,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.titleSmall
                            ?.copyWith(fontSize: 10),
                      ),
                    ),
                    Row(
                      children: [
                        Image.asset('assets/images/icons/table_clock.png'),
                        Text(
                          ' ${recipe.totalTime} ${context.l10n.minutes}  ',
                          style: context.textTheme.titleSmall
                              ?.copyWith(fontSize: 8),
                        )
                      ],
                    )
                  ],
                ),
                const Gap(15),
              ],
            ),
          );
        },
      );
    }
  }
}
