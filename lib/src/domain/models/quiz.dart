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

  // Convert a Quiz object to a Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      'movieName': movieName,
      'movieImage': movieImage,
      'actorName': actorName,
      'actorImage': actorImage,
      'isLinked': isLinked,
    };
  }

  // Create a Quiz object from a Map<String, dynamic>
  factory Quiz.fromMap(Map<String, dynamic> map) {
    return Quiz(
      movieName: map['movieName'],
      movieImage: map['movieImage'],
      actorName: map['actorName'],
      actorImage: map['actorImage'],
      isLinked: map['isLinked'],
    );
  }
}

typedef Quizzes = List<Quiz>;
