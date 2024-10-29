import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:velocity_x/velocity_x.dart';

Widget quizzPart(String url, String title) {
  return Column(
    children: [
      CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 200,
      ).box.clip(Clip.antiAliasWithSaveLayer).rounded.make(),
      const Gap(20),
    ],
  );
}
