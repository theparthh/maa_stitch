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
class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
  });

  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OtpVerificationBloc>(
      create: (_) => getIt<OtpVerificationBloc>(),
      child: _OtpVerificationContent(phoneNumber: phoneNumber),
    );
  }
}

class _OtpVerificationContent extends StatefulWidget {
  const _OtpVerificationContent({required this.phoneNumber});

  final String phoneNumber;

  @override
  State<_OtpVerificationContent> createState() =>
      _OtpVerificationContentState();
}

class _OtpVerificationContentState extends State<_OtpVerificationContent>
    with TickerProviderStateMixin {
  late TextEditingController _pinController;
  late FocusNode _pinFocusNode;

  late AnimationController _animController;
  late Animation<double> _headerFadeAnim;
  late Animation<Offset> _headerSlideAnim;
  late Animation<double> _pinFadeAnim;
  late Animation<Offset> _pinSlideAnim;
  late Animation<double> _buttonScaleAnim;

  // Shake animation on error
  late AnimationController _shakeController;
  late Animation<double> _shakeAnim;

  @override
  void initState() {
    super.initState();
    _pinController = TextEditingController();
    _pinFocusNode = FocusNode();

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

    _pinFadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
      ),
    );

    _pinSlideAnim =
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
      TweenSequenceItem(tween: Tween(begin: -8.0, end: -8.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -8.0, end: 0.0), weight: 1),
    ]).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _pinController.dispose();
    _pinFocusNode.dispose();
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
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textPrimary,
          ),
          onPressed: () => AppRouteHandler.route.pop(),
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<OtpVerificationBloc, OtpVerificationState>(
            listener: (context, state) {
              if (state is OtpVerificationFailure) {
                _triggerShake();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage ?? 'Verification failed'),
                    backgroundColor: AppColors.error,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppBorderRadius.borderRadius12,
                    ),
                  ),
                );
              } else if (state is OtpResentSuccess) {
                _pinController.clear();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('A new OTP has been sent successfully!'),
                    backgroundColor: AppColors.success,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppBorderRadius.borderRadius12,
                    ),
                  ),
                );
              } else if (state is OtpVerificationSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Phone verified successfully! Welcome.'),
                    backgroundColor: AppColors.success,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppBorderRadius.borderRadius12,
                    ),
                  ),
                );
                // Navigate to Home screen
                AppRouteHandler.route.replace(const HomeRoute());
              }
            },
            builder: (context, state) {
              final isVerifying = state is OtpVerifying;
              final isEnabled = state.otp.length == 6;

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSize.size20,
                  vertical: AppSize.size16,
                ),
                child: Column(
                  children: [
                    AppGaps.gap16,

                    // Header Section with Slide & Fade Animation
                    FadeTransition(
                      opacity: _headerFadeAnim,
                      child: SlideTransition(
                        position: _headerSlideAnim,
                        child: OtpHeaderWidget(
                          phoneNumber: widget.phoneNumber,
                          onChangeNumberTap: () {
                            AppRouteHandler.route.pop();
                          },
                        ),
                      ),
                    ),

                    AppGaps.gap24,

                    // PIN Input Section with Shake Animation
                    AnimatedBuilder(
                      animation: _shakeAnim,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(_shakeAnim.value, 0),
                          child: child,
                        );
                      },
                      child: FadeTransition(
                        opacity: _pinFadeAnim,
                        child: SlideTransition(
                          position: _pinSlideAnim,
                          child: OtpPinInputWidget(
                            controller: _pinController,
                            focusNode: _pinFocusNode,
                            errorMessage: state.errorMessage,
                            enabled: !isVerifying,
                            onChanged: (val) {
                              context
                                  .read<OtpVerificationBloc>()
                                  .add(OtpInputChanged(val));
                            },
                            onCompleted: (pin) {
                              context.read<OtpVerificationBloc>().add(
                                    OtpSubmitted(
                                      phoneNumber: widget.phoneNumber,
                                      otp: pin,
                                    ),
                                  );
                            },
                          ),
                        ),
                      ),
                    ),

                    AppGaps.gap20,

                    // Resend Timer Widget
                    OtpTimerResendWidget(
                      timerSeconds: state.timerSeconds,
                      canResend: state.canResend && !isVerifying,
                      onResendTap: () {
                        context.read<OtpVerificationBloc>().add(
                              OtpResendRequested(
                                phoneNumber: widget.phoneNumber,
                              ),
                            );
                      },
                    ),

                    AppGaps.gap20,

                    // Submit Button Section
                    ScaleTransition(
                      scale: _buttonScaleAnim,
                      child: VerifyOtpButtonWidget(
                        isEnabled: isEnabled,
                        isLoading: isVerifying,
                        onPressed: () {
                          context.read<OtpVerificationBloc>().add(
                                OtpSubmitted(
                                  phoneNumber: widget.phoneNumber,
                                  otp: state.otp,
                                ),
                              );
                        },
                      ),
                    ),

                    AppGaps.gap16,
                  ],
                ),
              );
            },
          ),
        ),
      );
  }
}
