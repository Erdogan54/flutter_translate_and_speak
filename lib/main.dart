import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate_and_speak/cubit/language_cubit.dart';
import 'package:flutter_translate_and_speak/cubit/translate_cubit.dart';
import 'package:flutter_translate_and_speak/getit.dart';
import 'package:flutter_translate_and_speak/pages/home_page.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:translator/translator.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  
  
  //Share.share('check out my website https://example.com');
  getItSetup();

  runApp(const MyApp());
  FlutterNativeSplash.remove();
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _speechToText = SpeechToText();
    final _translator = GoogleTranslator();
    final _tts = FlutterTts();

    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                TranslateCubit(_speechToText, _translator, _tts),
            lazy: true,
          ),
          BlocProvider(
            create: (context) => LanguageCubit(),
            lazy: true,
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Voice',
          debugShowCheckedModeBanner: false,
          theme:
              ThemeData(primarySwatch: Colors.blue, canvasColor: Colors.white),
          home: const HomePage(),
        ));
  }
}
