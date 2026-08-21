import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maa_design_stitch_viewer/app/core/theme/theme.dart';
import 'package:maa_design_stitch_viewer/app/di/injection.dart';
import 'package:maa_design_stitch_viewer/app/router/app_route_handler.dart';
import 'package:maa_design_stitch_viewer/app/router/app_router.dart';
import 'package:maa_design_stitch_viewer/features/auth/presentation/bloc/bloc.dart';
import 'package:maa_design_stitch_viewer/features/auth/presentation/widgets/widgets.dart';

@RoutePage()
class PhoneLoginScreen extends StatelessWidget {
  const PhoneLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PhoneLoginBloc>(
      create: (_) => getIt<PhoneLoginBloc>(),
      child: const _PhoneLoginContent(),
    );
  }
}

class _PhoneLoginContent extends StatefulWidget {
  const _PhoneLoginContent();

  @override
  State<_PhoneLoginContent> createState() => _PhoneLoginContentState();
}

class _PhoneLoginContentState extends State<_PhoneLoginContent>
    with TickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _headerFadeAnim;
  late Animation<Offset> _headerSlideAnim;
  late Animation<double> _formFadeAnim;
  late Animation<Offset> _formSlideAnim;
  late Animation<double> _buttonScaleAnim;

  // Shake animation on error
  late AnimationController _shakeController;
  late Animation<double> _shakeAnim;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _headerFadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    _headerSlideAnim =
        Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic),
      ),
    );

    _formFadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
      ),
    );

    _formSlideAnim =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _buttonScaleAnim = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.6, 1.0, curve: Curves.elasticOut),
      ),
    );

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _shakeAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 12.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 12.0, end: -12.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -12.0, end: 8.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 8.0, end: -8.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -8.0, end: 0.0), weight: 1),
    ]).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _triggerShake() {
    _shakeController.reset();
    _shakeController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocConsumer<PhoneLoginBloc, PhoneLoginState>(
          listener: (context, state) {
            if (state is PhoneLoginFailure) {
              _triggerShake();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'An error occurred'),
                  backgroundColor: AppColors.error,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppBorderRadius.borderRadius12,
                  ),
                ),
              );
            } else if (state is PhoneLoginSuccess) {
              AppRouteHandler.route.push(
                OtpVerificationRoute(phoneNumber: state.phoneNumber),
              );
            }
          },
          builder: (context, state) {
            final isSubmitting = state is PhoneLoginSubmitting;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSize.size20,
                vertical: AppSize.size24,
              ),
              child: Column(
                children: [
                  AppGaps.gap24,

                  // Header Section with Slide & Fade Animation
                  FadeTransition(
                    opacity: _headerFadeAnim,
                    child: SlideTransition(
                      position: _headerSlideAnim,
                      child: const PhoneLoginHeaderWidget(),
                    ),
                  ),

                  AppGaps.gap24,

                  // Form Section with Shake & Slide Animation
                  AnimatedBuilder(
                    animation: _shakeAnim,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(_shakeAnim.value, 0),
                        child: child,
                      );
                    },
                    child: FadeTransition(
                      opacity: _formFadeAnim,
                      child: SlideTransition(
                        position: _formSlideAnim,
                        child: PhoneInputFieldWidget(
                          phoneNumber: state.phoneNumber,
                          errorMessage: state.errorMessage,
                          enabled: !isSubmitting,
                          onPhoneChanged: (val) {
                            context
                                .read<PhoneLoginBloc>()
                                .add(PhoneLoginNumberChanged(val));
                          },
                        ),
                      ),
                    ),
                  ),

                  AppGaps.gap20,

                  // Button Section with Scale Animation
                  ScaleTransition(
                    scale: _buttonScaleAnim,
                    child: SendOtpButtonWidget(
                      isEnabled: state.isValid,
                      isLoading: isSubmitting,
                      onPressed: () {
                        context
                            .read<PhoneLoginBloc>()
                            .add(const PhoneLoginSubmitted());
                      },
                    ),
                  ),

                  AppGaps.gap16,

                  // Terms & Privacy caption
                  Text(
                    'By continuing, you agree to our Terms of Service\nand Privacy Policy.',
                    style: AppTextStyles.caption,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
