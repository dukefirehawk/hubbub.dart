import 'package:front_end/src/fasta/scanner/utf8_bytes_scanner.dart';
import 'package:front_end/src/fasta/scanner/abstract_scanner.dart';

class HubbubScanner extends Utf8BytesScanner {
  HubbubScanner(List<int> bytes,
      {ScannerConfiguration configuration,
      bool includeComments: false,
      LanguageVersionChanged languageVersionChanged})
      : super(bytes,
            configuration: configuration,
            includeComments: includeComments,
            languageVersionChanged: languageVersionChanged);
}
