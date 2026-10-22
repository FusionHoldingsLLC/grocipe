import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:gap/gap.dart';
import 'package:grocipe/app/app_widgets/app_back_button.dart';
import 'package:grocipe/helper/settings/palette.dart';
import 'package:grocipe/helper/size_config/size_config.dart';
import 'package:grocipe/helper/utils/context_extension.dart';
import 'package:grocipe/models/instruction.dart';
import 'package:grocipe/models/recipe.dart';
import 'package:slide_countdown/slide_countdown.dart';

class InstructionDemo extends StatefulWidget {
  const InstructionDemo({super.key, required this.recipe});
  final Object recipe;

  @override
  State<InstructionDemo> createState() => _InstructionDemoState();
}

class _InstructionDemoState extends State<InstructionDemo> {
  late Recipe recipe;
  final List<StreamDuration> _streamDurations = [];
  List<bool> isPaused = [];
  int currentIndex = 0;

  final CarouselSliderController _pageController = CarouselSliderController();

  @override
  void initState() {
    super.initState();
    if (widget.recipe is Recipe) {
      recipe = widget.recipe as Recipe;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    init();
  }

  init() {
    for (int i = 0; i < (recipe.instructions.length); i++) {
      _streamDurations.add(StreamDuration(
        config: StreamDurationConfig(
          autoPlay: false,
          countDownConfig: CountDownConfig(
            duration:
                Duration(minutes: recipe.instructions[i].duration ?? 0000),
          ),
        ),
      ));

      isPaused.add(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100,
        leading: const AppBackButton(),
        title: const Text("Instructions"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            children: [
              CarouselSlider.builder(
                itemCount: recipe.instructions.length,
                carouselController: _pageController,
                itemBuilder: (context, index, realIndex) {
                  Instruction2 instruction = recipe.instructions[index];

                  return Column(
                    children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          height: SizeConfig.heightOf(70),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Step ${instruction.order}/${recipe.instructions.length}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),
                              const Gap(30),
                              Expanded(
                                child: Text(
                                  instruction.instruction,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Palette.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Gap(10),
                      Column(
                        children: [
                          if ((_streamDurations[index]
                                      .config
                                      .countDownConfig
                                      ?.duration
                                      .inSeconds ??
                                  0) ==
                              0) ...[
                            Container(),
                          ] else ...[
                            SlideCountdown(
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.w700,
                                // backgroundColor: Pa
                              ),
                              separatorStyle: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.w700,
                                // backgroundColor: Pa
                              ),
                              decoration: BoxDecoration(
                                color: Palette.white,
                              ),
                              onChanged: (c) {},
                              // This duration no effect if you customize stream duration
                              streamDuration: _streamDurations[index],
                              shouldShowHours: (mike) {
                                return false;
                              },
                              shouldShowDays: (mike) {
                                return false;
                              },
                            ),
                          ]
                        ],
                      ),
                    ],
                  );
                },
                options: CarouselOptions(
                  enableInfiniteScroll: false,
                  enlargeCenterPage: true,
                  autoPlay: false,
                  height: SizeConfig.heightOf(70),
                  autoPlayInterval: const Duration(seconds: 10),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  pauseAutoPlayOnTouch: true,
                  viewportFraction: 0.8,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _streamDurations[currentIndex].pause();
                      isPaused[currentIndex] = true;
                      currentIndex = index;
                    });
                  },
                ),
              ),
              const Gap(20),
              Expanded(
                child: Column(
                  children: [
                    const Gap(10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _pageController.previousPage(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.linear,
                                );
                              });
                            },
                            child: currentIndex == 0
                                ? const SizedBox(
                                    height: 50,
                                    width: 50,
                                  )
                                : Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.chevron_left,
                                        size: 30,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                  ),
                          ),
                          (recipe.instructions[currentIndex].duration ??
                                      0000) ==
                                  00
                              ? Container()
                              : Container(
                                  width: 150,
                                  height: 56,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: context.colors.black),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: isPaused[currentIndex]
                                            ? () {
                                                _streamDurations[currentIndex]
                                                    .play();

                                                _streamDurations[currentIndex]
                                                    .resume();
                                                isPaused[currentIndex] = false;
                                                setState(() {});
                                              }
                                            : () {
                                                _streamDurations[currentIndex]
                                                    .pause();
                                                isPaused[currentIndex] = true;

                                                setState(() {});
                                              },
                                        child: Icon(
                                          isPaused[currentIndex]
                                              ? Icons
                                                  .play_circle_outline_outlined
                                              : Icons.pause_circle_outline,
                                          color: Palette.green,
                                          size: 25,
                                        ),
                                      ),
                                      const Gap(40),
                                      InkWell(
                                        onTap: () {
                                          if (isPaused[currentIndex]) {
                                            _streamDurations[currentIndex]
                                                .resume();

                                            isPaused[currentIndex] = false;
                                          }

                                          _streamDurations[currentIndex].change(
                                              Duration(
                                                  minutes: recipe
                                                          .instructions[
                                                              currentIndex]
                                                          .duration ??
                                                      0));

                                          setState(() {});

                                          // context.pop();
                                        },
                                        child: Icon(
                                          isPaused[currentIndex]
                                              ? Icons.stop_circle_outlined
                                              : Icons.stop_circle_outlined,
                                          color: Palette.white,
                                          size: 25,
                                        ),
                                      ),
                                    ],
                                  )),
                          GestureDetector(
                            onTap: () {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.linear,
                              );
                            },
                            child: currentIndex ==
                                    (recipe.instructions.length) - 1
                                ? const SizedBox(
                                    height: 50,
                                    width: 50,
                                  )
                                : Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                        child: Icon(
                                      Icons.chevron_right,
                                      size: 30,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    )),
                                  ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
