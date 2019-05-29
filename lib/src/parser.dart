import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/src/fasta/ast_builder.dart';
import 'package:analyzer/src/generated/source.dart';
import 'package:analyzer/src/generated/parser.dart';
import 'package:front_end/src/fasta/scanner.dart' as fasta;
import 'package:front_end/src/scanner/token.dart' as fasta;
import 'package:front_end/src/fasta/parser/listener.dart';
import 'package:front_end/src/fasta/parser/parser.dart' as fasta;
import 'template_literal.dart';

class HubbubParserAdapter extends ParserAdapter {
  @override
  bool enableUriInPartOf = true;

  @override
  final HubbubParser fastaParser = HubbubParser(null);

  factory HubbubParserAdapter(
      Source source, AnalysisErrorListener errorListener,
      {bool allowNativeClause: false, FeatureSet featureSet}) {
    var errorReporter = new ErrorReporter(errorListener, source);
    return new HubbubParserAdapter._(errorReporter, source.uri,
        allowNativeClause: allowNativeClause, featureSet: featureSet);
  }

  HubbubParserAdapter._(ErrorReporter errorReporter, Uri fileUri,
      {bool allowNativeClause: false, FeatureSet featureSet})
      : super(null, errorReporter, fileUri,
            allowNativeClause: allowNativeClause) {
    fastaParser._adapter = this;
    if (featureSet != null) {
      configureFeatures(featureSet);
    }
  }

  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class HubbubParser extends fasta.Parser {
  HubbubParser(Listener listener) : super(listener);
  HubbubParserAdapter _adapter;

  AstBuilder get _astBuilder => _adapter.astBuilder;

  fasta.Token parseExpression(fasta.Token token) {
    // TODO: DSX parsing
    var expr = super.parseExpression(token);
    if (expr == null) return null;

    // Template literals expect STRING_INT (identifier), followed by STRING.
    if (expr.type == fasta.TokenType.IDENTIFIER &&
        expr.next?.type == fasta.TokenType.STRING) {
      // Read the string.
      var strToken = parseLiteralString(expr);

      // Pop the identifier out of the builder...
      var str = _astBuilder.pop() as StringLiteral;
      var id = _astBuilder.pop() as SimpleIdentifier;

      // Next, construct the template literal.
      _astBuilder.push(TemplateLiteral(id, str));

      // Return the last token found.
      return strToken;
    }

    return expr;
  }
}
