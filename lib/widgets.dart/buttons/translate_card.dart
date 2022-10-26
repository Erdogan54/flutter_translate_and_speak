import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/translate_cubit.dart';
import 'card_bottom_bar.dart';
import 'language_bar.dart';

class TranslateCard extends StatefulWidget {
  final String place;
  const TranslateCard({Key? key, required this.place}) : super(key: key);

  @override
  State<TranslateCard> createState() => _TranslateCardState();
}

class _TranslateCardState extends State<TranslateCard> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.40,
        width: double.infinity,
        padding: const EdgeInsets.only(top: 0, bottom: 8, right: 8, left: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              offset: const Offset(1, 1),
              blurRadius: 5,
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            LanguageBar(place: widget.place),
            _textField(context),
            BottomBarCard(place: widget.place),
          ],
        ),
      ),
    );
  }

  Widget _textField(BuildContext context) {
    if (widget.place == "from") {
      _controller.text = context.watch<TranslateCubit>().listenTxt;
    } else {
      _controller.text = context.watch<TranslateCubit>().resultTxt;
    }

    return Expanded(
      child: TextField(
        controller: _controller,
        autofocus: false,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: InputBorder.none,
          suffixIcon: InkWell(
            onTap: () {
              _controller.text = "";
              BlocProvider.of<TranslateCubit>(context)
                  .onEditText(widget.place, "");
            },
            child: const Icon(Icons.clear),
          ),
        ),
        style: const TextStyle(
            fontSize: 24, color: Colors.black, fontWeight: FontWeight.w400),
        onSubmitted: (value) {
          FocusScope.of(context).unfocus();
          BlocProvider.of<TranslateCubit>(context)
              .onEditText(widget.place, value);
        },
      ),
    );
  }
}


