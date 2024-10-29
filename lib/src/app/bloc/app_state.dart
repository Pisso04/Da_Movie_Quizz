part of 'app_cubit.dart';

enum AppStatus { initial, ready, playing, stopped, failed }

final class AppState extends Equatable {
  const AppState({
    required this.status,
    required this.remainingTime,
    this.quizzes = const [],
    this.score = 0,
  });

  final AppStatus status;
  final int remainingTime;
  final Quizzes quizzes;
  final int score;

  @override
  List<Object> get props => [status, remainingTime, quizzes, score];

  AppState copyWith({
    AppStatus? status,
    int? remainingTime,
    Quizzes? quizzes,
    int? score,
  }) {
    return AppState(
      status: status ?? this.status,
      remainingTime: remainingTime ?? this.remainingTime,
      quizzes: quizzes ?? this.quizzes,
      score: score ?? this.score,
    );
  }
}
