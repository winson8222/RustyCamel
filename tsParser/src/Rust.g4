grammar Rust;

// === Entry Point ===
program: statement* EOF;

// === Statements ===
statement
    : letDecl ';'
    | assignment ';'           // <— new top-level assignment
    | fnDecl
    | whileLoop
    | ifExpr
    | block
    | expr ';'                 // ← other expressions as statements
    ;

// === Let Declaration ===
letDecl
    : 'let' MUT? IDENTIFIER (':' typeExpr)? ('=' expr)?
    ;

// === Assignment Statement (not an expression)
assignment
    : IDENTIFIER '=' expr      #AssignmentStmt
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
    : '{' statement* '}'
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
    | RETURN expr                      #ReturnExpr
    | REF MUT? exprUnary               #BorrowExpr
    | '*' exprUnary                    #DerefExpr   
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
    : REF MUT? typeExpr                #RefType
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
RETURN: 'return';
MUT: 'mut';
REF: '&';
IDENTIFIER: [a-zA-Z_][a-zA-Z0-9_]*;
INT: [0-9]+;
FLOAT: [0-9]+ '.' [0-9]*;
STRING: '"' (~["\\] | '\\' .)* '"';

WS: [ \t\r\n]+ -> skip;
COMMENT: '//' ~[\r\n]* -> skip;