import 'package:flutter/material.dart';
import 'package:maa_design_stitch_viewer/app/core/theme/theme.dart';

class OtpVerificationShimmerWidget extends StatefulWidget {
  const OtpVerificationShimmerWidget({super.key});

  @override
  State<OtpVerificationShimmerWidget> createState() =>
      _OtpVerificationShimmerWidgetState();
}

class _OtpVerificationShimmerWidgetState
    extends State<OtpVerificationShimmerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildShimmerBox({
    required double width,
    required double height,
    BorderRadius borderRadius = AppBorderRadius.borderRadius12,
  }) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: const [
                Color(0xFFE2E8F0),
                Color(0xFFF8FAFC),
                Color(0xFFE2E8F0),
              ],
              stops: [
                (_animation.value - 0.3).clamp(0.0, 1.0),
                _animation.value.clamp(0.0, 1.0),
                (_animation.value + 0.3).clamp(0.0, 1.0),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildShimmerBox(
          width: AppSize.size80,
          height: AppSize.size80,
          borderRadius: AppBorderRadius.borderRadius24,
        ),
        AppGaps.gap24,
        _buildShimmerBox(width: AppSize.size200, height: AppSize.size32),
        AppGaps.gap12,
        _buildShimmerBox(width: AppSize.size240, height: AppSize.size16),
        AppGaps.gap32,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            4,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSize.size8),
              child: _buildShimmerBox(
                width: AppSize.size64,
                height: AppSize.size64,
                borderRadius: AppBorderRadius.borderRadius16,
              ),
            ),
          ),
        ),
        AppGaps.gap32,
        _buildShimmerBox(
          width: double.infinity,
          height: AppSize.size56,
          borderRadius: AppBorderRadius.borderRadius16,
        ),
      ],
    );
  }
}
