import 'package:flutter/material.dart';
import 'package:grocipe/app/app_widgets/svg_render_widget.dart';
import 'package:grocipe/helper/utils/context_extension.dart';

class CustomListTile extends StatefulWidget {
  const CustomListTile({
    super.key,
    required this.title,
    required this.leading,
    required this.ontap,
    this.trailing,
    this.isDelete = false,
  });
  final String title;
  final String leading;
  final IconData? trailing;
  final bool isDelete;
  final VoidCallback ontap;

  @override
  State<CustomListTile> createState() => _CustomListTileState();
}

class _CustomListTileState extends State<CustomListTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.ontap,
      child: Container(
        decoration: BoxDecoration(
            color: widget.isDelete
                ? context.colors.white
                : context.colors.greyDecor,
            border: widget.isDelete
                ? Border.all(width: 1, color: context.colors.red)
                : null,
            borderRadius: BorderRadius.circular(13)),
        child: ListTile(
          leading: SvgRenderWidget(
            svgPath: widget.leading,
          ),
          title: Text(
            widget.title,
            style: context.textTheme.titleMedium?.copyWith(
                color: widget.isDelete
                    ? context.colors.red
                    : context.colors.black),
          ),
          trailing: Icon(widget.trailing ?? Icons.chevron_right_rounded),
        ),
      ),
    );
  }
}
