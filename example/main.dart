import 'dart:io';
import 'package:hubbub/hubbub.dart';
import 'package:path/path.dart' as p;

main() async {
  var dir = p.dirname(p.fromUri(Platform.script));
  var stringTagFile = File(p.join(dir, 'string_tag.dartx'));
  var stringTagUnit = parseCompilationUnit(await stringTagFile.readAsString());
  print(stringTagUnit.toSource());
}
