import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:grocipe/app/app_theme/theme.dart';
import 'package:grocipe/helper/constants/const.dart';
import 'package:grocipe/helper/settings/palette.dart';
import 'package:grocipe/helper/size_config/size_config.dart';
import 'package:grocipe/helper/utils/context_extension.dart';
import 'package:grocipe/local_storage/weeks_mealplan_adapter.dart';
import 'package:grocipe/models/meal_plan_menu.dart';
import 'package:grocipe/models/plan.dart';
import 'package:grocipe/models/states/app_state.dart';
import 'package:grocipe/navigation/route_names.dart';
import 'package:grocipe/services/meal_service.dart';
import 'package:grocipe/ui/screens/meal_screen/meal_plan_providers/meal_plan_menu_provider.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

class MealPlanScreen extends ConsumerStatefulWidget {
  const MealPlanScreen({super.key});

  @override
  MealPlanScreenState createState() => MealPlanScreenState();
}

class MealPlanScreenState extends ConsumerState<MealPlanScreen> {
  late DateTime startDate;
  late DateTime endDate;
  bool allowNextBack = true;

  MealplanService get service => ref.read(mealPlanService);
  @override
  void initState() {
    super.initState();
    int currentDay = DateTime.now().weekday;
    startDate = DateTime.now().subtract(Duration(days: currentDay - 1));
    endDate = startDate.add(const Duration(days: 6));
    Hive.openBox<MealPlanMenu>('mealPlanBox');

    setWeek(DateTime.now());
  }

  void creatNewWeek() async {
    var newDate = {
      "week_start_date": startDate,
      "week_end_date": endDate,
      "days": []
    };
    await service.createMealplan(newDate);
  }

  void setWeek(DateTime date) async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      int currentDay = date.weekday;
      setState(() {
        startDate = date.subtract(Duration(days: currentDay % 7));
        endDate = startDate.add(const Duration(days: 6));
      });
      setState(() => allowNextBack = false);

      Map<String, dynamic> data = {
        'start_date': convertToDateString(startDate),
        'end_date': convertToDateString(endDate),
      };

      var mealPlanMenu = await ref
          .read(mealplanMenuProvider.notifier)
          .getMealPlanFromApi(data);

