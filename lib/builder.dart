import 'dart:async';
import 'package:build/build.dart';

/// Applies Hubbub transforms/compilers, and produces a Dart file.
class HubbubBuilder implements Builder {
  @override
  Map<String, List<String>> get buildExtensions {
    return {
      '.dartx': ['.dart'],
      '.hubbub': ['.dart']
    };
  }

  @override
  Future<void> build(BuildStep buildStep) async {
    var inputId = buildStep.inputId;
    var dartId = inputId.changeExtension('.dart');
  }
}
