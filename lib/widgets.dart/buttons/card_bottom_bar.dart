import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate_and_speak/cubit/translate_cubit.dart';

import 'mic_button.dart';
import 'speak_button.dart';

class BottomBarCard extends StatelessWidget {
  final String place;
  const BottomBarCard({Key? key, required this.place}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          SpeakButton(place: place),
          MicButton(place: place),
        ]),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              color: Colors.blue,
              onPressed: () {
                BlocProvider.of<TranslateCubit>(context)
                    .onCopyToClipboard(context, place);
              },
              icon: const Icon(Icons.copy),
            ),
            IconButton(
              color: Colors.blue,
              onPressed: () {
                BlocProvider.of<TranslateCubit>(context)
                    .onShareWithResult(context, place);
              },
              icon: const Icon(Icons.share),
            )
          ],
        )
      ],
    );
  }
}
