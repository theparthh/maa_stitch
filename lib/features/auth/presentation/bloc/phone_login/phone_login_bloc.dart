import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maa_design_stitch_viewer/features/auth/domain/domain.dart';

part 'phone_login_event.dart';
part 'phone_login_state.dart';

class PhoneLoginBloc extends Bloc<PhoneLoginEvent, PhoneLoginState> {
  PhoneLoginBloc({required this.repository})
      : super(
          PhoneLoginInitial(
            selectedCountry: repository.getSupportedCountryCodes().first,
            phoneNumber: '',
            isValid: false,
          ),
        ) {
    on<PhoneLoginNumberChanged>(_onNumberChanged);
    on<PhoneLoginCountryCodeChanged>(_onCountryCodeChanged);
    on<PhoneLoginSubmitted>(_onSubmitted);
  }

  final AuthRepository repository;

  void _onNumberChanged(
    PhoneLoginNumberChanged event,
    Emitter<PhoneLoginState> emit,
  ) {
    final sanitized = event.phoneNumber.replaceAll(RegExp(r'\D'), '');
    final isValid = sanitized.length == state.selectedCountry.phoneLength;
    String? errorMessage;
    if (sanitized.isNotEmpty && !isValid) {
      errorMessage =
          'Please enter a valid ${state.selectedCountry.phoneLength}-digit phone number';
    }

    emit(
      PhoneLoginInitial(
        selectedCountry: state.selectedCountry,
        phoneNumber: sanitized,
        isValid: isValid,
        errorMessage: errorMessage,
      ),
    );
  }

  void _onCountryCodeChanged(
    PhoneLoginCountryCodeChanged event,
    Emitter<PhoneLoginState> emit,
  ) {
    final isValid =
        state.phoneNumber.length == event.countryCode.phoneLength;
    String? errorMessage;
    if (state.phoneNumber.isNotEmpty && !isValid) {
      errorMessage =
          'Please enter a valid ${event.countryCode.phoneLength}-digit phone number';
    }

    emit(
      PhoneLoginInitial(
        selectedCountry: event.countryCode,
        phoneNumber: state.phoneNumber,
        isValid: isValid,
        errorMessage: errorMessage,
      ),
    );
  }

  Future<void> _onSubmitted(
    PhoneLoginSubmitted event,
    Emitter<PhoneLoginState> emit,
  ) async {
    if (!state.isValid) {
      emit(
        PhoneLoginFailure(
          selectedCountry: state.selectedCountry,
          phoneNumber: state.phoneNumber,
          errorMessage:
              'Please enter a valid ${state.selectedCountry.phoneLength}-digit phone number',
        ),
      );
      return;
    }

    emit(
      PhoneLoginSubmitting(
        selectedCountry: state.selectedCountry,
        phoneNumber: state.phoneNumber,
      ),
    );

    try {
      final success = await repository.sendOtp(
        countryCode: state.selectedCountry.code,
        phoneNumber: state.phoneNumber,
      );

      if (success) {
        emit(
          PhoneLoginSuccess(
            selectedCountry: state.selectedCountry,
            phoneNumber: state.phoneNumber,
          ),
        );
      } else {
        emit(
          PhoneLoginFailure(
            selectedCountry: state.selectedCountry,
            phoneNumber: state.phoneNumber,
            errorMessage: 'Failed to send OTP. Please try again.',
          ),
        );
      }
    } catch (e) {
      emit(
        PhoneLoginFailure(
          selectedCountry: state.selectedCountry,
          phoneNumber: state.phoneNumber,
          errorMessage: e.toString().replaceAll('Exception: ', ''),
        ),
      );
    }
  }
}
