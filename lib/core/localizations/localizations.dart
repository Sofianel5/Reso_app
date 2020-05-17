import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Localizer {
  final Locale locale;
  Localizer(this.locale);
  static Localizer of(BuildContext context) {
    return Localizations.of<Localizer>(context, Localizer);
  }

  Map<String, String> _localizedStrings;
  Future<bool> load() async {
    String jsonString =
        await rootBundle.loadString("lib/lang/${locale.languageCode}.json");
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });
    return true;
  }

  String get(String key) {
    return _localizedStrings[key] ?? key;
  } 

  static const LocalizationsDelegate<Localizer> delegate = _LocalizerDelegate();
}

class _LocalizerDelegate extends LocalizationsDelegate<Localizer> {
  const _LocalizerDelegate();
  @override
  bool isSupported(Locale locale) {
    return ["en", "ar", "de", "fr", "pl", "nl", "it", "es"].contains(locale.languageCode);
  }

  @override
  Future<Localizer> load(Locale locale) async {
    Localizer localizer = Localizer(locale);
    await localizer.load();
    return localizer;
  }

  @override
  bool shouldReload(_LocalizerDelegate old) => false;
}
