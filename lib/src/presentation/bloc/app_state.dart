part of 'app_cubit.dart';

enum AppStatus { initial, ready, playing, stopped }

final class AppState extends Equatable {
  const AppState({
    required this.status,
    required this.remainingTime,
    this.quizzes = const [],
    this.score = 0,
    this.scoreDesc = ''
  });

  final AppStatus status;
  final int remainingTime;
  final Quizzes quizzes;
  final int score;
  final String scoreDesc;

  @override
  List<Object> get props => [status, remainingTime, quizzes, score, scoreDesc];

  AppState copyWith({
    AppStatus? status,
    int? remainingTime,
    Quizzes? quizzes,
    int? score,
    String? scoreDesc,
  }) {
    return AppState(
      status: status ?? this.status,
      remainingTime: remainingTime ?? this.remainingTime,
      quizzes: quizzes ?? this.quizzes,
      score: score ?? this.score,
      scoreDesc: scoreDesc ?? this.scoreDesc,
    );
  }
}
