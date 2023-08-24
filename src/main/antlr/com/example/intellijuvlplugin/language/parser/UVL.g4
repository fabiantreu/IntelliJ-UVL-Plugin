//grammar UVL;
//
//tokens { INDENT, DEDENT }
//
//@lexer::members {
//  // A queue where extra tokens are pushed on (see the NEWLINE lexer rule).
//  private java.util.LinkedList<Token> tokens = new java.util.LinkedList<>();
//  // The stack that keeps track of the indentation level.
//  private java.util.Stack<Integer> indents = new java.util.Stack<>();
//  // The amount of opened braces, brackets and parenthesis.
//  private int opened = 0;
//  // The most recently produced token.
//  private Token lastToken = null;
//  @Override
//  public void emit(Token t) {
//    super.setToken(t);
//    tokens.offer(t);
//  }
//
//  @Override
//  public Token nextToken() {
//    // Check if the end-of-file is ahead and there are still some DEDENTS expected.
//    if (_input.LA(1) == EOF && !this.indents.isEmpty()) {
//      // Remove any trailing EOF tokens from our buffer.
//      for (int i = tokens.size() - 1; i >= 0; i--) {
//        if (tokens.get(i).getType() == EOF) {
//          tokens.remove(i);
//        }
//      }
//
//      // First emit an extra line break that serves as the end of the statement.
//      this.emit(commonToken(UVLParser.NEWLINE, "\n"));
//
//      // Now emit as much DEDENT tokens as needed.
//      while (!indents.isEmpty()) {
//        this.emit(createDedent());
//        indents.pop();
//      }
//
//      // Put the EOF back on the token stream.
//      this.emit(commonToken(UVLParser.EOF, "<EOF>"));
//    }
//
//    Token next = super.nextToken();
//
//    if (next.getChannel() == Token.DEFAULT_CHANNEL) {
//      // Keep track of the last token on the default channel.
//      this.lastToken = next;
//    }
//
//    return tokens.isEmpty() ? next : tokens.poll();
//  }
//
//  private Token createDedent() {
//    CommonToken dedent = commonToken(UVLParser.DEDENT, "");
//    dedent.setLine(this.lastToken.getLine());
//    return dedent;
//  }
//
//  private CommonToken commonToken(int type, String text) {
//    int stop = this.getCharIndex() - 1;
//    int start = text.isEmpty() ? stop : stop - text.length() + 1;
//    return new CommonToken(this._tokenFactorySourcePair, type, DEFAULT_TOKEN_CHANNEL, start, stop);
//  }
//
//  // Calculates the indentation of the provided spaces, taking the
//  // following rules into account:
//  //
//  // "Tabs are replaced (from left to right) by one to eight spaces
//  //  such that the total number of characters up to and including
//  //  the replacement is a multiple of eight [...]"
//  //
//  //  -- https://docs.python.org/3.1/reference/lexical_analysis.html#indentation
//  static int getIndentationCount(String spaces) {
//    int count = 0;
//    for (char ch : spaces.toCharArray()) {
//      switch (ch) {
//        case '\t':
//          count += 8 - (count % 8);
//          break;
//        default:
//          // A normal space char.
//          count++;
//      }
//    }
//
//    return count;
//  }
//
//  boolean atStartOfInput() {
//    return super.getCharPositionInLine() == 0 && super.getLine() == 1;
//  }
//}
//
//featureModel: namespace? NEWLINE? includes? NEWLINE? imports? NEWLINE? features? NEWLINE? constraints? EOF;
//
//includes: 'include' NEWLINE INDENT includeLine* DEDENT;
//includeLine: languageLevel NEWLINE;
//
//namespace: 'namespace' reference;
//
//imports: 'imports' NEWLINE INDENT importLine* DEDENT;
//importLine: ns=reference ('as' alias=reference)? NEWLINE;
//
//features: 'features' NEWLINE INDENT feature DEDENT;
//
//group
//    : ORGROUP groupSpec          # OrGroup
//    | ALTERNATIVE groupSpec # AlternativeGroup
//    | OPTIONAL groupSpec    # OptionalGroup
//    | MANDATORY groupSpec   # MandatoryGroup
//    | CARDINALITY groupSpec    # CardinalityGroup
//    ;
//
//groupSpec: NEWLINE INDENT feature+ DEDENT;
//
//feature: featureType? reference featureCardinality? attributes? NEWLINE (INDENT group+ DEDENT)?;
//
//featureCardinality: 'cardinality' CARDINALITY;
//
//attributes: OPEN_BRACE (attribute (COMMA attribute)*)? CLOSE_BRACE;
//
//attribute
//    : valueAttribute
//    | constraintAttribute;
//
//valueAttribute: key value?;
//
//key: id;
//value: BOOLEAN | FLOAT | INTEGER | STRING | attributes | vector;
//vector: OPEN_BRACK (value (COMMA value)*)? CLOSE_BRACK;
//
//constraintAttribute
//    : 'constraint' constraint               # SingleConstraintAttribute
//    | 'constraints' constraintList          # ListConstraintAttribute
//    ;
//constraintList: OPEN_BRACK (constraint (COMMA constraint)*)? CLOSE_BRACK;
//
//constraints: 'constraints' NEWLINE INDENT constraintLine* DEDENT;
//
//constraintLine: constraint NEWLINE;
//
//constraint
//    : equation                              # EquationConstraint
//    | reference                             # LiteralConstraint
//    | OPEN_PAREN constraint CLOSE_PAREN     # ParenthesisConstraint
//    | NOT constraint                        # NotConstraint
//    | constraint AND constraint             # AndConstraint
//    | constraint OR constraint              # OrConstraint
//    | constraint IMPLICATION constraint     # ImplicationConstraint
//    | constraint EQUIVALENCE constraint     # EquivalenceConstraint
//	;
//
//equation
//    : expression EQUAL expression           # EqualEquation
//    | expression LOWER expression           # LowerEquation
//    | expression GREATER expression         # GreaterEquation
//    | expression LOWER_EQUALS expression    # LowerEqualsEquation
//    | expression GREATER_EQUALS expression  # GreaterEqualsEquation
//    | expression NOT_EQUALS expression      # NotEqualsEquation
//    ;
//
//expression:
//    FLOAT                                   # FloatLiteralExpression
//    | INTEGER                               # IntegerLiteralExpression
//    | STRING                                # StringLiteralExpression
//    | aggregateFunction                     # AggregateFunctionExpression
//    | reference                             # LiteralExpression
//    | OPEN_PAREN expression CLOSE_PAREN     # BracketExpression
//    | expression ADD expression             # AddExpression
//    | expression SUB expression             # SubExpression
//    | expression MUL expression             # MulExpression
//    | expression DIV expression             # DivExpression
//    ;
//
//aggregateFunction
//    : 'sum' OPEN_PAREN (reference COMMA)? reference CLOSE_PAREN    # SumAggregateFunction
//    | 'avg' OPEN_PAREN (reference COMMA)? reference CLOSE_PAREN    # AvgAggregateFunction
//    | stringAggregateFunction                                      # StringAggregateFunctionExpression
//    | numericAggregateFunction                                     # NumericAggregateFunctionExpression
//    ;
//
//stringAggregateFunction
//    : 'len' OPEN_PAREN reference CLOSE_PAREN        # LengthAggregateFunction
//    ;
//
//numericAggregateFunction
//    : 'floor' OPEN_PAREN reference CLOSE_PAREN      # FloorAggregateFunction
//    | 'ceil' OPEN_PAREN reference CLOSE_PAREN       # CeilAggregateFunction
//    ;
//
//reference: (id '.')* id;
//id: ID_STRICT | ID_NOT_STRICT;
//featureType: 'String' | 'Integer' | BOOLEAN_KEY | 'Real';
//
//
//
//languageLevel: majorLevel ('.' (minorLevel | '*'))?;
//majorLevel: BOOLEAN_KEY | 'Arithmetic' | 'Type';
//minorLevel: 'group-cardinality' | 'feature-cardinality' | 'aggregate-function' | 'string-constraints';
//
//ORGROUP: 'or';
//ALTERNATIVE: 'alternative';
//OPTIONAL: 'optional';
//MANDATORY: 'mandatory';
//CARDINALITY: OPEN_BRACK INTEGER ('..' (INTEGER | '*'))? CLOSE_BRACK;
//
//NOT: '!';
//AND: '&';
//OR: '|';
//EQUIVALENCE: '<=>';
//IMPLICATION: '=>';
//
//EQUAL: '==';
//LOWER: '<';
//LOWER_EQUALS: '<=';
//GREATER: '>';
//GREATER_EQUALS: '>=';
//NOT_EQUALS: '!=';
//
//DIV: '/';
//MUL: '*';
//ADD: '+';
//SUB: '-';
//
//FLOAT: '-'?[0-9]*[.][0-9]+;
//INTEGER: '0' | '-'?[1-9][0-9]*;
//BOOLEAN: 'true' | 'false';
//
//BOOLEAN_KEY : 'Boolean';
//
//COMMA: ',';
//
//OPEN_PAREN : '(' {this.opened += 1;};
//CLOSE_PAREN : ')' {this.opened -= 1;};
//OPEN_BRACK : '[' {this.opened += 1;};
//CLOSE_BRACK : ']' {this.opened -= 1;};
//OPEN_BRACE : '{' {this.opened += 1;};
//CLOSE_BRACE : '}' {this.opened -= 1;};
//OPEN_COMMENT: '/*' {this.opened += 1;};
//CLOSE_COMMENT: '*/' {this.opened -= 1;};
//
//ID_NOT_STRICT: '"'~[\r\n".]+'"';
//ID_STRICT: [a-zA-Z]([a-zA-Z0-9_] | '#' | '§' | '%' | '?' | '\\' | '\'' | 'ä' | 'ü' | 'ö' | 'ß' | ';')*;
//
//STRING: '\''~[\r\n'.]+'\'';
//
//NEWLINE
// : ( {atStartOfInput()}?   SPACES
//   | ( '\r'? '\n' | '\r' ) SPACES?
//   )
//   {
//     String newLine = getText().replaceAll("[^\r\n]+", "");
//     String spaces = getText().replaceAll("[\r\n]+", "");
//     int next = _input.LA(1);
//     int nextNext = _input.LA(1);
//
//     if (opened > 0 || next == '\r' || next == '\n' || next == '/' && nextNext == '/') {
//       // If we're inside a list or on a blank line, ignore all indents,
//       // dedents and line breaks.
//       skip();
//     } else {
//       emit(commonToken(NEWLINE, newLine));
//       int indent = getIndentationCount(spaces);
//       int previous = indents.isEmpty() ? 0 : indents.peek();
//       if (indent == previous) {
//         // skip indents of the same size as the present indent-size
//         skip();
//       }
//       else if (indent > previous) {
//         indents.push(indent);
//         emit(commonToken(UVLParser.INDENT, spaces));
//       }
//       else {
//         // Possibly emit more than 1 DEDENT token.
//         while(!indents.isEmpty() && indents.peek() > indent) {
//           this.emit(createDedent());
//           indents.pop();
//         }
//       }
//     }
//   }
// ;
//
//SKIP_
//  : ( SPACES | COMMENT ) -> skip
//  ;
//
// fragment COMMENT
//  : '//' ~[\r\n\f]*
//  | OPEN_COMMENT .* CLOSE_COMMENT
//  ;
//
//  fragment SPACES
//   : [ \t]+
//   ;


















