import 'dart:io';

import 'package:fast_i18n/src/model/context_type.dart';
import 'package:fast_i18n/src/model/i18n_locale.dart';

/// represents a build.yaml
class BuildConfig {
  static const String defaultBaseLocale = 'en';
  static const FallbackStrategy defaultFallbackStrategy = FallbackStrategy.none;
  static const String? defaultInputDirectory = null;
  static const String defaultInputFilePattern = '.i18n.json';
  static const String? defaultOutputDirectory = null;
  static const String defaultOutputFilePattern = '.g.dart';
  static const String defaultTranslateVar = 't';
  static const String defaultEnumName = 'AppLocale';
  static const TranslationClassVisibility defaultTranslationClassVisibility =
      TranslationClassVisibility.private;
  static const CaseStyle? defaultKeyCase = null;
  static const CaseStyle? defaultParamCase = null;
  static const StringInterpolation defaultStringInterpolation =
      StringInterpolation.dart;
  static const bool defaultRenderFlatMap = true;
  static const List<String> defaultMaps = <String>[];
  static const PluralAuto defaultPluralAuto = PluralAuto.cardinal;
  static const List<String> defaultCardinal = <String>[];
  static const List<String> defaultOrdinal = <String>[];
  static const List<ContextType> defaultContexts = <ContextType>[];

  final FileType fileType;
  final I18nLocale baseLocale;
  final FallbackStrategy fallbackStrategy;
  final String? inputDirectory;
  final String inputFilePattern;
  final String? outputDirectory;
  final String outputFilePattern;
  final String translateVar;
  final String enumName;
  final TranslationClassVisibility translationClassVisibility;
  final CaseStyle? keyCase;
  final CaseStyle? paramCase;
  final StringInterpolation stringInterpolation;
  final bool renderFlatMap;
  final List<String> maps;
  final PluralAuto pluralAuto;
  final List<String> pluralCardinal;
  final List<String> pluralOrdinal;
  final List<ContextType> contexts;

  BuildConfig({
    required this.baseLocale,
    required this.fallbackStrategy,
    required this.inputDirectory,
    required this.inputFilePattern,
    required this.outputDirectory,
    required this.outputFilePattern,
    required this.translateVar,
    required this.enumName,
    required this.translationClassVisibility,
    required this.keyCase,
    required this.paramCase,
    required this.stringInterpolation,
    required this.renderFlatMap,
    required this.maps,
    required this.pluralAuto,
    required this.pluralCardinal,
    required this.pluralOrdinal,
    required this.contexts,
  }) : fileType = _determineFileType(inputFilePattern);

  static FileType _determineFileType(String extension) {
    if (extension.endsWith('.json')) {
      return FileType.json;
    } else if (extension.endsWith('.yaml')) {
      return FileType.yaml;
    } else {
      throw 'Input file pattern must end with .json or .yaml (Input: $extension)';
    }
  }

  BuildConfig withAbsolutePaths() {
    return BuildConfig(
      baseLocale: baseLocale,
      fallbackStrategy: fallbackStrategy,
      inputDirectory: inputDirectory?.normalizePath(),
      inputFilePattern: inputFilePattern,
      outputDirectory: outputDirectory?.normalizePath(),
      outputFilePattern: outputFilePattern,
      translateVar: translateVar,
      enumName: enumName,
      translationClassVisibility: translationClassVisibility,
      keyCase: keyCase,
      paramCase: paramCase,
      stringInterpolation: stringInterpolation,
      renderFlatMap: renderFlatMap,
      maps: maps,
      pluralAuto: pluralAuto,
      pluralCardinal: pluralCardinal,
      pluralOrdinal: pluralOrdinal,
      contexts: contexts,
    );
  }
}

enum FileType { json, yaml }
enum FallbackStrategy { none, baseLocale }
enum StringInterpolation { dart, braces, doubleBraces }
enum TranslationClassVisibility { private, public }
enum CaseStyle { camel, pascal, snake }
enum PluralAuto { off, cardinal, ordinal }

extension Parser on String {
  FallbackStrategy? toFallbackStrategy() {
    switch (this) {
      case 'none':
        return FallbackStrategy.none;
      case 'base_locale':
        return FallbackStrategy.baseLocale;
      default:
        return null;
    }
  }

  TranslationClassVisibility? toTranslationClassVisibility() {
    switch (this) {
      case 'private':
        return TranslationClassVisibility.private;
      case 'public':
        return TranslationClassVisibility.public;
      default:
        return null;
    }
  }

  StringInterpolation? toStringInterpolation() {
    switch (this) {
      case 'dart':
        return StringInterpolation.dart;
      case 'braces':
        return StringInterpolation.braces;
      case 'double_braces':
        return StringInterpolation.doubleBraces;
      default:
        return null;
    }
  }

  CaseStyle? toCaseStyle() {
    switch (this) {
      case 'camel':
        return CaseStyle.camel;
      case 'snake':
        return CaseStyle.snake;
      case 'pascal':
        return CaseStyle.pascal;
      default:
        return null;
    }
  }

  PluralAuto? toPluralAuto() {
    switch (this) {
      case 'off':
        return PluralAuto.off;
      case 'cardinal':
        return PluralAuto.cardinal;
      case 'ordinal':
        return PluralAuto.ordinal;
      default:
        return null;
    }
  }

  /// converts to absolute file path
  String normalizePath() {
    String result = this
        .replaceAll('/', Platform.pathSeparator)
        .replaceAll('\\', Platform.pathSeparator);

    if (result.startsWith(Platform.pathSeparator))
      result = result.substring(Platform.pathSeparator.length);

    if (result.endsWith(Platform.pathSeparator))
      result =
          result.substring(0, result.length - Platform.pathSeparator.length);

    return Directory.current.path + Platform.pathSeparator + result;
  }
}
