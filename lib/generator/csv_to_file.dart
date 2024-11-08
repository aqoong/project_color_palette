/*
 * Copyright (c) 2024. AQoong(cooldnjsdn@gmail.com) All rights reserved.
 */

import 'dart:convert';
import 'dart:io';

import 'package:build/build.dart';
import 'package:csv/csv.dart';

class CsvToFile {
  final String outputFilePath = 'lib/palette/';
  late final File csvFile;
  final BuildStep buildStep;
  final AssetId csvAssetId;

  CsvToFile({required this.buildStep, required this.csvAssetId}) {
    csvFile = File(csvAssetId.path);
  }

  /// read CSV File
  /// UTF-8 encoded CSV file
  Future<void> csvContent() async {
    if (!await csvFile.exists()) {
      throw Exception('CSV File not found : ${csvFile.path}');
    }

    final strCsv = await csvFile.readAsString(encoding: utf8);
    final csvFileName = csvFile.path.split('/').last;
    try {
      final List<dynamic> rows = const CsvToListConverter().convert(strCsv);
      final buffer = StringBuffer(_importSection(csvFileName, rows.length - 1));

      for (var i = 1; i < rows.length; i++) {
        final data = rows[i];
        final String colorName = data[0] ?? '';
        final String colorValue = (data[1] ?? '').replaceFirst('#', '0xFF');
        final String comment = data[2] ?? '';

        String objectString = '';
        if (colorName.isNotEmpty && colorValue.isNotEmpty) {
          objectString =
              '  static const Color ${_colorNameConverter(colorName)} = Color($colorValue);';
          if (comment.isNotEmpty) {
            objectString = '$objectString  //$comment';
          }
        } else {
          objectString = '  // Error : $colorName, $colorValue';
        }
        buffer.writeln(objectString);
        buffer.writeln('}');
      }

      //file create
      final outputId = AssetId(buildStep.inputId.package,
          '$outputFilePath${csvFileName.split('.').first}.g.dart');
      await buildStep.writeAsString(outputId, buffer.toString());
    } catch (e) {
      rethrow;
    }
  }

  StringBuffer _importSection(String fileName, int rowLength) {
    StringBuffer sb = StringBuffer();
    sb.writeln('import \'package:flutter/material.dart\';');
    sb.writeln('');
    sb.writeln('/// Auto-generated from project_color_palette package.');
    sb.writeln("/// From '$fileName'");
    sb.writeln('/// color row length $rowLength');
    sb.writeln('class ${_toCamelCase(fileName)} {');
    return sb;
  }

  String _colorNameConverter(String colorName) {
    final lowCase = colorName.toLowerCase();
    String result = lowCase;

    if (lowCase.isNotEmpty) {
      result = lowCase[0].toUpperCase() + lowCase.substring(1);
    }
    return 'color$result';
  }

  String _toCamelCase(String fileName) {
    // 파일명에서 확장자를 제거
    String nameWithoutExtension = fileName.split('.').first;

    // 언더스코어(_)로 단어를 분리한 후 각 단어의 첫 글자를 대문자로 변환
    return nameWithoutExtension
        .split('_') // 언더스코어로 분리
        .map((word) => word[0].toUpperCase() + word.substring(1)) // 첫 글자를 대문자로
        .join(''); // 다시 합침
  }
}
