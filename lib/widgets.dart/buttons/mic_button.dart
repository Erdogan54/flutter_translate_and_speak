import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate_and_speak/cubit/translate_cubit.dart';


class MicButton extends StatelessWidget {
  final String place;
  const MicButton({Key? key, required this.place}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isListenAble = false;

    if (place == "from") {
      isListenAble = context.watch<TranslateCubit>().isListenabilityFrom;
    } else {
      isListenAble = context.watch<TranslateCubit>().isListenabilityTo;
    }
    return IconButton(
      onPressed: isListenAble
          ? () {
              FocusScope.of(context).unfocus();
              context.read<TranslateCubit>().micButton(place: place);
            }
          : null,
      iconSize: 30,
      color: Colors.blue,
      icon: Icon(
        isListenAble ? Icons.mic : Icons.mic_off,
      ),
    );
  }
}
