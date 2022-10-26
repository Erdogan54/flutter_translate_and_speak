// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_translate_and_speak/service/languages_source.dart';

import '../models/language_model.dart';

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit() : super(LanguageInitial(model: LanguageModel()));

  List<LanguageModel> _languageList = [];
  List<LanguageModel> _searchList = [];
  String _searchValue = "";
  bool isSearch = false;
  double scrool = 0.0;

  String get searchValue => _searchValue;

  getLanguageList(BuildContext context) async {
    if (_searchList.isNotEmpty) {
      emit(LangugaeListState(languageList: _searchList));
    } else if (_languageList.isNotEmpty) {
      emit(LangugaeListState(languageList: _languageList));
    } else {
      _languageList = await LanguagesSource().getData(context);
      emit(LangugaeListState(languageList: _searchList));
    }
  }

  onSearch({required String value}) {
    _searchValue = value;
    _searchList = _languageList
        .where((model) =>
            model.language!.toLowerCase().contains(value.toLowerCase()))
        .toList();
    emit(LangugaeListState(languageList: _searchList));

    if (value.isEmpty) {
      isSearch = false;
    } else {
      isSearch = true;
    }
  }
}

@immutable
abstract class LanguageState {}

class LanguageInitial extends LanguageState {
  final LanguageModel model;
  LanguageInitial({
    required this.model,
  });
}

class LangugaeListState extends LanguageState {
  final List<LanguageModel> languageList;
  LangugaeListState({
    required this.languageList,
  });
}
