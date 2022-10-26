// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:translator/translator.dart';

import 'package:flutter_translate_and_speak/models/language_model.dart';
import 'package:flutter/services.dart';

class TranslateCubit extends Cubit<TranslateState> {
  final SpeechToText speech;
  final GoogleTranslator _translator;
  final FlutterTts _ttspeak;

  TranslateCubit(this.speech, this._translator, this._ttspeak)
      : super(InitSuccessState());

  LanguageModel _toModel = LanguageModel(
      countries: ["United States"],
      imageAdress:
          "https://upload.wikimedia.org/wikipedia/en/thumb/a/a4/Flag_of_the_United_States.svg/188px-Flag_of_the_United_States.svg.png",
      language: "English",
      speakCode: "en-US",
      listenCode: "en_US",
      translateCode: "en");

  LanguageModel _fromModel = LanguageModel(
      countries: ["Türkiye"],
      imageAdress:
          "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b4/Flag_of_Turkey.svg/188px-Flag_of_Turkey.svg.png",
      language: "Türkçe",
      speakCode: "tr-TR",
      listenCode: "tr_TR",
      translateCode: "tr");

  bool _hasSpeech = false;
  bool _isSpeak = false;
  bool isSpeakabilityTo = true;
  bool isSpeakabilityFrom = true;
  bool isListenabilityTo = true;
  bool isListenabilityFrom = true;
  bool _isTranslating = false;
  double confidence = 1.0;
  String _currentLocaleId = "";
  String listenTxt = "Lütfen birşeyler söyleyin";
  String resultTxt = "Please say samething";

  get isListen => speech.isListening;
  get toModel => _toModel;
  get fromModel => _fromModel;
  get hasSpeech => _hasSpeech;

  Future<void> initSpeech() async {
    try {
      _hasSpeech = await speech.initialize(
          onStatus: (status) => _onStatus(status),
          onError: (error) => _onError(error));

      if (_hasSpeech) {
        //_localeNamesAndIdList = await speech.locales();
        var systemLocale = await speech.systemLocale();
        _currentLocaleId = systemLocale?.localeId ?? '';
        _fromModel.listenCode = systemLocale?.localeId ?? '';
      }
    } on Exception catch (error) {
      debugPrint("initSpeech Error: $error");
      emit(InitError(error));
    }
  }

  void _onStatus(String status) {
    debugPrint("onStatus $status");
  }

  void _onError(SpeechRecognitionError error) {
    debugPrint("onError $error");
    confidence = 0.0;
  }

  Future<void> setToLanguage(LanguageModel model) async {
    _toModel = model;
    emit(SelectToLanguage(model: model));
    isSpeakabilityTo = _toModel.speakCode!.isNotEmpty;
    isListenabilityTo = _toModel.speakCode!.isNotEmpty;
    _onTranslateSetLanguage("to");
  }

  Future<void> setFromLanguage(LanguageModel model) async {
    _fromModel = model;
    emit(SelectFromLanguage(model: model));
    isListenabilityFrom = model.listenCode!.isNotEmpty;
    isSpeakabilityFrom = model.speakCode!.isNotEmpty;
    _onTranslateSetLanguage("from");
  }

  Future<void> _onTranslateSetLanguage(String fromOrTo) async {
    if (speech.isNotListening && !_isTranslating) {
      if (fromOrTo == "from" && listenTxt.isNotEmpty) {
        _translator
            .translate(listenTxt, to: _fromModel.translateCode!)
            .then((value) {
          listenTxt = value.text;
          _isTranslating = false;
          emit(RefreshState());
        });
      } else if (fromOrTo == "to" && resultTxt.isNotEmpty) {
        _isTranslating = true;
        _translator
            .translate(resultTxt, to: _toModel.translateCode!)
            .then((value) {
          resultTxt = value.text;
          _isTranslating = false;
          emit(RefreshState());
        });
      }
    }
  }

  void micButton({required String place}) {
    if (speech.isNotListening && !_isSpeak) {
      if (place == "from" && isListenabilityFrom) {
        _startListening(place);
      } else if (place == "to" && isListenabilityTo) {
        _startListening(place);
      }
    } else {
      _stopListening();
    }
  }

