import 'dart:isolate';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:hubbub/hubbub.dart';
import 'package:hubbub/tokens.dart';

// Multiplies all integer literals by 2.
main(_, [SendPort sendPort]) {
  return hubbub(sendPort, (unit) {
    // Find all integer literals.
    var intFinder = _IntFinder()..visitCompilationUnit(unit);
    var ints = intFinder.ints;

    // Multiply all ints by 2, and modify the AST.
    for (var i in ints) {
      var v = i.value * 2;
      var r = astFactory.integerLiteral(intToken(v), v);
      HubbubNodeReplacer.replace(i, r);
    }

    // Return the modified AST.
    return unit;
  });
}

class _IntFinder extends RecursiveHubbubAstVisitor<void> {
  final ints = <IntegerLiteral>[];

  void visitIntegerLiteral(IntegerLiteral node) {
    ints.add(node);
  }
}
