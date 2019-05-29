import 'package:analyzer/analyzer.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/src/dart/ast/ast.dart';
import 'package:front_end/src/base/syntactic_entity.dart';
import 'package:front_end/src/scanner/token.dart';
import 'visitor.dart';

/// A Hubbub-specific literal. Consists of a [SimpleIdentifier], followed by a [StringLiteral].
class TemplateLiteral extends LiteralImpl {
  final SimpleIdentifier simpleIdentifier;
  final StringLiteral stringLiteral;

  TemplateLiteral(this.simpleIdentifier, this.stringLiteral);

  @override
  Token get beginToken => simpleIdentifier.beginToken;

  @override
  Iterable<SyntacticEntity> get childEntities =>
      [simpleIdentifier, stringLiteral];

  @override
  Token get endToken => stringLiteral.endToken;

  @override
  E accept<E>(AstVisitor<E> visitor) {
    if (visitor is HubbubAstVisitor<E>) {
      return visitor.visitTemplateLiteral(this);
    } else if (visitor is ToSourceVisitor2) {
      simpleIdentifier.accept(visitor);
      stringLiteral.accept(visitor);
      return null;
    } else {
      throw UnsupportedError('$visitor does not support Hubbub syntax. '
          'Template literals and other syntax extensions '
          'must be transformed before exposure to plain Dart.');
    }
  }

  @override
  void visitChildren(AstVisitor visitor) {
    simpleIdentifier.accept(visitor);
    stringLiteral.accept(visitor);
  }
}
