import 'dart:isolate';
import 'package:analyzer/dart/ast/standard_ast_factory.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:hubbub/hubbub.dart';
import 'package:hubbub/tokens.dart';

main(_, [SendPort sendPort]) {
  return hubbub(sendPort, (unit) {
    unit.accept(_TemplateReplacer());
    return unit;
  });
}

/// Replaces `yaml` templates with constant objects.
class _TemplateReplacer extends RecursiveHubbubAstVisitor<void> {
  @override
  void visitTemplateLiteral(TemplateLiteral node) {
    var msg = 'Replaced template of (${node.simpleIdentifier.name})';
    var msgStr = astFactory.simpleStringLiteral(stringToken('"$msg"'), msg);
    var $print = StringToken(TokenType.IDENTIFIER, "print", 0);
    var print = astFactory.simpleIdentifier($print);
    var argList = astFactory.argumentList($openParen, [msgStr], $closeParen);
    var replacement =
        astFactory.functionExpressionInvocation(print, null, argList);
    HubbubNodeReplacer.replace(node, replacement);
  }
}
