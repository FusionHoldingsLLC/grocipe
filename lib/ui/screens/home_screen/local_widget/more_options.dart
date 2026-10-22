import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grocipe/app/app_widgets/svg_render_widget.dart';
import 'package:grocipe/helper/settings/palette.dart';
import 'package:grocipe/helper/utils/context_extension.dart';
import 'package:grocipe/models/recipe.dart';
import 'package:share_plus/share_plus.dart';

class MoreOptions extends StatefulWidget {
  const MoreOptions({super.key, required this.recipe});
  final Recipe recipe;
  @override
  State<MoreOptions> createState() => _MoreOptionsState();
}

class _MoreOptionsState extends State<MoreOptions> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Palette.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Palette.grey.withOpacity(0.3),
                child: IconButton(
                  onPressed: () {
                    context.pop();
                  },
                  icon: Image.asset('assets/images/icons/cancel.png'),
                ),
              ),
            ],
          ),
          ListTile(
            onTap: () {
              context.pop();
              context.go(
                '/main_screen/recipe/update',
                extra: widget.recipe,
              );
            },
            leading: const SvgRenderWidget(svgPath: "assets/svgs/edit.svg"),
            title: Text('Edit Recipe', style: context.textTheme.titleMedium),
          ),
          const Divider(),
          ListTile(
            onTap: () {
              final String recipeDetails =
                  'Check out this recipe: ${widget.recipe.name}\n\n'
                  '${widget.recipe.url}';
              Share.share(recipeDetails);
            },
            leading: Icon(
              Icons.file_upload_outlined,
              color: context.colors.black,
            ),
            title: Text('Share Recipe', style: context.textTheme.titleMedium),
          ),
        ],
      ),
    );
  }
}
