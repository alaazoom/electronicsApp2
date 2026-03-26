import 'package:flutter/material.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/app_colors.dart';

class CategoriesChip extends StatefulWidget {
  CategoriesChip({
    super.key,
    required this.label,
    this.isSelected = false,
    required this.onSelected,
  });

  final String label;
  bool isSelected;
  final ValueChanged<bool> onSelected;

  @override
  State<CategoriesChip> createState() => _CategoriesChipState();
}

class _CategoriesChipState extends State<CategoriesChip> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        setState(() {
          widget.isSelected = !widget.isSelected;
        });
        widget.onSelected(widget.isSelected);
      },
      child: Text(
        widget.label,
        style: TextStyle(
          fontSize: 12,
          color: widget.isSelected ? Colors.white : Theme.of(context).hintColor,
        ),
      ),
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 6),
        backgroundColor:
            widget.isSelected ? context.colors.mainColor : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color:
                widget.isSelected
                    ? context.colors.mainColor
                    : const Color.fromARGB(255, 171, 172, 172),
          ),
        ),
      ),
    );
  }
}
