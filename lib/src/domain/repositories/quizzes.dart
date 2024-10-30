import 'package:da_movie_quizz/src/domain/models/quiz.dart';

abstract class IQuizzesRepository {
  Future<void> loadQuizzes();

  Stream<Quizzes> get quizzesStream;
}