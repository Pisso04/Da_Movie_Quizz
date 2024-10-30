import 'package:da_movie_quizz/src/domain/models/quiz.dart';
import 'package:da_movie_quizz/src/domain/repositories/quizzes.dart';

abstract class IGetQuizzesUseCase {
  Stream<Quizzes> execute();
}

class GetQuizzesUseCase implements IGetQuizzesUseCase {
  final IQuizzesRepository repository;

  GetQuizzesUseCase(this.repository);

  @override
  Stream<Quizzes> execute() => repository.quizzesStream;
}