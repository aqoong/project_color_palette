/*
 * Copyright (c) 2024. AQoong(cooldnjsdn@gmail.com) All rights reserved.
 */

import 'dart:async';

import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:project_color_palette/generator/csv_to_file.dart';

Builder paletteGeneratorBuilder(BuilderOptions options) => PaletteGenerator(options: options);

class PaletteGenerator extends Builder {
  // final String outputFilePath = 'lib/color_palette.g.dart';
  final BuilderOptions options;

  PaletteGenerator({required this.options});

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    log.info('PaletteGenerator: Starting build process.');
    final csvFiles = await buildStep.findAssets(Glob('assets/**.csv')).toList();

    if (csvFiles.isEmpty) {
      log.warning('PaletteGenerator: No CSV files found in assets folder.');
      return;
    }

    final titleFilteredFiles = csvFiles.where((file) => file.pathSegments.last.contains('color')).toList();


    for (var csvFile in titleFilteredFiles) {
      try {
        if (buildStep.inputId.path == csvFile.path) {
          await CsvToFile(buildStep: buildStep, csvAssetId: csvFile).csvContent();
        }
      } catch (e) {
        log.warning(e);
      }
    }
  }

  @override
  Map<String, List<String>> get buildExtensions => const {
    "assets/color_palette/{{}}.csv": ["lib/palette/{{}}.g.dart"],
  };
}