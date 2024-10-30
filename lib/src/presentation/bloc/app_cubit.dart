import 'dart:async';
import 'package:da_movie_quizz/src/data/data.dart';
import 'package:da_movie_quizz/src/data/sources/local.dart';
import 'package:da_movie_quizz/src/data/sources/remote.dart';
import 'package:da_movie_quizz/src/domain/models/quiz.dart';
import 'package:da_movie_quizz/src/domain/usescases/get_quizzes.dart';
import 'package:da_movie_quizz/src/domain/usescases/load_quizzes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit({QuizzesRepository? repository})
      : _repository = repository ??
            QuizzesRepository(
                localDataSource: LocalAppDataSource(),
                remoteDataSource: RemoteAppDataSource()),
        super(const AppState(status: AppStatus.initial, remainingTime: 60));

  final QuizzesRepository _repository;
  Timer? _timer;
  late final StreamSubscription<Quizzes> _quizzesSubscription;
  late final SharedPreferences sharedPrefs;

  void init() async {
    _loadQuizzes();
    _listenToQuizzes();
    sharedPrefs = await SharedPreferences.getInstance();
  }

  void _loadQuizzes() {
    final ILoadQuizzesUseCase loadQuizzesUseCase =
        LoadQuizzesUseCase(_repository);
    loadQuizzesUseCase.execute();
  }

  void _listenToQuizzes() {
    final IGetQuizzesUseCase getQuizzesUseCase = GetQuizzesUseCase(_repository);
    _quizzesSubscription = getQuizzesUseCase.execute().listen((quizzes) {
      quizzes.shuffle();
      emit(state.copyWith(quizzes: quizzes, status: AppStatus.ready));
    });
  }

  void launchGame() {
    emit(state.copyWith(status: AppStatus.playing));
    startCountdown();
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
        stopGame();
        resetCountdown();
      }
    });
  }

  void resetCountdown() {
    _timer?.cancel();
    emit(state.copyWith(remainingTime: 60));
  }

  void incrementScore() {
    emit(state.copyWith(score: state.score + 1));
  }

  void submitQuiz(bool response) {
    if (response) {
      incrementScore();
    } else {
      stopGame();
      resetCountdown();
    }
  }

  void verifyAndSaveBestScore() async{
    final String? bestScoreString = sharedPrefs.getString('bestScore');
    if (bestScoreString != null && int.parse(bestScoreString) > state.score) {
      emit(state.copyWith(scoreDesc: 'Score: ${state.score}'));
    } else {
      sharedPrefs.setString('bestScore', state.score.toString());
      emit(state.copyWith(scoreDesc: 'Meilleur score: ${state.score}'));
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _quizzesSubscription.cancel();
    return super.close();
  }
}