  Future<void> _startListening(String place) async {
    if (_hasSpeech == true) {
      await speech.listen(
        localeId:
            place == "from" ? _fromModel.listenCode! : _toModel.listenCode!,
        onResult: (result) {
          _onSpeechResult(result, place);
        },
      );
    }
  }

  Future<void> _stopListening() async {
    await speech.stop();
  }

  void _onSpeechResult(SpeechRecognitionResult result, String place) async {
    if (result.hasConfidenceRating && result.confidence > 0) {
      confidence = result.confidence;
      if (place == "from") {
        listenTxt = result.recognizedWords;
        emit(ListenText(result.finalResult));
      } else {
        resultTxt = result.recognizedWords;
        emit(ResultText(result.finalResult));
      }
      await _onTranslate(place);
    }
  }

  Future<void> _onTranslate(String place) async {
    if (speech.isNotListening && !_isTranslating) {
      if (place == "from" && listenTxt.isNotEmpty) {
        _isTranslating = true;
        _translator
            .translate(listenTxt,
                from: _fromModel.translateCode!, to: _toModel.translateCode!)
            .then((value) {
          resultTxt = value.text;
          _isTranslating = false;
          emit(ResultText(value.text));
        });
      } else if (place == "to" && resultTxt.isNotEmpty) {
        _isTranslating = true;
        _translator
            .translate(resultTxt,
                from: _toModel.translateCode!, to: _fromModel.translateCode!)
            .then((value) {
          listenTxt = value.text;
          _isTranslating = false;
          emit(ListenText(value.text));
        });
      }
    }
  }

  void onEditText(String place, String text) async {
    if (text.isEmpty) {
      resultTxt = "";
      listenTxt = "";
      emit(RefreshState());
    } else {
      if (place == "from") {
        listenTxt = text;
        emit(ListenText(text));
        await _onTranslate("from");
      } else {
        resultTxt = text;
        emit(ResultText(text));
        await _onTranslate("to");
      }
    }
  }

  void speakButton({required String place}) {
    if (place == "to") {
      _onSpeak(
          value: resultTxt,
          language: _toModel.speakCode!,
          speakability: isSpeakabilityTo);
    } else if (place == "from") {
      _onSpeak(
          value: listenTxt,
          language: _fromModel.speakCode!,
          speakability: isSpeakabilityFrom);
    }
  }

  Future<void> _onSpeak(
      {required String value,
      required String language,
      required bool speakability}) async {
    if (speakability && speech.isNotListening) {
      _isSpeak = true;
      _ttspeak.awaitSpeakCompletion(true);
      // await _ttspeak.setVolume(5.0);
      // await _ttspeak.setPitch(1.0);
      //  await _ttspeak.setSpeechRate(0.40);
      await _ttspeak.setLanguage(language);
      await _ttspeak.speak(value);
      _isSpeak = false;
    }
  }

  Future<void> onShareWithResult(BuildContext context, String place) async {
    final box = context.findRenderObject() as RenderBox?;
    late ShareResult result;
    if (place == "from") {
      result = await Share.shareWithResult(listenTxt,
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    } else {
      result = await Share.shareWithResult(resultTxt,
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    }

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Share result: ${result.status}"),
    ));
  }

  Future<void> onCopyToClipboard(BuildContext context, String place) async {
    if (place == "from") {
      await Clipboard.setData(ClipboardData(text: listenTxt));
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Kopyalandı', textAlign: TextAlign.center),
      ));
    } else {
      await Clipboard.setData(ClipboardData(text: resultTxt));
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Kopyalandı', textAlign: TextAlign.center),
      ));
    }
  }
}

@immutable
abstract class TranslateState {}

class InitSuccessState extends TranslateState {}

class InitError extends TranslateState {
  final error;

  InitError(this.error);
}

class ResultText extends TranslateState {
  final text;
  ResultText(this.text);
}

class ListenText extends TranslateState {
  final text;
  ListenText(this.text);
}

class ListenAndResultText extends TranslateState {
  final listenText;
  final resultText;

  ListenAndResultText({required this.listenText, required this.resultText});
}

class SelectFromLanguage extends TranslateState {
  final LanguageModel model;
  SelectFromLanguage({
    required this.model,
  });
}

class SelectToLanguage extends TranslateState {
  final LanguageModel model;
  SelectToLanguage({
    required this.model,
  });
}

class RefreshState extends TranslateState {}
