import 'dart:async';
import 'package:build/build.dart';
import 'package:dart_style/dart_style.dart';
import 'package:hubbub/hubbub.dart';

/// Top-level [HubbubBuilder].
Builder hubbubBuilder(_) => const HubbubBuilder();

/// Applies Hubbub transforms/compilers, and produces a Dart file.
class HubbubBuilder implements Builder {
  const HubbubBuilder();

  static final Resource<TransformationEngine> transformationEngineResource =
      Resource(() => TransformationEngine(),
          dispose: (engine) => engine.close());

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
    var contents = await buildStep.readAsString(inputId);
    var engine = await buildStep.fetchResource(transformationEngineResource);
    var unit = parseCompilationUnit(contents, name: inputId.path);
    engine.rootPackage = inputId.package;
    await engine.initialize();
    log.fine('Remotes: ${engine.remotes.map((r) => r.uri)}');
    unit = await engine.transform(inputId.path, unit);
    var fmt = DartFormatter().format(unit.toSource());
    await buildStep.writeAsString(dartId, fmt);
  }
}
