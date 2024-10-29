import 'package:da_movie_quizz/src/domain/models/quiz.dart';
import 'package:da_movie_quizz/src/data/sources/local.dart';
import 'package:da_movie_quizz/src/data/sources/remote.dart';
import 'package:da_movie_quizz/src/domain/repositories/quizzes.dart';
import 'package:dartz/dartz.dart';

class QuizzesRepository extends IQuizzesRepository {
  QuizzesRepository({
    required this.localDataSource,
    required this.remoteDataSource
  });

  final IRemoteAppDataSource remoteDataSource;
  final ILocalAppDataSource localDataSource;
  
  @override
  Future<Either<Failure, Quizzes>> getQuizzes() async{
    try {
      final quizzes = await localDataSource.getQuizzes();
      if(quizzes.isNotEmpty) {
        return Right(quizzes);
      } else {
        final loadQuizzes = await remoteDataSource.loadQuizzes();
        await localDataSource.saveQuizzes(loadQuizzes);
        return Right(quizzes);
      }
    } catch (e) {
      return const Left(Failure());
    }
  }

  
}