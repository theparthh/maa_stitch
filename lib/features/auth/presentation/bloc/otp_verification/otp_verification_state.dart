part of 'otp_verification_bloc.dart';

sealed class OtpVerificationState extends Equatable {
  const OtpVerificationState({
    required this.otp,
    required this.timerSeconds,
    required this.canResend,
    this.errorMessage,
  });

  final String otp;
  final int timerSeconds;
  final bool canResend;
  final String? errorMessage;

  @override
  List<Object?> get props => [
        otp,
        timerSeconds,
        canResend,
        errorMessage,
      ];
}

final class OtpVerificationInitial extends OtpVerificationState {
  const OtpVerificationInitial({
    required super.otp,
    required super.timerSeconds,
    required super.canResend,
    super.errorMessage,
  });
}

final class OtpVerifying extends OtpVerificationState {
  const OtpVerifying({
    required super.otp,
    required super.timerSeconds,
  }) : super(canResend: false);
}

final class OtpVerificationSuccess extends OtpVerificationState {
  const OtpVerificationSuccess({
    required super.otp,
    required this.authResult,
  }) : super(timerSeconds: 0, canResend: false);

  final AuthResultModel authResult;

  @override
  List<Object?> get props => [...super.props, authResult];
}

final class OtpVerificationFailure extends OtpVerificationState {
  const OtpVerificationFailure({
    required super.otp,
    required String super.errorMessage,
    required super.timerSeconds,
    required super.canResend,
  });
}

final class OtpResentSuccess extends OtpVerificationState {
  const OtpResentSuccess({
    required super.otp,
    required super.timerSeconds,
  }) : super(canResend: false);
}
