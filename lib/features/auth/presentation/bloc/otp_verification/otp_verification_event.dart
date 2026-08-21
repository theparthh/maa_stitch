part of 'otp_verification_bloc.dart';

sealed class OtpVerificationEvent extends Equatable {
  const OtpVerificationEvent();

  @override
  List<Object?> get props => [];
}

final class OtpInputChanged extends OtpVerificationEvent {
  const OtpInputChanged(this.otp);
  final String otp;

  @override
  List<Object?> get props => [otp];
}

final class OtpSubmitted extends OtpVerificationEvent {
  const OtpSubmitted({
    required this.phoneNumber,
    required this.otp,
  });

  final String phoneNumber;
  final String otp;

  @override
  List<Object?> get props => [phoneNumber, otp];
}

final class OtpResendRequested extends OtpVerificationEvent {
  const OtpResendRequested({required this.phoneNumber});
  final String phoneNumber;

  @override
  List<Object?> get props => [phoneNumber];
}

final class OtpTimerTicked extends OtpVerificationEvent {
  const OtpTimerTicked(this.secondsRemaining);
  final int secondsRemaining;

  @override
  List<Object?> get props => [secondsRemaining];
}
