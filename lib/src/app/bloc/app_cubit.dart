import 'dart:async';
import 'package:da_movie_quizz/src/data/data.dart';
import 'package:da_movie_quizz/src/data/sources/local.dart';
import 'package:da_movie_quizz/src/data/sources/remote.dart';
import 'package:da_movie_quizz/src/domain/models/quiz.dart';
import 'package:da_movie_quizz/src/domain/usescases/get_quizzes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit({GetQuizzesUseCase? getQuizzesUseCase})
      : _getQuizzesUseCase = getQuizzesUseCase ?? GetQuizzesUseCase(QuizzesRepository(
        localDataSource: LocalAppDataSource(),
        remoteDataSource: RemoteAppDataSource()
      )),
      super(const AppState(status: AppStatus.initial, remainingTime: 60));

  final IGetQuizzesUseCase _getQuizzesUseCase;
  Timer? _timer;

  Future<void> prepareGame() async {
    await _getQuizzesUseCase.execute().then((result) {
      result.fold((err) {
        emit(state.copyWith(status: AppStatus.failed));
      }, (quizzes) {
        emit(state.copyWith(status: AppStatus.ready, quizzes: quizzes));
      });
    });
  }

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
