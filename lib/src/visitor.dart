import 'package:analyzer/analyzer.dart';
import 'template_literal.dart';

/// Traverses an entire Hubbub AST.
abstract class HubbubAstVisitor<T> extends AstVisitor<T> {
  /// Visits a [TemplateLiteral].
  T visitTemplateLiteral(TemplateLiteral node);
}

/// Does nothing when visiting nodes by default.
class SimpleHubbubAstVisitor<T> extends SimpleAstVisitor<T>
    implements HubbubAstVisitor<T> {
  @override
  T visitTemplateLiteral(TemplateLiteral node) => null;
}

/// Recursively visits nodes, doing nothing by default.
class RecursiveHubbubAstVisitor<T> extends RecursiveAstVisitor<T>
    implements HubbubAstVisitor<T> {
  @override
  T visitTemplateLiteral(TemplateLiteral node) {
    node.visitChildren(this);
    return null;
  }
}