/** A simple language for use with this sample plugin.
 *  It's C-like but without semicolons. Symbol resolution semantics are
 *  C-like: resolve symbol in current scope. If not in this scope, ask
 *  enclosing scope to resolve (recurse up tree until no more scopes or found).
 *  Forward refs allowed for functions but not variables. Globals must
 *  appear first syntactically.
 *
 *  Generate the parser via "mvn compile" from root dir of project.
 */
grammar UVL; // CHANGED TO MAKE IT WORK WITH MY CODE

/** The start rule must be whatever you would normally use, such as script
 *  or compilationUnit, etc...
 */
script
	:	vardef* function* statement* EOF
	;

function
	:	'func' ID '(' formal_args? ')' (':' type)? block
	;

formal_args : formal_arg (',' formal_arg)* ;

formal_arg : ID ':' type ;

type:	'int'                                               # IntTypeSpec
	|	'float'                                             # FloatTypeSpec
	|	'string'                                            # StringTypeSpec
	|	'boolean'											# BooleanTypeSpec
	|	'[' ']'                                             # VectorTypeSpec
	;

block
	:  '{' (statement|vardef)* '}';

statement
	:	'if' '(' expr ')' statement ('else' statement)?		# If
	|	'while' '(' expr ')' statement						# While
	|	ID '=' expr											# Assign
	|	ID '[' expr ']' '=' expr							# ElementAssign
	|	call_expr											# CallStatement
	|	'print' '(' expr? ')'								# Print
	|	'return' expr										# Return
	|	block				 								# BlockStatement
	;

