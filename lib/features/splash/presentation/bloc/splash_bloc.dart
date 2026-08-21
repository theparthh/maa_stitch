import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maa_design_stitch_viewer/features/splash/splash.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc({required this.repository})
      : super(const SplashInitial()) {
    on<InitSplashEvent>(_onInit);
  }

  final SplashRepository repository;

  Future<void> _onInit(
    InitSplashEvent event,
    Emitter<SplashState> emit,
  ) async {
    emit(const SplashLoading());
    try {
      final initialFilePath = await repository.checkInitialFileIntent();
      emit(SplashCompleted(initialFilePath: initialFilePath));
    } catch (_) {
      emit(const SplashCompleted(initialFilePath: null));
    }
  }
}
