import 'package:da_movie_quizz/src/domain/models/quiz.dart';
import 'package:da_movie_quizz/src/domain/repositories/quizzes.dart';
import 'package:dartz/dartz.dart';

abstract class IGetQuizzesUseCase {
  Future<Either<Failure, Quizzes>> execute();
}

class GetQuizzesUseCase implements IGetQuizzesUseCase {
  final IQuizzesRepository repository;

  GetQuizzesUseCase(this.repository);

  @override
  Future<Either<Failure, Quizzes>> execute() async{
    return await repository.getQuizzes();
  }
  
}