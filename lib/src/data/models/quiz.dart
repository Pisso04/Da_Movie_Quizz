import 'package:equatable/equatable.dart';

class Quiz extends Equatable {
  final String movieName;
  final String movieImage;
  final String actorName;
  final String actorImage;
  final bool isLinked;

  const Quiz({
    required this.movieName,
    required this.movieImage,
    required this.actorName,
    required this.actorImage,
    required this.isLinked,
  });
  
  @override
  List<Object?> get props => [movieName, movieImage, actorName, actorImage, isLinked];
}

typedef Quizzes = List<Quiz>;
