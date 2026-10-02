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
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );

    _headerFadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
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
        curve: const Interval(0.3, 0.75, curve: Curves.easeOut),
      ),
    );

    _formSlideAnim =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _buttonScaleAnim = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.55, 1.0, curve: Curves.easeOutBack),
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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: BlocConsumer<PhoneLoginBloc, PhoneLoginState>(
            listener: (context, state) {
              if (state is PhoneLoginFailure) {
                _triggerShake();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(
                          Icons.error_outline_rounded,
                          color: AppColors.white,
                          size: 20,
                        ),
                        AppGaps.gap12,
                        Expanded(
                          child: Text(
                            state.errorMessage ?? 'An error occurred',
                            style: const TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: AppColors.error,
                    behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.all(AppSize.size16),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppBorderRadius.borderRadius12,
                    ),
                  ),
                );
              } else if (state is PhoneLoginSuccess) {
                if (state.message != null && state.message!.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(
                            Icons.check_circle_outline_rounded,
                            color: AppColors.white,
                            size: 20,
                          ),
                          AppGaps.gap12,
                          Expanded(
                            child: Text(
                              state.message!,
                              style: const TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      backgroundColor: AppColors.primary,
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.all(AppSize.size16),
                      shape: const RoundedRectangleBorder(
                        borderRadius: AppBorderRadius.borderRadius12,
                      ),
                    ),
                  );
                }
                AppRouteHandler.route.push(
                  OtpVerificationRoute(phoneNumber: state.phoneNumber),
                );
              }
            },
            builder: (context, state) {
              final isSubmitting = state is PhoneLoginSubmitting;

              return Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSize.size20,
                    vertical: AppSize.size24,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Header Section
                      FadeTransition(
                        opacity: _headerFadeAnim,
                        child: SlideTransition(
                          position: _headerSlideAnim,
                          child: const PhoneLoginHeaderWidget(),
                        ),
                      ),

                      AppGaps.gap32,

                      // Card Container
                      Container(
                        padding: const EdgeInsets.all(AppSize.size20),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: AppBorderRadius.borderRadius24,
                          border: Border.all(
                            color: AppColors.border.withValues(alpha: 0.8),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.05),
                              blurRadius: 24,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Phone Input with Shake Animation on Error
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

                            // Submit Button
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
                          ],
                        ),
                      ),

                      AppGaps.gap24,

                      // Security & Privacy trust footer
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shield_outlined,
                            size: 16,
                            color: AppColors.textMuted.withValues(alpha: 0.8),
                          ),
                          AppGaps.gap6,
                          Text(
                            'Instant SMS verification code via secure gateway',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textMuted,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      AppGaps.gap12,
                      Text(
                        'By continuing, you agree to our Terms of Service & Privacy Policy.',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textMuted.withValues(alpha: 0.7),
                          fontSize: 11,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
