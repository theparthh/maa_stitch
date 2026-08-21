part of 'phone_login_bloc.dart';

sealed class PhoneLoginState extends Equatable {
  const PhoneLoginState({
    required this.selectedCountry,
    required this.phoneNumber,
    required this.isValid,
    this.errorMessage,
  });

  final CountryCodeModel selectedCountry;
  final String phoneNumber;
  final bool isValid;
  final String? errorMessage;

  @override
  List<Object?> get props => [
        selectedCountry,
        phoneNumber,
        isValid,
        errorMessage,
      ];
}

final class PhoneLoginInitial extends PhoneLoginState {
  const PhoneLoginInitial({
    required super.selectedCountry,
    required super.phoneNumber,
    required super.isValid,
    super.errorMessage,
  });
}

final class PhoneLoginSubmitting extends PhoneLoginState {
  const PhoneLoginSubmitting({
    required super.selectedCountry,
    required super.phoneNumber,
  }) : super(isValid: true);
}

final class PhoneLoginSuccess extends PhoneLoginState {
  const PhoneLoginSuccess({
    required super.selectedCountry,
    required super.phoneNumber,
  }) : super(isValid: true);
}

final class PhoneLoginFailure extends PhoneLoginState {
  const PhoneLoginFailure({
    required super.selectedCountry,
    required super.phoneNumber,
    required String super.errorMessage,
  }) : super(isValid: false);
}
