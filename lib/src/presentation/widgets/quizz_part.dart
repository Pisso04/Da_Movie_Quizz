import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:velocity_x/velocity_x.dart';

Widget quizzPart({required String url, required String title}) {
  return Column(
    children: [
      CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        width: 100,
        height: 100,
      ).box.clip(Clip.antiAliasWithSaveLayer).rounded.make(),
      const Gap(20),
      SizedBox(
          width: 150, child: title.text.align(TextAlign.center).color(Colors.black).size(16).makeCentered()),
    ],
  );
}
