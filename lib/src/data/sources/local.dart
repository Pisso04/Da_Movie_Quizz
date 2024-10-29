import 'dart:convert';

import 'package:da_movie_quizz/src/constants/boxes.dart';
import 'package:da_movie_quizz/src/domain/models/quiz.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class ILocalAppDataSource {
  Future<void> saveQuizzes(Quizzes quizzes);
  Future<Quizzes> getQuizzes();
}

class LocalAppDataSource implements ILocalAppDataSource {
  LocalAppDataSource();

  final Box<String> quizBox = Hive.box(BoxNames.quizzes);


  @override
  Future<Quizzes> getQuizzes() async {
    final quizzesJson = quizBox.get('quizzes', defaultValue: '[]');
    final quizzesAsMaps = jsonDecode(quizzesJson!) as List;
    return quizzesAsMaps
        .map((map) => Quiz.fromMap(Map<String, dynamic>.from(map)))
        .toList();
  }

  @override
  Future<void> saveQuizzes(Quizzes quizzes) async{
    try {
      final quizzesAsMaps = quizzes.map((quiz) => quiz.toMap()).toList();
      final quizzesJson = jsonEncode(quizzesAsMaps);
      await quizBox.put('quizzes', quizzesJson);
    } catch (e) {
      throw Exception(e);
    }
  }

}