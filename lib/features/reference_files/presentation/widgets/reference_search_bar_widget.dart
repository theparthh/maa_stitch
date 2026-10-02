import 'package:flutter/material.dart';
import 'package:maa_design_stitch_viewer/app/core/core.dart';

/// Reusable search bar for folder/file browsing.
class ReferenceSearchBarWidget extends StatefulWidget {
  const ReferenceSearchBarWidget({
    super.key,
    required this.hint,
    required this.query,
    required this.onChanged,
  });

  final String hint;
  final String query;
  final ValueChanged<String> onChanged;

  @override
  State<ReferenceSearchBarWidget> createState() =>
      _ReferenceSearchBarWidgetState();
}

class _ReferenceSearchBarWidgetState extends State<ReferenceSearchBarWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.query);
  }

  @override
  void didUpdateWidget(covariant ReferenceSearchBarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset when external query is cleared (e.g. navigation back)
    if (widget.query.isEmpty && _controller.text.isNotEmpty) {
      _controller.clear();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: AppBorderRadius.borderRadius14,
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: AppTextStyles.bodyMedium,
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.grey,
            size: AppSize.size20,
          ),
          suffixIcon: widget.query.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close_rounded,
                      color: AppColors.grey, size: AppSize.size20),
                  onPressed: () {
                    _controller.clear();
                    widget.onChanged('');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSize.size16,
            vertical: AppSize.size14,
          ),
        ),
      ),
    );
  }
}
