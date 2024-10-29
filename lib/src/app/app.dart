import 'package:da_movie_quizz/src/app/bloc/app_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DaMovieApp extends StatelessWidget {
  const DaMovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppCubit>(
      create: (context) => AppCubit(),
      child: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          return const SingleChildScrollView(
            child: Placeholder(),
          );
        },
      ),
    );
  }
}