      if (mealPlanMenu != null) {
        setState(() => allowNextBack = true);
      } else {
        context.showErrorSnackBar("Failed to refresh");
      }
    });
  }

  void nextWeek() {
    allowNextBack ? setWeek(startDate.add(const Duration(days: 7))) : () {};
    print("the new start date $startDate");
    creatNewWeek();
    // ref.read(mealplanMenuProvider.notifier).nextWeek(startDate);
  }

  void previousWeek() {
    allowNextBack
        ? setWeek(startDate.subtract(const Duration(days: 7)))
        : () {};
    creatNewWeek();
    // ref.read(mealplanMenuProvider.notifier).previousWeek(startDate);
  }

  String formatDateString(DateTime date) {
    final now = DateTime.now();
    final isSameYear = date.year == now.year;

    if (isSameYear) {
      return DateFormat('d MMM').format(date);
    } else {
      return DateFormat('d MMM yyyy').format(date);
    }
  }

  List<String> days = ["Sun", "Mon", "Tue", "Wed", "Thurs", "Fri", "Sat"];
  List<String> daysDetail = [
    "sunday",
    "monday",
    "tuesday",
    "wednesday",
    "thursday",
    "friday",
    "saturday"
  ];
  List<String> meals = ["Breakfast", "Lunch", "Dinner", "Others"];

  MealPlanHiveService get weekMealplanStorage =>
      ref.read(weeklyMealplanStorageService);

  Widget buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 7,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  color: Colors.white,
                ),
                const Gap(10),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(4, (mealIndex) {
                      return Container(
                        width: 85,
                        height: 80,
                        color: Colors.white,
                      );
                    }),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mealPlanState = ref.watch(mealplanMenuProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Plan'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            width: MediaQuery.sizeOf(context).width * .7,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Palette.grey,
                  ),
                  onPressed: previousWeek,
                ),
                Text(
                  '${formatDateString(startDate)} - ${formatDateString(endDate)}',
                  style: context.textTheme.displayMedium,
                ),
                IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: Palette.grey,
                  ),
                  onPressed: nextWeek,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Row(
              children: [
                Expanded(child: const SizedBox(width: 70, child: Text(" "))),
                const Gap(5),
                Expanded(
                  child: Text("Breakfast",
                      textAlign: TextAlign.center,
                      style: context.textTheme.titleMedium),
                ),
                const Gap(5),
                Expanded(
                    child: Text("Lunch",
                        textAlign: TextAlign.center,
                        style: context.textTheme.titleMedium)),
                const Gap(5),
                Expanded(
                    child: Text("Dinner",
                        textAlign: TextAlign.center,
                        style: context.textTheme.titleMedium)),
                const Gap(5),
                Expanded(
                    child: Text("Others",
                        textAlign: TextAlign.center,
                        style: context.textTheme.titleMedium)),
                const Gap(5),
              ],
            ),
          ),
          const Gap(20),
          Divider(
            color: Theme.of(context).colorScheme.secondary,
            height: 0.2,
          ),
          Expanded(
            child: mealPlanState is LoadingAppState
                ? buildShimmerLoading()
                : mealPlanState is SuccessAppState<MealPlanMenu>
                    ? ListView.separated(
                        separatorBuilder: (context, index) => Divider(
                          color: Theme.of(context).colorScheme.secondary,
                          height: 0.2,
                        ),
                        itemCount: 7,
                        itemBuilder: (context, index) {
                          DayMealsData? dayPlan =
                              mealPlanState.data.days?[daysDetail[index]];

                          return SizedBox(
                            height: SizeConfig.heightOf(10),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: SizedBox(
                                    height: SizeConfig.heightOf(10),
                                    width: 70,
                                    child: Center(
                                      child: Text(days[index]),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Row(
                                    children: List.generate(4, (mealIndex) {
                                      final mealName =
                                          meals[mealIndex].toLowerCase();
                                      final List<Meal> mealsList;

                                      if (mealName == "breakfast") {
                                        mealsList = dayPlan?.breakfast ?? [];
                                      } else if (mealName == "lunch") {
                                        mealsList = dayPlan?.lunch ?? [];
                                      } else if (mealName == "dinner") {
                                        mealsList = dayPlan?.dinner ?? [];
                                      } else {
                                        mealsList = dayPlan?.others ?? [];
                                      }

                                      // Concatenate all recipe and grocery names
                                      String result = mealsList
                                          .map((meal) {
                                            String name = meal.recipe
                                                    ?.map(
                                                        (recipe) => recipe.name)
                                                    .join(', ') ??
                                                "";
                                            if (name.isEmpty) {
                                              name = meal.grocery
                                                      ?.map((grocery) =>
                                                          grocery.itemName)
                                                      .join(', ') ??
                                                  "";
                                            }
                                            return name;
                                          })
                                          .where((name) => name.isNotEmpty)
                                          .join(', ');

                                      if (result.isEmpty) {
                                        result = "+";
                                      }

                                      return Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            var dateIsRegistered =
                                                weekMealplanStorage
                                                    .mealPlanExists(
                                                        convertToDateString(
                                                            startDate));

                                            context.goNamed(Routes.createPlan,
                                                extra: PlanExtras(
                                                  plan: Plan(
                                                    day: daysDetail[index],
                                                    meal: meals[mealIndex],
                                                    startDate: startDate,
                                                    endDate: endDate,
                                                    dateIsRegistered:
                                                        dateIsRegistered,
                                                  ),
                                                  mealPlanMenu:
                                                      mealPlanState.data,
                                                ));
                                          },
                                          child: Container(
                                            height: SizeConfig.heightOf(10),
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 3),
                                            color: mealsList.isNotEmpty
                                                ? healthRatingColor(
                                                    mealsList[0]
                                                                .recipe
                                                                ?.isNotEmpty ==
                                                            true
                                                        ? mealsList[0]
                                                                .recipe![0]
                                                                .name ??
                                                            ""
                                                        : mealsList[0]
                                                                .grocery
                                                                ?.first
                                                                .itemName ??
                                                            "",
                                                    mealName,
                                                    days[index],
                                                  )
                                                : Colors.grey.withOpacity(0.01),
                                            child: Center(
                                              child: Text(
                                                result,
                                                style: context
                                                    .textTheme.titleSmall
                                                    ?.copyWith(
                                                  color: mealsList.isNotEmpty
                                                      ? Colors.black
                                                      : Palette.grey
                                                          .withOpacity(.6),
                                                  fontSize: mealsList.isNotEmpty
                                                      ? 10
                                                      : 24,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    : const Center(child: Text('No meal plan available')),
          ),
        ],
      ),
    );
  }
}
