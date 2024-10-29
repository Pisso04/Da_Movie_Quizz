import 'package:da_movie_quizz/src/app/bloc/app_cubit.dart';
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
      home: const Scaffold(body: AppContent()).safeArea(),
    );
  }
}

class AppContent extends StatelessWidget {
  const AppContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppCubit>(
      create: (context) => AppCubit()..prepareGame(),
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
              return const Placeholder();
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
            onPressed: () {},
            icon: const Icon(Icons.play_arrow_rounded))
        .centered();
  }
}

class PlayingScreen extends StatelessWidget {
  const PlayingScreen({super.key, required this.quiz});

  final Quiz quiz;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          children: [
            Column(
              children: [
                
              ],
            ),
            Column()
          ],
        ),
        Row(
          children: [
            TextButton(onPressed: () {}, child: 'Oui'.text.size(16).make()),
            TextButton(onPressed: () {}, child: 'Non'.text.size(16).make())
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
