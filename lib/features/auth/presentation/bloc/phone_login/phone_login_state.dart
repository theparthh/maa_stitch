part of 'phone_login_bloc.dart';

sealed class PhoneLoginState extends Equatable {
  const PhoneLoginState({
    required this.phoneNumber,
    required this.isValid,
    this.errorMessage,
  });

  final String phoneNumber;
  final bool isValid;
  final String? errorMessage;

  @override
  List<Object?> get props => [
        phoneNumber,
        isValid,
        errorMessage,
      ];
}

final class PhoneLoginInitial extends PhoneLoginState {
  const PhoneLoginInitial({
    required super.phoneNumber,
    required super.isValid,
    super.errorMessage,
  });
}

final class PhoneLoginSubmitting extends PhoneLoginState {
  const PhoneLoginSubmitting({
    required super.phoneNumber,
  }) : super(isValid: true);
}

final class PhoneLoginSuccess extends PhoneLoginState {
  const PhoneLoginSuccess({
    required super.phoneNumber,
  }) : super(isValid: true);
}

final class PhoneLoginFailure extends PhoneLoginState {
  const PhoneLoginFailure({
    required super.phoneNumber,
    required String super.errorMessage,
  }) : super(isValid: false);
}
