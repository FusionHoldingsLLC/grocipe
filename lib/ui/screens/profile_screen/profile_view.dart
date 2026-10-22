import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:grocipe/app/app_widgets/app_back_button.dart';
import 'package:grocipe/app/app_widgets/custom_button.dart';
import 'package:grocipe/app/app_widgets/custom_list_tile.dart';
import 'package:grocipe/app/app_widgets/image_render_widget.dart';
import 'package:grocipe/app/app_widgets/svg_render_widget.dart';
import 'package:grocipe/blocs/user_bloc/user_bloc.dart';
import 'package:grocipe/helper/language_config/lang_extension.dart';
import 'package:grocipe/helper/settings/dev_functions.dart';
import 'package:grocipe/helper/settings/palette.dart';
import 'package:grocipe/helper/third_party/hive.dart';
import 'package:grocipe/helper/utils/context_extension.dart';
import 'package:grocipe/models/meal_plan_menu.dart';
import 'package:grocipe/navigation/route_names.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, this.isFromBtNav = false});

  final bool isFromBtNav;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _imageFile;
  Box<MealPlanMenu>? _mealPlanBox;
  Box? _groceryorderBox;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _initializeBox() async {
    try {
      _mealPlanBox = await Hive.openBox<MealPlanMenu>('mealPlanBox');
      _groceryorderBox = await Hive.openBox('groceryOrdersCache');

      print('Box initialized successfully');
    } catch (e) {
      print('Error initializing box: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    _initializeBox();

    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.settingsTitle),
            leading: !widget.isFromBtNav ? AppBackButton() : null,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: _imageFile != null
                            ? Image.file(_imageFile!, fit: BoxFit.cover)
                            : ImageRenderWidget.network(
                                imageUrl: state.user?.profilePictureUrl ??
                                    DevFunction.getAnoymousProfile(),
                                fit: BoxFit.cover,
                                placeholder: Row(
                                  children: [
                                    SvgRenderWidget(
                                      svgPath: "assets/svgs/user_icon.svg",
                                      color: context.colors.black,
                                      height: 100,
                                      width: 100,
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: context.primaryColor,
                        ),
                        child: SizedBox(
                          height: 35,
                          width: 35,
                          child: IconButton(
                            icon: Icon(Icons.camera_alt,
                                size: 16, color: context.colors.white),
                            // onPressed: _pickImage,
                            onPressed: () async {
                              await _pickImage();
                              if (_imageFile != null) {
                                context.read<UserBloc>().add(
                                      UpdateUserEvent(
                                        f_name: state.user?.firstName ?? '',
                                        l_name: state.user?.lastName ?? '',
                                        email: state.user?.email ?? '',
                                        image: _imageFile?.path ?? "",
                                        isOnline: false,
                                      ),
                                    );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(20),
                CustomListTile(
                  title: l10n.accountSettingsTitle,
                  leading: "assets/svgs/person_settings.svg",
                  ontap: () {
                    context.go('/main_screen/edit/profile');
                  },
                ),
                const Gap(20),
                CustomListTile(
                  title: l10n.changePasswordTitle,
                  leading: "assets/svgs/lock.svg",
                  ontap: () {
                    context.go('/main_screen/edit/password');
                  },
                ),
                const Gap(20),
                CustomListTile(
                  title: "Manage subscription",
                  leading: "assets/svgs/monetize.svg",
                  ontap: () {
                    context.goNamed(Routes.manageSubscription);
                  },
                ),
              ],
            ),
          ),
          bottomSheet: Consumer(builder: (context, ref, child) {
            var storage = ref.read(localStorageService);

            return SizedBox(
              height: 100,
              child: Center(
                child: CustomButton(
                  onTap: () async {
                    storage.clearSession();
                    HiveFunction.deleteAllExceptUser();
                    context.read<UserBloc>().add(ClearUserEvent());
                    _groceryorderBox?.clear();
                    _mealPlanBox?.clear();
                    context.go('/auth');
                  },
                  title: "",
                  titleWidget: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.logout,
                          color: Palette.white,
                        ),
                        const Gap(10),
                        Text(
                          l10n.logOutButton,
                          style: TextStyle(
                            color: Palette.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
