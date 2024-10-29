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
  final Random _random = Random();

  @override
  Future<Quizzes> loadQuizzes() async {
    try {
      List<Quiz> quizzes = [];

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

      // Generate 20 quizzes with isLinked = true
      for (int i = 0; i < 20; i++) {
        final movie = movies[_random.nextInt(movies.length)];
        final movieId = movie['id'];

        // Get movies's actors
        final creditsResponse = await http.get(Uri.parse(
          '$apiUrl/movie/$movieId/credits?api_key=$apiKey',
        ));
        final cast = jsonDecode(creditsResponse.body)['cast'];

        if (cast.isNotEmpty) {
          final actor = cast[_random.nextInt(cast.length)];

          quizzes.add(Quiz(
            movieName: movie['title'],
            movieImage: 'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
            actorName: actor['name'],
            actorImage: 'https://image.tmdb.org/t/p/w500${actor['profile_path']}',
            isLinked: true,
          ));
        }
      }

      // Generate 20 quizzes with isLinked = false
      for (int i = 0; i < 20; i++) {
        final movie = movies[_random.nextInt(movies.length)];
        final actor = actors[_random.nextInt(actors.length)];

        // Check if the actor is not in the movie
        final creditsResponse = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/movie/${movie['id']}/credits?api_key=$apiKey',
        ));
        final cast = jsonDecode(creditsResponse.body)['cast'];
        final actorInMovie = cast.any((member) => member['id'] == actor['id']);

        // Add quizz only if actor is not in the movie
        if (!actorInMovie) {
          quizzes.add(Quiz(
            movieName: movie['title'],
            movieImage: 'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
            actorName: actor['name'],
            actorImage: 'https://image.tmdb.org/t/p/w500${actor['profile_path']}',
            isLinked: false,
          ));
        }
      }
      return quizzes;
    } catch (e) {
      throw Exception(e);
    }
  }
}
