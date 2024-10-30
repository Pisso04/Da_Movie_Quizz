import 'package:da_movie_quizz/src/domain/models/quiz.dart';
import 'package:da_movie_quizz/src/data/sources/local.dart';
import 'package:da_movie_quizz/src/data/sources/remote.dart';
import 'package:da_movie_quizz/src/domain/repositories/quizzes.dart';

class QuizzesRepository extends IQuizzesRepository {
  QuizzesRepository(
      {required this.localDataSource, required this.remoteDataSource});

  final IRemoteAppDataSource remoteDataSource;
  final ILocalAppDataSource localDataSource;

  @override
  Stream<Quizzes> get quizzesStream => localDataSource.quizzesStream;

  @override
  Future<void> loadQuizzes() async {
    final Quizzes quizzes = localDataSource.getQuizzes();
    if(quizzes.isNotEmpty) {
      localDataSource.saveQuizzes(quizzes);
    } else {
      remoteDataSource.loadQuizzes().then(((response) async {
        await localDataSource.saveQuizzes(response);
      }));
    }
  }
}
