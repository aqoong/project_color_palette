/*
 * Copyright (c) 2024. AQoong(cooldnjsdn@gmail.com) All rights reserved.
 */

import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';

class CsvToFile {
  late final File csvFile;

  CsvToFile({required String filePath}) {
    csvFile = File(filePath);
  }

  /// read CSV File
  /// UTF-8 encoded CSV file
  Future<StringBuffer> csvContent() async {
    if (!await csvFile.exists()) {
      throw Exception('CSV File not found');
    }

    final strCsv = await csvFile.readAsString(encoding: utf8);
    final csvFileName = csvFile.path.split('/').last;
    try {
      final List<dynamic> rows = const CsvToListConverter().convert(strCsv);
      final buffer = StringBuffer();

      buffer.writeln("  /// '$csvFileName'");
      buffer.writeln('  /// row length ${rows.length}');

      for (var i = 1 ; i < rows.length ; i++) {
        final data = rows[i];
        final String colorName = data[0] ?? '';
        final String colorValue = (data[1] ?? '').replaceFirst('#', '0xFF');
        final String comment = data[2] ?? '';

        String objectString = '';
        if (colorName.isNotEmpty && colorValue.isNotEmpty) {

          objectString = '  static const Color ${_colorNameConverter(colorName)} = Color($colorValue);';
          if (comment.isNotEmpty) {
            objectString = '$objectString  //$comment';
          }
        }else {
          objectString = '  // Error : $colorName, $colorValue';
        }
        buffer.writeln(objectString);
      }
      buffer.writeln('  /// [$csvFileName End]');

      return buffer;
    } catch (e) {
      rethrow;
    }
  }

  String _colorNameConverter(String colorName) {
    final lowCase = colorName.toLowerCase();
    String result = lowCase;

    if (lowCase.isNotEmpty) {
      result = lowCase[0].toUpperCase() + lowCase.substring(1);
    }
    return 'color$result';
  }
}