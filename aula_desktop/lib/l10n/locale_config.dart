import 'package:flutter/material.dart';

import 'app_localizations.dart';

const englishLocale = Locale('en');
const chineseSimplifiedLocale = Locale('zh', 'CN');
const chineseTraditionalLocale = Locale('zh', 'TW');

/// Explicit locales offered in the language picker.
const List<Locale> appLocaleOptions = [
  englishLocale,
  chineseSimplifiedLocale,
  chineseTraditionalLocale,
];

Locale? resolveAppLocale(Locale? locale, Iterable<Locale> supportedLocales) {
  if (locale == null) {
    return englishLocale;
  }

  for (final supported in supportedLocales) {
    if (supported.languageCode == locale.languageCode &&
        supported.countryCode == locale.countryCode) {
      return supported;
    }
  }

  if (locale.languageCode == 'zh') {
    final usesTraditional =
        locale.scriptCode == 'Hant' ||
        locale.countryCode == 'TW' ||
        locale.countryCode == 'HK' ||
        locale.countryCode == 'MO';
    return usesTraditional ? chineseTraditionalLocale : chineseSimplifiedLocale;
  }

  if (locale.languageCode == 'en') {
    return englishLocale;
  }

  return englishLocale;
}

bool localesMatch(Locale? a, Locale? b) {
  if (a == null || b == null) {
    return a == b;
  }
  return a.languageCode == b.languageCode && a.countryCode == b.countryCode;
}

String localeLabel(AppLocalizations l10n, Locale? locale) {
  if (locale == null) {
    return l10n.languageSystem;
  }
  if (locale == englishLocale) {
    return l10n.languageEnglish;
  }
  if (locale == chineseSimplifiedLocale) {
    return l10n.languageChineseSimplified;
  }
  if (locale == chineseTraditionalLocale) {
    return l10n.languageChineseTraditional;
  }
  return locale.toLanguageTag();
}
