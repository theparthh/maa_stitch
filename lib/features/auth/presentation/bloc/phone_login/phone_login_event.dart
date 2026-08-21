part of 'phone_login_bloc.dart';

sealed class PhoneLoginEvent extends Equatable {
  const PhoneLoginEvent();

  @override
  List<Object?> get props => [];
}

final class PhoneLoginNumberChanged extends PhoneLoginEvent {
  const PhoneLoginNumberChanged(this.phoneNumber);
  final String phoneNumber;

  @override
  List<Object?> get props => [phoneNumber];
}

final class PhoneLoginSubmitted extends PhoneLoginEvent {
  const PhoneLoginSubmitted();
}
