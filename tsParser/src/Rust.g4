grammar Rust;

// === Entry Point ===
program: statement* EOF;

// === Statements ===
statement
    : letDecl ';'
    | fnDecl
    | whileLoop
    | ifExpr
    | block
    | expr ';'   // ← this allows expressions as standalone statements
    | returnExpr
    ;

// === Let Declaration ===
letDecl
    : 'let' 'mut'? IDENTIFIER (':' typeExpr)? ('=' expr)?
    ;

// === Function Declaration ===
fnDecl: 'fn' IDENTIFIER '(' paramList? ')' returnType? block;

paramList: param (',' param)*;
param: IDENTIFIER ':' typeExpr;
returnType: '->' typeExpr;

// === While Loop ===
whileLoop: 'while' expr block;

// === Block ===
block
    : '{' statement* returnExpr? '}'
    ;

returnExpr
    : expr                             #ImplicitReturn
    | expr ';'                         #ExplicitReturn
    ;

// === If Expression ===
ifExpr: 'if' expr block ('else' block)?;

// === Expressions (with precedence climbing) ===
expr
    : exprBinary
    ;

exprBinary
    : exprUnary (binOp exprUnary)*     #BinaryExpr
    ;

exprUnary
    : '-' exprUnary                    #UnaryNegation
    | '!' exprUnary                    #UnaryNot
    | '&' 'mut'? exprUnary             #BorrowExpr
    | exprAtom                         #UnaryToAtom
    ;

exprAtom
    : IDENTIFIER '(' argList? ')'      #FunctionCall
    | IDENTIFIER '!' '(' argList? ')'  #MacroCall
    | '(' expr ')'                     #ParensExpr
    | literal                          #LiteralExpr
    | IDENTIFIER                       #IdentExpr
    ;

argList: expr (',' expr)*;

binOp: '+' | '-' | '*' | '/' | '==' | '!=' | '<' | '<=' | '>' | '>=';

// === Types ===
typeExpr
    : '&' 'mut'? IDENTIFIER            #RefType
    | IDENTIFIER                       #BasicType
    ;

// === Literals ===
literal
    : INT
    | FLOAT
    | STRING
    | 'true'
    | 'false'
    ;

// === Lexer Rules ===
IDENTIFIER: [a-zA-Z_][a-zA-Z0-9_]*;

INT: [0-9]+;
FLOAT: [0-9]+ '.' [0-9]*;
STRING: '"' (~["\\] | '\\' .)* '"';

WS: [ \t\r\n]+ -> skip;
COMMENT: '//' ~[\r\n]* -> skip;