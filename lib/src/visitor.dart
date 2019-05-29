import 'package:analyzer/src/dart/ast/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
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

  /// Replace the [oldNode] with the [newNode] in the AST structure containing
  /// the old node. Return `true` if the replacement was successful.
  ///
  /// Throws an [ArgumentError] if either node is `null`, if the old node does
  /// not have a parent node, or if the AST structure has been corrupted.
  static bool replace(AstNode oldNode, AstNode newNode) {
    if (oldNode == null || newNode == null) {
      throw ArgumentError("The old and new nodes must be non-null");
    } else if (identical(oldNode, newNode)) {
      return true;
    }
    AstNode parent = oldNode.parent;
    if (parent == null) {
      throw ArgumentError("The old node is not a child of another node");
    }
    var replacer = HubbubNodeReplacer(oldNode, newNode);
    return parent.accept(replacer);
  }

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
