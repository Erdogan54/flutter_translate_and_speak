import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_translate_and_speak/cubit/translate_cubit.dart';

class SpeakButton extends StatelessWidget {
  final String place;
  const SpeakButton({Key? key, required this.place}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isSpeakAble = false;
    bool isNotEmptyText = false;
    if (place == "to") {
      isSpeakAble = context.watch<TranslateCubit>().isSpeakabilityTo;
      isNotEmptyText = context.watch<TranslateCubit>().resultTxt.isNotEmpty;
    } else {
      isSpeakAble = context.watch<TranslateCubit>().isSpeakabilityFrom;
      isNotEmptyText = context.watch<TranslateCubit>().listenTxt.isNotEmpty;
    }
    return IconButton(
        color: Colors.blue,
        iconSize: 30,
        onPressed: isSpeakAble && isNotEmptyText
            ? () {
                FocusScope.of(context).requestFocus(FocusNode());
                context.read<TranslateCubit>().speakButton(place: place);
              }
            : null,
        icon: isSpeakAble && isNotEmptyText
            ? const Icon(Icons.volume_up)
            : const Icon(Icons.volume_off));
  }
}
