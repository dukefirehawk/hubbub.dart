import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/src/dart/error/syntactic_errors.dart';
import 'package:analyzer/src/dart/scanner/reader.dart';
import 'package:analyzer/src/generated/source.dart';
import 'package:analyzer/src/string_source.dart';
import 'package:front_end/src/fasta/scanner.dart' as fasta;
import 'package:front_end/src/scanner/errors.dart' show translateErrorToken;
import 'package:front_end/src/scanner/token.dart' show Token, TokenType;

/// Links the Hubbub scanner to fasta.
class HubbubScannerToFasta {
  final String contents;
  final AnalysisErrorListener errorListener;
  final bool enableGtGtGt;
  final bool enableNonNullable;
  final bool preserveComments;
  final bool scanLazyAssignmentOperators;
  final List<int> lineStarts = <int>[];
  Token firstToken;

  int _readerOffset;
  StringSource _source;

  HubbubScannerToFasta(this.contents, this.errorListener,
      {this.enableGtGtGt = false,
      this.enableNonNullable = false,
      this.preserveComments = true,
      this.scanLazyAssignmentOperators = false});

  void reportError(
      ScannerErrorCode errorCode, int offset, List<Object> arguments) {
    errorListener
        .onError(new AnalysisError(_source, offset, 1, errorCode, arguments));
  }

  Token tokenize() {
    fasta.ScannerResult result = fasta.scanString(contents,
        configuration: fasta.ScannerConfiguration(
            enableGtGtGt: enableGtGtGt, enableNonNullable: enableNonNullable),
        includeComments: preserveComments,
        scanLazyAssignmentOperators: scanLazyAssignmentOperators);

    // fasta pretends there is an additional line at EOF
    result.lineStarts.removeLast();

    // for compatibility, there is already a first entry in lineStarts
    result.lineStarts.removeAt(0);

    lineStarts.addAll(result.lineStarts);
    fasta.Token token = result.tokens;
    // The default recovery strategy used by scanString
    // places all error tokens at the head of the stream.
    while (token.type == TokenType.BAD_INPUT) {
      translateErrorToken(token, reportError);
      token = token.next;
    }
    firstToken = token;
    // Update all token offsets based upon the reader's starting offset
    if (_readerOffset != -1) {
      final int delta = _readerOffset + 1;
      do {
        token.offset += delta;
        token = token.next;
      } while (!token.isEof);
    }
    return firstToken;
  }
}
