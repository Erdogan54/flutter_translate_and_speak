import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_translate_and_speak/models/language_model.dart';

class LanguagesSource {
  List<LanguageModel> modelList = [];

  Future<List<LanguageModel>> getData(BuildContext context) async {
    String stringData = await DefaultAssetBundle.of(context)
        .loadString("assets/source/source.json");

    List mapList = json.decode(stringData);


    for (var element in mapList) {
      var model = LanguageModel.fromMap(element);

      

      bool result =
          modelList.any((element) => element.language == model.language);
      if (!result) {
        modelList.add(model);
      }
    }

    modelList.sort(
      (a, b) => a.countries!.first.compareTo(b.countries!.first),
    );
    return modelList;
  }
}
