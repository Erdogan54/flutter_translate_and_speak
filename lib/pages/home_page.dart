import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate_and_speak/cubit/language_cubit.dart';
import '../cubit/translate_cubit.dart';
import '../widgets.dart/buttons/translate_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<TranslateCubit>(context).initSpeech();
    return const Scaffold(
      appBar: HomePageAppBar(),
      body: HomePageBody(),
    );
  }
}

class HomePageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomePageAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  PreferredSizeWidget build(BuildContext context) {
    return AppBar(
        title: InkWell(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Sesli Tercüman", textAlign: TextAlign.center),
            Visibility(
              visible: context.read<TranslateCubit>().isListen,
              child: Text(
                  "${(context.watch<TranslateCubit>().confidence * 100).toStringAsFixed(1)}%",
                  textAlign: TextAlign.center),
            )
          ]),
    ));
  }
}

class HomePageBody extends StatefulWidget {
  const HomePageBody({Key? key}) : super(key: key);

  @override
  State<HomePageBody> createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody> {
  String from = "from";
  String to = "to";
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Stack(
      alignment: Alignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TranslateCard(place: to),
            Divider(
                height: 1,
                thickness: 1,
                color: Colors.grey.shade500,
                indent: 8,
                endIndent: 8),
            TranslateCard(place: from),
          ],
        ),
        Positioned(
          right: MediaQuery.of(context).size.width / 2 - 20,
          top: MediaQuery.of(context).size.height / 2 - 85,
          child: InkWell(
            onTap: () {
              String change;
              change = from;
              from = to;
              to = change;
              setState(() {});
            },
            child: Container(
              height: 30,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Image.asset(
                "assets/images/exchange1.png",
                fit: BoxFit.fill,
              ),
            ),
          ),
        )
      ],
    ));
  }
}