vardef : 'var' ID '=' expr ;

expr
	:	expr operator expr									# Op
	|	'-' expr											# Negate
	|	'!' expr											# Not
	|	call_expr											# Call
	|	ID '[' expr ']'										# Index
	|	'(' expr ')'										# Parens
	|	primary												# Atom
	;

operator  : MUL|DIV|ADD|SUB|GT|GE|LT|LE|EQUAL_EQUAL|NOT_EQUAL|OR|AND|DOT ; // no implicit precedence

call_expr
	: ID '(' expr_list? ')' ;

expr_list : expr (',' expr)* ;

primary
	:	ID													# Identifier
	|	INT													# Integer
	|	FLOAT												# Float
	|	STRING												# String
	|	'[' expr_list ']'									# Vector
	|	'true'												# TrueLiteral
	|	'false'												# FalseLiteral
	;

LPAREN : '(' ;
RPAREN : ')' ;
COLON : ':' ;
COMMA : ',' ;
LBRACK : '[' ;
RBRACK : ']' ;
LBRACE : '{' ;
RBRACE : '}' ;
IF : 'if' ;
ELSE : 'else' ;
WHILE : 'while' ;
VAR : 'var' ;
EQUAL : '=' ;
RETURN : 'return' ;
PRINT : 'print' ;
FUNC : 'func' ;
TYPEINT : 'int' ;
TYPEFLOAT : 'float' ;
TYPESTRING : 'string' ;
TYPEBOOLEAN : 'boolean' ;
TRUE : 'true' ;
FALSE : 'false' ;
SUB : '-' ;
BANG : '!' ;
MUL : '*' ;
DIV : '/' ;
ADD : '+' ;
LT : '<' ;
LE : '<=' ;
EQUAL_EQUAL : '==' ;
NOT_EQUAL : '!=' ;
GT : '>' ;
GE : '>=' ;
OR : '||' ;
AND : '&&' ;
DOT : ' . ' ;

