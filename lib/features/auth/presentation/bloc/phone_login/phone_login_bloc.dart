import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maa_design_stitch_viewer/app/core/helpers/connectivity_helper.dart';
import 'package:maa_design_stitch_viewer/features/auth/domain/domain.dart';

part 'phone_login_event.dart';
part 'phone_login_state.dart';

class PhoneLoginBloc extends Bloc<PhoneLoginEvent, PhoneLoginState> {
  PhoneLoginBloc({required this.repository})
      : super(
          const PhoneLoginInitial(
            phoneNumber: '',
            isValid: false,
          ),
        ) {
    on<PhoneLoginNumberChanged>(_onNumberChanged);
    on<PhoneLoginSubmitted>(_onSubmitted);
  }

  final AuthRepository repository;

  void _onNumberChanged(
    PhoneLoginNumberChanged event,
    Emitter<PhoneLoginState> emit,
  ) {
    final sanitized = event.phoneNumber.replaceAll(RegExp(r'\D'), '');
    final isValid = sanitized.length == 10;

    emit(
      PhoneLoginInitial(
        phoneNumber: sanitized,
        isValid: isValid,
        errorMessage: null,
      ),
    );
  }

  Future<void> _onSubmitted(
    PhoneLoginSubmitted event,
    Emitter<PhoneLoginState> emit,
  ) async {
    if (state is PhoneLoginSubmitting) return;

    final sanitized = state.phoneNumber.replaceAll(RegExp(r'\D'), '');
    if (sanitized.isEmpty) {
      emit(
        PhoneLoginFailure(
          phoneNumber: state.phoneNumber,
          errorMessage: 'Please enter your mobile number',
        ),
      );
      return;
    }

    if (sanitized.length != 10) {
      emit(
        PhoneLoginFailure(
          phoneNumber: state.phoneNumber,
          errorMessage: 'Please enter a valid 10-digit mobile number',
        ),
      );
      return;
    }

    final isOnline = await ConnectivityHelper.checkIsOnline();
    if (!isOnline) {
      emit(
        PhoneLoginFailure(
          phoneNumber: state.phoneNumber,
          errorMessage:
              'No internet connection. Please check your network and try again.',
        ),
      );
      return;
    }

    emit(
      PhoneLoginSubmitting(
        phoneNumber: state.phoneNumber,
      ),
    );

    final result = await repository.sendOtp(
      phoneNumber: state.phoneNumber,
    );

    result.fold(
      (failure) => emit(
        PhoneLoginFailure(
          phoneNumber: state.phoneNumber,
          errorMessage: failure.message,
        ),
      ),
      (msg) => emit(
        PhoneLoginSuccess(
          phoneNumber: state.phoneNumber,
          message: msg,
        ),
      ),
    );
  }
}
