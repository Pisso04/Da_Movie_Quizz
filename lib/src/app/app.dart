import 'package:da_movie_quizz/src/presentation/bloc/app_cubit.dart';
import 'package:da_movie_quizz/src/presentation/screens/screens.dart';
import 'package:da_movie_quizz/src/presentation/widgets/quizz_part.dart';
import 'package:da_movie_quizz/src/domain/models/quiz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DaMovieApp extends StatelessWidget {
  const DaMovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppCubit>(
        create: (context) => AppCubit(),
        child: MaterialApp(
          title: 'Da Movie Quiz',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: Scaffold(body: const AppContent().px16().py8()).safeArea(),
        ));
  }
}

class AppContent extends HookWidget {
  const AppContent({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      context.read<AppCubit>().init();
      return () {};
    }, []);

    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) => {
        if (state.status == AppStatus.stopped)
          {
            context.read<AppCubit>().verifyAndSaveBestScore(),
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const ScoreScreen()),
              (Route<dynamic> route) => false,
            )
          }
      },
      builder: (context, state) {
        switch (state.status) {
          case AppStatus.initial:
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  color: Colors.blueGrey,
                ).centered(),
                const Gap(20),
                'Veuillez patientez, cela pourrait prendre un peu de temps !'
                    .text
                    .size(12)
                    .color(Colors.black)
                    .makeCentered(),
              ],
            );
          case AppStatus.ready:
            return const ReadyScreen();
          case AppStatus.playing:
            return PlayingScreen(quiz: state.quizzes[state.score]);
          default:
            return const SizedBox.shrink();
        }
      },
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
