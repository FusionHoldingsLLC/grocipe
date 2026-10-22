import 'package:flutter/material.dart';
import 'package:grocipe/helper/utils/context_extension.dart';

class RoundedWrapItems extends StatefulWidget {
  final List<String> options;
  final bool allowMultiple;
  final bool showIcon;
  final Function(List<String>) onSelected;

  const RoundedWrapItems({
    super.key,
    required this.options,
    this.allowMultiple = false,
    this.showIcon = false,
    required this.onSelected,
  });

  @override
  RoundedWrapItemsState createState() => RoundedWrapItemsState();
}

class RoundedWrapItemsState extends State<RoundedWrapItems> {
  late List<bool> selectedIndexes;

  @override
  void initState() {
    super.initState();
    selectedIndexes = List<bool>.filled(widget.options.length, false);
  }

  void _onOptionSelected(int index) {
    setState(() {
      if (widget.allowMultiple) {
        selectedIndexes[index] = !selectedIndexes[index];
      } else {
        for (int i = 0; i < selectedIndexes.length; i++) {
          selectedIndexes[i] = i == index;
        }
      }
    });

    // Notify parent widget of selected options
    final selectedOptions = widget.options
        .asMap()
        .entries
        .where((entry) => selectedIndexes[entry.key])
        .map((entry) => entry.value)
        .toList();
    widget.onSelected(selectedOptions);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 15.0,
      runSpacing: 5.0,
      children: List.generate(
        widget.options.length,
        (index) => RoundedToggleButton(
          text: widget.options[index],
          showIcon: widget.showIcon,
          isSelected: selectedIndexes[index],
          onTap: () => _onOptionSelected(index),
        ),
      ),
    );
  }
}

class RoundedToggleButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final bool showIcon;
  final VoidCallback onTap;

  const RoundedToggleButton({
    super.key,
    required this.text,
    required this.isSelected,
    this.showIcon = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showIcon)
          Icon(Icons.check_circle,
              color:
                  isSelected ? context.primaryColor : context.colors.greyDecor,
              size: 24),
        if (showIcon) const SizedBox(width: 15),
        ActionChip(
          label: Text(
            text,
            style: context.textTheme.titleMedium?.copyWith(
              color: isSelected ? Colors.white : context.primaryColor,
            ),
          ),
          backgroundColor:
              isSelected ? context.primaryColor : Colors.transparent,
          onPressed: onTap,
          side: BorderSide(color: context.primaryColor, width: 1.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }
}
