import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit()
      : super(const AppState(status: AppStatus.initial, remainingTime: 60));
  Timer? _timer;

  void launchGame() {
    emit(state.copyWith(status: AppStatus.playing));
  }

  void stopGame() {
    emit(state.copyWith(status: AppStatus.stopped));
  }

  void startCountdown() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingTime > 0) {
        emit(state.copyWith(remainingTime: state.remainingTime - 1));
      } else {
        timer.cancel();
        stopGame();
      }
    });
  }

  void resetCountdown() {
    _timer?.cancel();
    emit(state.copyWith(remainingTime: 60));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
