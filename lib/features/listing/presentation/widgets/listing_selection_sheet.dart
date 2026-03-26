import 'package:flutter/material.dart';
import 'package:second_hand_electronics_marketplace/core/constants/app_sizes.dart';
import 'package:second_hand_electronics_marketplace/core/widgets/bottom_sheet_header.dart';
import 'package:second_hand_electronics_marketplace/core/widgets/custom_radio_button_item.dart';
import 'package:second_hand_electronics_marketplace/core/widgets/search_widget.dart';

class ListingSelectionSheet extends StatefulWidget {
  const ListingSelectionSheet({
    super.key,
    required this.title,
    required this.options,
    required this.selectedValue,
    required this.onSelected,
    this.confirmText = 'Select',
    this.searchHint = 'Search ...',
  });

  final String title;
  final List<String> options;
  final String selectedValue;
  final ValueChanged<String> onSelected;
  final String confirmText;
  final String searchHint;

  @override
  State<ListingSelectionSheet> createState() => _ListingSelectionSheetState();
}

class _ListingSelectionSheetState extends State<ListingSelectionSheet> {
  late List<String> _filtered;
  late TextEditingController _controller;
  String? _selected;

  @override
  void initState() {
    super.initState();
    _filtered = widget.options;
    _controller = TextEditingController();
    _selected = widget.selectedValue.isEmpty ? null : widget.selectedValue;
  }

  void _runFilter(String value) {
    if (value.trim().isEmpty) {
      setState(() => _filtered = widget.options);
      return;
    }
    setState(() {
      _filtered =
          widget.options
              .where((o) => o.toLowerCase().contains(value.toLowerCase()))
              .toList();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.paddingM,
        AppSizes.paddingM,
        AppSizes.paddingM,
        AppSizes.paddingL,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BottomSheetHeader(
            title: widget.title,
            onClose: () => Navigator.pop(context),
          ),
          const SizedBox(height: AppSizes.paddingM),
          SearchWidget(controller: _controller, onChanged: _runFilter),
          const SizedBox(height: AppSizes.paddingM),
          Expanded(
            child: ListView.separated(
              itemCount: _filtered.length,
              separatorBuilder:
                  (_, __) => const SizedBox(height: AppSizes.paddingS),
              itemBuilder: (context, index) {
                final option = _filtered[index];
                return CustomRadioButtonItem(
                  label: option,
                  isSelected: _selected == option,
                  onTap: () {
                    setState(() => _selected = option);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: AppSizes.paddingM),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
                  _selected == null
                      ? null
                      : () {
                        widget.onSelected(_selected!);
                        Navigator.pop(context);
                      },
              child: Text('${widget.confirmText} ${widget.title}'),
            ),
          ),
        ],
      ),
    );
  }
}
