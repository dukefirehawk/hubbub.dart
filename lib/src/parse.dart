import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/src/dart/scanner/reader.dart';
import 'package:analyzer/src/dart/scanner/scanner.dart';
import 'package:analyzer/src/error.dart';
import 'package:analyzer/src/generated/source_io.dart';
import 'package:analyzer/src/string_source.dart';
import 'parser.dart';

CompilationUnit parseCompilationUnit(String contents,
    {String name,
    bool suppressErrors: false,
    bool parseFunctionBodies: true,
    FeatureSet featureSet}) {
  featureSet ??= FeatureSet.fromEnableFlags([]);
  Source source = new StringSource(contents, name);
  return _parseSource(contents, source, featureSet,
      suppressErrors: suppressErrors, parseFunctionBodies: parseFunctionBodies);
}

CompilationUnit _parseSource(
    String contents, Source source, FeatureSet featureSet,
    {bool suppressErrors: false, bool parseFunctionBodies: true}) {
  var reader = new CharSequenceReader(contents);
  var errorCollector = new _ErrorCollector();
  var scanner = new Scanner(source, reader, errorCollector)
    ..configureFeatures(featureSet);
  var token = scanner.tokenize();
  var parser = new HubbubParserAdapter(source, errorCollector, featureSet: featureSet)
    ..parseFunctionBodies = parseFunctionBodies;
  var unit = parser.parseCompilationUnit(token)
    ..lineInfo = new LineInfo(scanner.lineStarts);

  if (errorCollector.hasErrors && !suppressErrors) throw errorCollector.group;

  return unit;
}

/// A simple error listener that collects errors into an [AnalyzerErrorGroup].
class _ErrorCollector extends AnalysisErrorListener {
  final _errors = <AnalysisError>[];

  _ErrorCollector();

  /// The group of errors collected.
  AnalyzerErrorGroup get group =>
      new AnalyzerErrorGroup.fromAnalysisErrors(_errors);

  /// Whether any errors where collected.
  bool get hasErrors => !_errors.isEmpty;

  @override
  void onError(AnalysisError error) => _errors.add(error);
}
