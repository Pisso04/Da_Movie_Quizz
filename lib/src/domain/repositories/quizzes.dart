import 'package:da_movie_quizz/src/domain/models/quiz.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  const Failure([this.message]);
  final String? message;

  @override
  List<Object?> get props => <dynamic>[message];
}

abstract class IQuizzesRepository {
  Future<Either<Failure, Quizzes>> getQuizzes();
}