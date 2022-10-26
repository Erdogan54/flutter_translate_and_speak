import 'dart:convert';

import 'package:flutter/foundation.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class LanguageModel {
  String? language;
  List<String>? countries;
  String? translateCode;
  String? speakCode;
  String? listenCode;
  String? imageAdress;
  LanguageModel({
    this.language,
    this.countries,
    this.translateCode,
    this.speakCode,
    this.listenCode,
    this.imageAdress,
  });

  LanguageModel copyWith({
    String? language,
    List<String>? countries,
    String? translateCode,
    String? speakCode,
    String? listenCode,
    String? imageAdress,
  }) {
    return LanguageModel(
      language: language ?? this.language,
      countries: countries ?? this.countries,
      translateCode: translateCode ?? this.translateCode,
      speakCode: speakCode ?? this.speakCode,
      listenCode: listenCode ?? this.listenCode,
      imageAdress: imageAdress ?? this.imageAdress,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'language': language,
      'countries': countries,
      'translateCode': translateCode,
      'speakCode': speakCode,
      'listenCode': listenCode,
      'imageAdress': imageAdress,
    };
  }

  factory LanguageModel.fromMap(Map<String, dynamic> map) {
    return LanguageModel(
      language: map['language'] != null ? map['language'] as String : null,
      countries: map['countries'] != null ? List<String>.from((map['countries'] as List<dynamic>)) : null,
      translateCode: map['translateCode'] != null ? map['translateCode'] as String : null,
      speakCode: map['speakCode'] != null ? map['speakCode'] as String : null,
      listenCode: map['listenCode'] != null ? map['listenCode'] as String : null,
      imageAdress: map['imageAdress'] != null ? map['imageAdress'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LanguageModel.fromJson(String source) => LanguageModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'LanguageModel(language: $language, countries: $countries, translateCode: $translateCode, speakCode: $speakCode, listenCode: $listenCode, imageAdress: $imageAdress)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is LanguageModel &&
      other.language == language &&
      listEquals(other.countries, countries) &&
      other.translateCode == translateCode &&
      other.speakCode == speakCode &&
      other.listenCode == listenCode &&
      other.imageAdress == imageAdress;
  }

  @override
  int get hashCode {
    return language.hashCode ^
      countries.hashCode ^
      translateCode.hashCode ^
      speakCode.hashCode ^
      listenCode.hashCode ^
      imageAdress.hashCode;
  }
}
