// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/src/dart/ast/token.dart';
export 'package:analyzer/src/dart/ast/token.dart';

/// The `abstract` token.
final Token $abstract = KeywordToken(Keyword.ABSTRACT, 0);

/// The `as` token.
final Token $as = KeywordToken(Keyword.AS, 0);

/// The `assert` token.
final Token $assert = KeywordToken(Keyword.ASSERT, 0);

/// The `async` token.
final Token $async = KeywordToken(Keyword.ASYNC, 0);

/// The `@` token.
final Token $at = Token(TokenType.AT, 0);

/// The `await` token.
final Token $await = KeywordToken(Keyword.AWAIT, 0);

/// The `break` token.
final Token $break = KeywordToken(Keyword.BREAK, 0);

/// The `case` token.
final Token $case = KeywordToken(Keyword.CASE, 0);

/// The `class` token.
final Token $class = KeywordToken(Keyword.CLASS, 0);

/// The `]` token.
final Token $closeBracket = Token(TokenType.CLOSE_SQUARE_BRACKET, 0);

/// The '}' token.
final Token $closeCurly = Token(TokenType.CLOSE_CURLY_BRACKET, 0);

/// The ')' token.
final Token $closeParen = Token(TokenType.CLOSE_PAREN, 0);

/// The ':' token.
final Token $colon = Token(TokenType.COLON, 0);

/// The `const` token.
final Token $const = KeywordToken(Keyword.CONST, 0);

/// The `default` token.
final Token $default = KeywordToken(Keyword.DEFAULT, 0);

/// The `deferred` token.
final Token $deferred = KeywordToken(Keyword.DEFERRED, 0);

/// The `/` token.
final Token $divide = Token(TokenType.SLASH, 0);

/// The `do` keyword.
final Token $do = KeywordToken(Keyword.DO, 0);

/// The `else` token.
final Token $else = KeywordToken(Keyword.ELSE, 0);

/// The '=' token.
final Token $equals = Token(TokenType.EQ, 0);

/// The `==` token.
final Token $equalsEquals = Token(TokenType.EQ_EQ, 0);

/// The `extends` token.
final Token $extends = KeywordToken(Keyword.EXTENDS, 0);

/// The `factory` token.
final Token $factory = KeywordToken(Keyword.FACTORY, 0);

/// The `false` token.
final Token $false = KeywordToken(Keyword.FALSE, 0);

/// The `final` token.
final Token $final = KeywordToken(Keyword.FINAL, 0);

/// The `for` keyword.
final Token $for = KeywordToken(Keyword.FOR, 0);

/// The `>` token.
final Token $gt = Token(TokenType.GT, 0);

/// The `if` token.
final Token $if = KeywordToken(Keyword.IF, 0);

/// The `switch` keyword.
final Token $switch = KeywordToken(Keyword.SWITCH, 0);

/// The `super` keyword.
final Token $super = KeywordToken(Keyword.SUPER, 0);

/// The `yield` token.
final Token $yield = KeywordToken(Keyword.YIELD, 0);

/// The `while` keyword.
final Token $while = KeywordToken(Keyword.WHILE, 0);

// Simple tokens

/// The `&&` token.
final Token $and = Token(TokenType.AMPERSAND_AMPERSAND, 0);

/// The `*` token.
final Token $star = $multiply;

/// The `hide` token.
final Token $hide = KeywordToken(Keyword.HIDE, 0);

/// The `implements` token.
final Token $implements = KeywordToken(Keyword.IMPLEMENTS, 0);

/// The `in` token.
final Token $in = KeywordToken(Keyword.IN, 0);

/// The `is` token.
final Token $is = KeywordToken(Keyword.IS, 0);

/// The `library` token.
final Token $library = KeywordToken(Keyword.LIBRARY, 0);

/// The `<` token.
final Token $lt = Token(TokenType.LT, 0);

/// The `-` token.
final Token $minus = Token(TokenType.MINUS, 0);

/// The `--` token.
final Token $minusMinus = Token(TokenType.MINUS_MINUS, 0);

/// The `*` token.
final Token $multiply = Token(TokenType.STAR, 0);

/// The `new` token.
final Token $ = KeywordToken(Keyword.NEW, 0);

/// The `!` token.
final Token $not = Token(TokenType.BANG, 0);

/// The `!=` token.
final Token $notEquals = Token(TokenType.BANG_EQ, 0);

/// The `null` token.
final Token $null = KeywordToken(Keyword.NULL, 0);

/// The '??=' token.
final Token $nullAwareEquals = Token(TokenType.QUESTION_QUESTION_EQ, 0);

/// The `of` token.
final Token $of = KeywordToken(Keyword.OF, 0);

/// The `||` token.
final Token $or = Token(TokenType.BAR_BAR, 0);

/// The '[` token.
final Token $openBracket = Token(TokenType.OPEN_SQUARE_BRACKET, 0);

/// The '{' token.
final Token $openCurly = Token(TokenType.OPEN_CURLY_BRACKET, 0);

/// The '(' token.
final Token $openParen = Token(TokenType.OPEN_PAREN, 0);

/// The `part` token.
final Token $part = KeywordToken(Keyword.PART, 0);

/// The '.' token.
final Token $period = Token(TokenType.PERIOD, 0);

/// The `+` token.
final Token $plus = Token(TokenType.PLUS, 0);

/// The `++` token.
final Token $plusPlus = Token(TokenType.PLUS_PLUS, 0);

/// The `return` token.
final Token $return = KeywordToken(Keyword.RETURN, 0);

/// The ';' token.
final Token $semicolon = Token(TokenType.SEMICOLON, 0);

/// The `show` token.
final Token $show = KeywordToken(Keyword.SHOW, 0);

/// The `static` token.
final Token $static = KeywordToken(Keyword.STATIC, 0);

/// The `this` token.
final Token $this = KeywordToken(Keyword.THIS, 0);

/// The `throw` token.
final Token $throw = KeywordToken(Keyword.THROW, 0);

/// The `true` token.
final Token $true = KeywordToken(Keyword.TRUE, 0);

/// The `var` token.
final Token $var = KeywordToken(Keyword.VAR, 0);

/// The `with` token.
final Token $with = KeywordToken(Keyword.WITH, 0);

/// The `?` token.
final Token $question = Token(TokenType.QUESTION, 0);

/// Returns an int token for the given int [value].
StringToken intToken(int value) => StringToken(TokenType.INT, '$value', 0);

/// Returns a string token for the given string [s].
StringToken stringToken(String s) => StringToken(TokenType.STRING, s, 0);
