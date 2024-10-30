import 'package:da_movie_quizz/src/domain/repositories/quizzes.dart';

abstract class ILoadQuizzesUseCase {
  Future<void> execute();
}

class LoadQuizzesUseCase implements ILoadQuizzesUseCase {
  final IQuizzesRepository repository;

  LoadQuizzesUseCase(this.repository);

  @override
  Future<void> execute() {
    return repository.loadQuizzes();
  }
  
}