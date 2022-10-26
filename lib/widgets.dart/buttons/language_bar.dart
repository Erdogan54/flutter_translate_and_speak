import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_translate_and_speak/cubit/translate_cubit.dart';
import 'package:flutter_translate_and_speak/models/language_model.dart';
import 'package:flutter_translate_and_speak/pages/choose_language.dart';
import 'package:image_loader/image_helper.dart';

class LanguageBar extends StatelessWidget {
  final String place;
  const LanguageBar({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    late LanguageModel _model;
    if (place == "from") {
      _model = context.watch<TranslateCubit>().fromModel;
    } else {
      _model = context.watch<TranslateCubit>().toModel;
    }

    return InkWell(
      onTap: (() => _chooseLanguageNavigate(context)),
      child: SizedBox(
        height: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _imageLoading(_model),
                const SizedBox(width: 5),
                _languageText(context, _model),
              ],
            ),
            const Divider(thickness: 1, height: 5, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _chooseLanguageNavigate(BuildContext context) {
    Navigator.of(context).push(CupertinoPageRoute(
        builder: (context) => ChooseLanguagePage(
              place: place,
            )));
  }

  Widget _imageLoading(LanguageModel model) {
    try {
      return ImageHelper(
        image: model.imageAdress!,
        imageType: ImageType.network,
        defaultLoaderColor: Colors.white,
        defaultErrorBuilderColor: Colors.blueGrey,
        boxFit: BoxFit.cover,
        height: 25,
        width: 33,
        loaderBuilder: _loader,
        errorBuilder: _errorBuilderIcon,
      );
    } on Exception catch (e) {
      debugPrint(e.toString());
      return _errorBuilderIcon;
    }
  }

  Widget _languageText(BuildContext context, LanguageModel model) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${model.countries![0]} - ${model.language!}",
          style: TextStyle(
            fontSize: 20,
            color: Colors.blue[600],
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget get _loader => const SpinKitWave(
        color: Colors.redAccent,
        type: SpinKitWaveType.start,
      );

  Widget get _errorBuilderIcon => const Icon(
        Icons.image_not_supported,
      );
}
