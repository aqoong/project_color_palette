/*
 * Copyright (c) 2024. AQoong(cooldnjsdn@gmail.com) All rights reserved.
 */

import 'dart:async';

import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:project_color_palette/generator/csv_to_file.dart';

Builder paletteGeneratorBuilder(BuilderOptions options) => PaletteGenerator(options: options);

class PaletteGenerator extends Builder {
  final String outputFilePath = 'lib/color_palette.g.dart';
  final BuilderOptions options;

  PaletteGenerator({required this.options});

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    log.info('PaletteGenerator: Starting build process.');

    final csvFiles = await buildStep.findAssets(Glob('assets/*.csv')).toList();

    if (csvFiles.isEmpty) {
      log.warning('PaletteGenerator: No CSV files found in assets folder.');
      return;
    }

    log.info('PaletteGenerator: Found ${csvFiles.length} CSV file(s).');

    StringBuffer sb = StringBuffer(_writeFileInit());

    for (var csvFile in csvFiles) {
      try {
        if (_checkAsset(csvFile.path)) {
          final colorStringBuffer = await CsvToFile(filePath: csvFile.path).csvContent();
          sb.writeln(colorStringBuffer);
        }
      } catch (e) {
        rethrow;
      }
    }

    sb.writeln('}');

    final outputId = AssetId(buildStep.inputId.package, outputFilePath);
    await buildStep.writeAsString(outputId, sb.toString());
  }

  bool _checkAsset(String path) => path.contains('assets/');

  StringBuffer _writeFileInit() {
    StringBuffer sb = StringBuffer();
    sb.writeln('import \'package:flutter/material.dart\';');
    sb.writeln('');
    sb.writeln('/// Auto-generated from palette package.');
    sb.writeln('');
    sb.writeln('class ColorPalette {');
    return sb;
  }

  @override
  Map<String, List<String>> get buildExtensions => const {
    r'$lib$': ['color_palette.g.dart'],
  };
}