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

/// Replaces one node with another.
class HubbubNodeReplacer extends NodeReplacer
    implements HubbubAstVisitor<bool> {
  final AstNode oldNode, newNode;

  HubbubNodeReplacer(this.oldNode, this.newNode) : super(oldNode, newNode);

  @override
  bool visitTemplateLiteral(TemplateLiteral node) {
    if (identical(node.simpleIdentifier, oldNode)) {
      node.simpleIdentifier = newNode as SimpleIdentifier;
      return true;
    } else if (identical(node.stringLiteral, oldNode)) {
      node.stringLiteral = newNode as StringLiteral;
      return true;
    }
    return visitNode(node);
  }
}