LINE_COMMENT : '//' .*? ('\n'|EOF)	-> channel(HIDDEN) ;
COMMENT      : '/*' .*? '*/'    	-> channel(HIDDEN) ;

ID  : [a-zA-Z_] [a-zA-Z0-9_]* ;
INT : [0-9]+ ;
FLOAT
	:   '-'? INT '.' INT EXP?   // 1.35, 1.35E-9, 0.3, -4.5
	|   '-'? INT EXP            // 1e10 -3e4
	;
fragment EXP :   [Ee] [+\-]? INT ;

STRING :  '"' (ESC | ~["\\])* '"' ;
fragment ESC :   '\\' ["\bfnrt] ;

WS : [ \t\n\r]+ -> channel(HIDDEN) ;

/** "catch all" rule for any char not matche in a token rule of your
 *  grammar. Lexers in Intellij must return all tokens good and bad.
 *  There must be a token to cover all characters, which makes sense, for
 *  an IDE. The parser however should not see these bad tokens because
 *  it just confuses the issue. Hence, the hidden channel.
 */
ERRCHAR
	:	.	-> channel(HIDDEN)
	;














///*
// * High Performance Knowledge Based Configuration Techniques
// *
// * Copyright (c) 2022-2023
// *
// * @author: Viet-Man Le (vietman.le@ist.tugraz.at)
// */
//
//grammar UVL;
////import CommonLexer;
//
//@lexer::header {
//}
//
///*********************************************
// * KEYWORDS
// **********************************************/
//
//FM4CONFversion : 'FM4Conf-v1.0';
//
//MODELNAME : 'MODEL';
//FEATURE : 'FEATURES';
//RELATIONSHIP : 'RELATIONSHIPS';
//CONSTRAINT : 'CONSTRAINTS';
//
//MANDATORY : 'mandatory';
//OPTIONAL : 'optional';
//ALTERNATIVE : 'alternative';
//OR : 'or';
//REQUIRES : 'requires';
//EXCLUDES : 'excludes';
//
////DD:'..';
////DO:'.';
//CM:',';
//
////PL:'+';
////MN:'-';
//SC:';';
//CL:':';
////DC:'::';
//LP:'(';
//RP:')';
//
///*********************************************
// * GENERAL
// **********************************************/
//
//NAME : ID ( SPACE ID )* ;
//
//COMMENT
//    :   '%' ~('\n'|'\r')* '\n' -> skip
//    ;
//
//WS  :   ( ' '
//        | '\t'
//        | '\r'
//        | '\n'
//        ) -> skip
//    ; // toss out whitespace
//
///*********************************************
// * FRAGMENTS
// **********************************************/
//
//fragment ID : ID_HEAD ID_TAIL* ;
//fragment ID_HEAD : LETTER ;
//fragment ID_TAIL : LETTER | DIGIT;
//fragment LETTER : [a-zA-Z_-] ;
//fragment DIGIT : [0-9] ;
//fragment SPACE : ' '+ ;
//
//model : fm4confver modelname feature? relationship? constraint?;
//
//fm4confver : FM4CONFversion;
//
//modelname : MODELNAME CL identifier;
//
//feature : FEATURE CL identifier (CM identifier)*;
//
//relationship: RELATIONSHIP CL relationshiprule (CM relationshiprule)*;
//
//constraint: CONSTRAINT CL constraintrule (CM constraintrule)*;
//
//identifier: NAME;
//
//relationshiprule : MANDATORY LP identifier CM identifier RP         # mandatory
//                 | OPTIONAL LP identifier CM identifier RP          # optional
//                 | ALTERNATIVE LP identifier (CM identifier)+ RP    # alternative
//                 | OR LP identifier (CM identifier)+ RP             # or
//                 ;
//
//constraintrule : REQUIRES LP identifier CM identifier RP            # requires
//                 | EXCLUDES LP identifier CM identifier RP          # excludes
//                 ;