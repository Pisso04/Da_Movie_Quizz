import 'dart:convert';
import 'dart:math';

import '../../domain/models/quiz.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;

abstract class IRemoteAppDataSource {
  Future<Quizzes> loadQuizzes();
}

class RemoteAppDataSource implements IRemoteAppDataSource {
  final String apiUrl = dotenv.dotenv.get('API_URL');
  final String apiKey = dotenv.dotenv.get('API_KEY');
  final String toGenerate = dotenv.dotenv.get('NUMBER_OF_QUIZZES_TO_GENERATE');
  final Random _random = Random();

  @override
  Future<Quizzes> loadQuizzes() async {
    try {
      List<Quiz> linkedQuizzes = [];
      List<Quiz> unlinkedQuizzes= [];

      // Get populars movies
      final moviesResponse = await http.get(Uri.parse(
        '$apiUrl/movie/popular?api_key=$apiKey',
      ));
      final movies = jsonDecode(moviesResponse.body)['results'];

      // Get populars actors
      final actorsResponse = await http.get(Uri.parse(
        '$apiUrl/person/popular?api_key=$apiKey',
      ));
      final actors = jsonDecode(actorsResponse.body)['results'];

      // Generate quizzes with isLinked = true
      while (linkedQuizzes.length < (int.parse(toGenerate) / 2)) {
        final movie = movies[_random.nextInt(movies.length)];
        final movieId = movie['id'];

        final creditsResponse = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/movie/$movieId/credits?api_key=$apiKey',
        ));
        final cast = jsonDecode(creditsResponse.body)['cast'];

        if (cast.isNotEmpty) {
          final actor = cast[_random.nextInt(cast.length)];

          final movieImageUrl =
              'https://image.tmdb.org/t/p/w500${movie['poster_path']}';
          final actorImageUrl =
              'https://image.tmdb.org/t/p/w500${actor['profile_path']}';

          final isMovieImageValid = await _isImageValid(movieImageUrl);
          final isActorImageValid = await _isImageValid(actorImageUrl);

          if (isMovieImageValid && isActorImageValid) {
            linkedQuizzes.add(Quiz(
              movieName: movie['title'],
              movieImage: movieImageUrl,
              actorName: actor['name'],
              actorImage: actorImageUrl,
              isLinked: true,
            ));
          }
        }
      }

      // Generate quizzes with isLinked = false
      while (unlinkedQuizzes.length < (int.parse(toGenerate) / 2)) {
        final movie = movies[_random.nextInt(movies.length)];
        final actor = actors[_random.nextInt(actors.length)];

        final creditsResponse = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/movie/${movie['id']}/credits?api_key=$apiKey',
        ));
        final cast = jsonDecode(creditsResponse.body)['cast'];
        final actorInMovie = cast.any((member) => member['id'] == actor['id']);

        if (!actorInMovie) {
          final movieImageUrl =
              'https://image.tmdb.org/t/p/w500${movie['poster_path']}';
          final actorImageUrl =
              'https://image.tmdb.org/t/p/w500${actor['profile_path']}';

          final isMovieImageValid = await _isImageValid(movieImageUrl);
          final isActorImageValid = await _isImageValid(actorImageUrl);

          if (isMovieImageValid && isActorImageValid) {
            unlinkedQuizzes.add(Quiz(
              movieName: movie['title'],
              movieImage: movieImageUrl,
              actorName: actor['name'],
              actorImage: actorImageUrl,
              isLinked: false,
            ));
          }
        }
      }
      
      return [...linkedQuizzes, ...unlinkedQuizzes];
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> _isImageValid(String url) async {
    try {
      final response = await http.head(Uri.parse(url));
      return response.statusCode == 200;
    } catch (e) {
      return false; // En cas d'erreur, retourner false
    }
  }
}
