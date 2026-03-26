import 'package:flutter/material.dart';
import 'package:second_hand_electronics_marketplace/core/constants/app_sizes.dart';
import 'package:second_hand_electronics_marketplace/core/widgets/bottom_sheet_header.dart';
import 'package:second_hand_electronics_marketplace/core/widgets/category_item.dart';
import 'package:second_hand_electronics_marketplace/core/widgets/search_widget.dart';
import 'package:second_hand_electronics_marketplace/features/listing/data/models/listing_field_config.dart';

class ListingCategorySheet extends StatefulWidget {
  const ListingCategorySheet({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onSelected,
    this.isLoading = false,
    this.errorMessage = '',
    this.onRetry,
  });

  final List<ListingCategoryConfig> categories;
  final String selectedCategoryId;
  final ValueChanged<ListingCategoryConfig> onSelected;
  final bool isLoading;
  final String errorMessage;
  final VoidCallback? onRetry;

  @override
  State<ListingCategorySheet> createState() => _ListingCategorySheetState();
}

class _ListingCategorySheetState extends State<ListingCategorySheet> {
  late List<ListingCategoryConfig> _filtered;
  late TextEditingController _controller;
  ListingCategoryConfig? _selected;

  @override
  void initState() {
    super.initState();
    _filtered = widget.categories;
    _controller = TextEditingController();
    for (final category in widget.categories) {
      if (category.id == widget.selectedCategoryId) {
        _selected = category;
        break;
      }
    }
  }

  void _runFilter(String value) {
    if (value.trim().isEmpty) {
      setState(() => _filtered = widget.categories);
      return;
    }
    setState(() {
      _filtered =
          widget.categories
              .where((c) => c.name.toLowerCase().contains(value.toLowerCase()))
              .toList();
    });
  }

  @override
  void didUpdateWidget(covariant ListingCategorySheet oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.categories != widget.categories) {
      final query = _controller.text.trim();
      if (query.isEmpty) {
        _filtered = widget.categories;
      } else {
        _filtered =
            widget.categories
                .where(
                  (c) => c.name.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();
      }
    }

    if (oldWidget.selectedCategoryId != widget.selectedCategoryId ||
        oldWidget.categories != widget.categories) {
      _selected = null;
      for (final category in widget.categories) {
        if (category.id == widget.selectedCategoryId) {
          _selected = category;
          break;
        }
      }
    }
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
        children: [
          BottomSheetHeader(
            title: 'Listing category',
            onClose: () => Navigator.pop(context),
          ),
          const SizedBox(height: AppSizes.paddingM),
          SearchWidget(
            controller: _controller,
            onChanged: widget.isLoading ? (_) {} : _runFilter,
          ),
          const SizedBox(height: AppSizes.paddingM),
          Expanded(
            child:
                widget.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _buildCategoryContent(),
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
              child: const Text('Select Category'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryContent() {
    if (widget.errorMessage.trim().isNotEmpty && _filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.errorMessage, textAlign: TextAlign.center),
            if (widget.onRetry != null) ...[
              const SizedBox(height: AppSizes.paddingS),
              ElevatedButton(
                onPressed: widget.onRetry,
                child: const Text('Retry'),
              ),
            ],
          ],
        ),
      );
    }

    if (_filtered.isEmpty) {
      return const Center(child: Text('No categories found'));
    }

    return GridView.builder(
      itemCount: _filtered.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: AppSizes.paddingS,
        crossAxisSpacing: AppSizes.paddingS,
        childAspectRatio: 0.9,
      ),
      itemBuilder: (context, index) {
        final category = _filtered[index];
        return CategoryItem(
          title: category.name,
          iconPath: category.icon,
          isSelected: _selected?.id == category.id,
          onTap: () => setState(() => _selected = category),
        );
      },
    );
  }
}
