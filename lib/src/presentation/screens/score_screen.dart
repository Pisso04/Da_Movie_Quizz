import 'package:da_movie_quizz/src/app/app.dart';
import 'package:da_movie_quizz/src/presentation/bloc/app_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:velocity_x/velocity_x.dart';

class ScoreScreen extends StatelessWidget {
  const ScoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              state.scoreDesc.text.size(16).color(Colors.black).makeCentered(),
              const Gap(20),
              TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const DaMovieApp()),
                        (Route<dynamic> route) => false, 
                      );
                    },
                    child: 'Rejouer'.text.color(Colors.white).size(16).make())
                .box
                .roundedSM
                .color(Colors.blueGrey)
                .make(),
            ],
          );
        }
      ),
    ).safeArea();
  }
}