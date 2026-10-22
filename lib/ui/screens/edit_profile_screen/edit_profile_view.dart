// ignore_for_file: unused_field, unused_element, use_build_context_synchronously

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:grocipe/app/app_widgets/app_back_button.dart';
import 'package:grocipe/app/app_widgets/app_input_field.dart';
import 'package:grocipe/app/app_widgets/custom_button.dart';
import 'package:grocipe/app/app_widgets/custom_list_tile.dart';
import 'package:grocipe/blocs/user_bloc/user_bloc.dart';
import 'package:grocipe/helper/language_config/lang_extension.dart';
import 'package:grocipe/helper/utils/context_extension.dart';
import 'package:grocipe/helper/utils/image_utils.dart';
import 'package:grocipe/helper/utils/url_launcher_service.dart';
import 'package:grocipe/models/user.dart';

class EditprofileScren extends StatefulWidget {
  const EditprofileScren({super.key});
  static String id = "/sign_up";
  @override
  State<EditprofileScren> createState() => _EditprofileScrenState();
}

class _EditprofileScrenState extends State<EditprofileScren> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();

  bool obscuretext = true;
  bool obscuretext2 = true;
  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  bool loading = false;
  String _imageFile = '';
  String imageName = '';
  bool isOnline = true;
  bool agreedTerms = false;
  late TapGestureRecognizer _tapGestureRecognizer;
  late TapGestureRecognizer _tapGestureRecognizerTerms;
  @override
  void initState() {
    super.initState();

    User user = context.read<UserBloc>().state.user!;
    _emailController.text = user.email;
    _nameController.text = user.firstName;
    _lnameController.text = user.lastName;
    _imageFile = user.profilePictureUrl;
    _tapGestureRecognizer = TapGestureRecognizer()
      ..onTap = () async {
        var url = "github.com/mik3yyy/study_stat_policy";

        AppInterfaceService.launchLink(url);
      };
    _tapGestureRecognizerTerms = TapGestureRecognizer()..onTap = () async {};
  }

  void _pickImageFromGallery() async {
    try {
      final pickedImage = await ImageUtils.pickImage(100);
      if (pickedImage?.path != null) {
        setState(() {
          isOnline = false;
          imageName = "Image.png";
          _imageFile = pickedImage!.path;
        });
      }
    } catch (e) {
      context.showErrorSnackBar(context.l10n.invalidImage);
    }
  }

  void _pickImageFromCamera() async {
    try {
      final pickedImage = await ImageUtils.pickImage(100);
      if (pickedImage?.path != null) {
        setState(() {
          _imageFile = pickedImage!.path;
        });
      }
    } catch (e) {
      context.showErrorSnackBar(context.l10n.invalidImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        leadingWidth: 100,
        title: Text(
          l10n.accountSettings,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state is userLoaded) {
            // context.showSuccessSnackBar(state.message);
            context.pop();
          } else if (state is UserError) {
            context.showErrorSnackBar(state.message);
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: SizedBox(
                height: MediaQuery.sizeOf(context).height,
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Gap(20),
                            AppInputField(
                              title: l10n.firstName,
                              child: TextFormField(
                                controller: _nameController,
                                decoration:
                                    InputDecoration(hintText: l10n.firstName),
                              ),
                            ),
                            const Gap(20),
                            AppInputField(
                              title: l10n.lastName,
                              child: TextFormField(
                                controller: _lnameController,
                                decoration: InputDecoration(
                                  hintText: l10n.lastName,
                                ),
                              ),
                            ),
                            const Gap(20),
                            AppInputField(
                              title: l10n.email,
                              child: TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  hintText: l10n.hintEmail,
                                ),
                              ),
                            ),
                            const Gap(20),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        height: 400,
        color: Colors.transparent,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomButton(
                enable: true,
                onTap: () async {
                  context.read<UserBloc>().add(
                        UpdateUserEvent(
                          f_name: _nameController.text,
                          l_name: _lnameController.text,
                          email: _emailController.text,
                          image: _imageFile,
                          isOnline: isOnline,
                        ),
                      );
                },
                title: l10n.saveUpdate,
                loading: loading,
              ),
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: CustomListTile(
                  title: l10n.deleteAccountTitle,
                  isDelete: true,
                  leading: "assets/svgs/delete.svg",
                  ontap: () {
                    context.go("/main_screen/profile/delete_warning");
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
