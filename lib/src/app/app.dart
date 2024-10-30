import 'package:da_movie_quizz/src/app/bloc/app_cubit.dart';
import 'package:da_movie_quizz/src/app/widgets/quizz_part.dart';
import 'package:da_movie_quizz/src/domain/models/quiz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velocity_x/velocity_x.dart';

class DaMovieApp extends StatelessWidget {
  const DaMovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Da Movie Quiz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(body: const AppContent().px16().py8()).safeArea(),
    );
  }
}

class AppContent extends StatelessWidget {
  const AppContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppCubit>(
      create: (context) => AppCubit()..init(),
      child: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          switch (state.status) {
            case AppStatus.initial:
              return const CircularProgressIndicator(
                color: Colors.blueGrey,
              ).centered();
            case AppStatus.ready:
              return const ReadyScreen();
            case AppStatus.playing:
              return PlayingScreen(quiz: state.quizzes[state.score]);
            case AppStatus.stopped:
              return const Placeholder();
            case AppStatus.failed:
              return const FailedScreen();
          }
        },
      ),
    );
  }
}

class ReadyScreen extends StatelessWidget {
  const ReadyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
            color: Colors.blueGrey,
            iconSize: 64,
            onPressed: () {
              context.read<AppCubit>().launchGame();
            },
            icon: const Icon(Icons.play_arrow_rounded))
        .centered();
  }
}

class PlayingScreen extends StatelessWidget {
  const PlayingScreen({super.key, required this.quiz});

  final Quiz quiz;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppCubit>().state;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            'Score: ${state.score}'.text.size(24).color(Colors.black).make(),
            'Temps: ${state.remainingTime}'
                .text
                .size(24)
                .color(Colors.black)
                .make(),
          ],
        ),
        'Cet acteur est-il présent dans le film ?'
            .text
            .size(16)
            .color(Colors.black)
            .make(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            quizzPart(url: quiz.actorImage, title: quiz.actorName),
            quizzPart(url: quiz.movieImage, title: quiz.movieName)
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
                    onPressed: () {
                      quiz.isLinked
                          ? context.read<AppCubit>().submitQuiz(true)
                          : context.read<AppCubit>().submitQuiz(false);
                    },
                    child: 'Oui'.text.color(Colors.black).size(16).make())
                .box
                .roundedSM
                .color(Colors.green)
                .make(),
            TextButton(
                    onPressed: () {
                      quiz.isLinked
                          ? context.read<AppCubit>().submitQuiz(false)
                          : context.read<AppCubit>().submitQuiz(true);
                    },
                    child: 'Non'.text.color(Colors.black).size(16).make())
                .box
                .roundedSM
                .color(Colors.red)
                .make()
          ],
        )
      ],
    );
  }
}

class StoppedScreen extends StatelessWidget {
  const StoppedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class FailedScreen extends StatelessWidget {
  const FailedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
            child: 'Erreur de chargement !'.text.size(16).makeCentered())
        .safeArea();
  }
}
