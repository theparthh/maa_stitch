import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maa_design_stitch_viewer/features/auth/domain/domain.dart';

part 'otp_verification_event.dart';
part 'otp_verification_state.dart';

class OtpVerificationBloc
    extends Bloc<OtpVerificationEvent, OtpVerificationState> {
  OtpVerificationBloc({required this.repository})
      : super(
          const OtpVerificationInitial(
            otp: '',
            timerSeconds: 30,
            canResend: false,
          ),
        ) {
    on<OtpInputChanged>(_onInputChanged);
    on<OtpSubmitted>(_onSubmitted);
    on<OtpResendRequested>(_onResendRequested);
    on<OtpTimerTicked>(_onTimerTicked);

    _startTimer();
  }

  final AuthRepository repository;
  Timer? _timer;
  static const int _initialTimerSeconds = 30;

  void _startTimer() {
    _timer?.cancel();
    int current = _initialTimerSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      current--;
      add(OtpTimerTicked(current));
      if (current <= 0) {
        timer.cancel();
      }
    });
  }

  void _onTimerTicked(
    OtpTimerTicked event,
    Emitter<OtpVerificationState> emit,
  ) {
    if (state is OtpVerifying || state is OtpVerificationSuccess) return;

    final seconds = event.secondsRemaining;
    final canResend = seconds <= 0;

    emit(
      OtpVerificationInitial(
        otp: state.otp,
        timerSeconds: seconds > 0 ? seconds : 0,
        canResend: canResend,
        errorMessage: state.errorMessage,
      ),
    );
  }

  void _onInputChanged(
    OtpInputChanged event,
    Emitter<OtpVerificationState> emit,
  ) {
    final sanitized = event.otp.replaceAll(RegExp(r'\D'), '');
    emit(
      OtpVerificationInitial(
        otp: sanitized,
        timerSeconds: state.timerSeconds,
        canResend: state.canResend,
        errorMessage: null,
      ),
    );
  }

  Future<void> _onSubmitted(
    OtpSubmitted event,
    Emitter<OtpVerificationState> emit,
  ) async {
    if (event.otp.length != 4) {
      emit(
        OtpVerificationFailure(
          otp: event.otp,
          errorMessage: 'Please enter a complete 4-digit OTP code',
          timerSeconds: state.timerSeconds,
          canResend: state.canResend,
        ),
      );
      return;
    }

    emit(
      OtpVerifying(
        otp: event.otp,
        timerSeconds: state.timerSeconds,
      ),
    );

    try {
      final result = await repository.verifyOtp(
        phoneNumber: event.phoneNumber,
        otp: event.otp,
      );

      if (result.success) {
        _timer?.cancel();
        emit(
          OtpVerificationSuccess(
            otp: event.otp,
            authResult: result,
          ),
        );
      } else {
        emit(
          OtpVerificationFailure(
            otp: event.otp,
            errorMessage: result.errorMessage ?? 'Invalid OTP code',
            timerSeconds: state.timerSeconds,
            canResend: state.timerSeconds <= 0,
          ),
        );
      }
    } catch (e) {
      emit(
        OtpVerificationFailure(
          otp: event.otp,
          errorMessage: e.toString().replaceAll('Exception: ', ''),
          timerSeconds: state.timerSeconds,
          canResend: state.timerSeconds <= 0,
        ),
      );
    }
  }

  Future<void> _onResendRequested(
    OtpResendRequested event,
    Emitter<OtpVerificationState> emit,
  ) async {
    if (!state.canResend) return;

    emit(
      OtpVerificationInitial(
        otp: '',
        timerSeconds: _initialTimerSeconds,
        canResend: false,
      ),
    );
    _startTimer();

    try {
      await repository.sendOtp(
        countryCode: '',
        phoneNumber: event.phoneNumber,
      );
      emit(
        const OtpResentSuccess(
          otp: '',
          timerSeconds: _initialTimerSeconds,
        ),
      );
    } catch (e) {
      emit(
        OtpVerificationFailure(
          otp: '',
          errorMessage: 'Failed to resend OTP. Please try again.',
          timerSeconds: state.timerSeconds,
          canResend: true,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
