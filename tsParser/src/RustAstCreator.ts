import { CharStream, CommonTokenStream, AbstractParseTreeVisitor } from 'antlr4ng';
import { RustLexer } from './parser/src/RustLexer.js';
import { RustParser } from './parser/src/RustParser.js';
import { RustVisitor } from './parser/src/RustVisitor.js';
import { readFile } from 'fs/promises';
import { normalizeRustAst } from './astToJSON.js';

// Import parser context types
import {
    ImplicitReturnContext,
    ExplicitReturnContext,
    UnaryNegationContext,
    UnaryNotContext,
    BorrowExprContext,
    UnaryToAtomContext,
    FunctionCallContext,
    MacroCallContext,
    ParensExprContext,
    LiteralExprContext,
    IdentExprContext,
    BlockContext,
    IfExprContext
} from './parser/src/RustParser.js';

// Ownership types
type OwnershipType = 'owned' | 'borrowed' | 'mutable_borrowed';
type Mutability = 'mutable' | 'immutable';

interface OwnershipInfo {
    ownership: OwnershipType;
    mutability: Mutability;
}

class SymbolTable {
    private table: Map<string, OwnershipInfo>;
    private parent: SymbolTable | null;

    constructor(parent: SymbolTable | null = null) {
        this.table = new Map();
        this.parent = parent;
    }

    addSymbol(name: string, ownership: OwnershipInfo) {
        this.table.set(name, ownership);
    }

    getSymbol(name: string): OwnershipInfo | undefined {
        const info = this.table.get(name);
        if (info) return info;
        if (this.parent) return this.parent.getSymbol(name);
        return undefined;
    }
}

class RustAstVisitor extends AbstractParseTreeVisitor<any> implements RustVisitor<any> {
    private symbolTable: SymbolTable;

    constructor() {
        super();
        this.symbolTable = new SymbolTable();
    }

    visitProgram(ctx: any): any {
        console.log("Visiting Program");
        return {
            type: 'Program',
            statements: ctx.statement().map((stmt: any) => this.visit(stmt))
        };
    }

    visitStatement(ctx: any): any {
        if (ctx.letDecl()) {
            return this.visit(ctx.letDecl());
        } else if (ctx.fnDecl()) {
            return this.visit(ctx.fnDecl());
        } else if (ctx.whileLoop()) {
            return this.visit(ctx.whileLoop());
        } else if (ctx.ifExpr()) {
            return this.visit(ctx.ifExpr());
        } else if (ctx.block()) {
            return this.visit(ctx.block());
        } else if (ctx.expr()) {
            return this.visit(ctx.expr());
        } else if (ctx.returnExpr()) {
            return this.visit(ctx.returnExpr());
        }
        return null;
    }

    visitLetDecl(ctx: any): any {
        console.log("Visiting Let Declaration");
        const isMutable = ctx.MUT() !== null;
        const name = ctx.IDENTIFIER().getText();
        const ownershipInfo: OwnershipInfo = {
            ownership: 'owned',
            mutability: isMutable ? 'mutable' : 'immutable'
        };
        this.symbolTable.addSymbol(name, ownershipInfo);
        
        return {
            type: 'LetDecl',
            name: name,
            value: ctx.expr() ? this.visit(ctx.expr()) : null,
            ownership: ownershipInfo
        };
    }

    visitFnDecl(ctx: any): any {
        console.log("Visiting Function Declaration");
        const oldTable = this.symbolTable;
        this.symbolTable = new SymbolTable(oldTable);
        
        // Get parameters with their ownership information
        const params = ctx.paramList() ? this.visit(ctx.paramList()) : [];
        
        // Add parameters to symbol table
        params.forEach((param: any) => {
            this.symbolTable.addSymbol(param.name, param.ownership);
        });
        
        const result = {
            type: 'FnDecl',
            name: ctx.IDENTIFIER().getText(),
            params: params,
            returnType: ctx.returnType() ? this.visit(ctx.returnType()) : null,
            body: this.visit(ctx.block())
        };
        
        this.symbolTable = oldTable;
        return result;
    }

    visitParamList(ctx: any): any {
        console.log("Visiting Parameter List");
        return ctx.param().map((param: any) => this.visit(param));
    }

    visitParam(ctx: any): any {
        console.log("Visiting Parameter");
        const name = ctx.IDENTIFIER().getText();
        const isRef = ctx.REF() !== null;
        const isMutable = ctx.MUT() !== null;
        
        let ownershipInfo: OwnershipInfo;
        
        if (isRef) {
            // Reference parameter
            ownershipInfo = {
                ownership: isMutable ? 'mutable_borrowed' : 'borrowed',
                mutability: isMutable ? 'mutable' : 'immutable'
            };
        } else {
            // Owned parameter
            ownershipInfo = {
                ownership: 'owned',
                mutability: isMutable ? 'mutable' : 'immutable'
            };
        }
        
        return {
            type: 'Param',
            name: name,
            paramType: this.visit(ctx.typeExpr()),
            ownership: ownershipInfo
        };
    }

    visitReturnType(ctx: any): any {
        console.log("Visiting Return Type");
        return this.visit(ctx.typeExpr());
    }

    visitWhileLoop(ctx: any): any {
        console.log("Visiting While Loop");
        return {
            type: 'WhileLoop',
            condition: this.visit(ctx.expr()),
            body: this.visit(ctx.block())
        };
    }

    visitBlock(ctx: any): any {
        console.log("Visiting Block");
        // Create new scope
        const oldTable = this.symbolTable;
        this.symbolTable = new SymbolTable(oldTable);
        
        const statements = ctx.statement().map((stmt: any) => this.visit(stmt));
        
        // Restore old scope
        this.symbolTable = oldTable;
        
        return {
            type: 'Block',
            statements: statements
        };
    }

    visitReturnExpr(ctx: any): any {
        console.log("Visiting Return Expression");
        if (ctx instanceof ImplicitReturnContext) {
            return {
                type: 'ReturnExpr',
                expr: this.visit(ctx.expr())
            };
        } else if (ctx instanceof ExplicitReturnContext) {
            return {
                type: 'ReturnExpr',
                expr: this.visit(ctx.expr())
            };
        }
        return null;
    }

    visitIfExpr(ctx: IfExprContext): any {
        console.log("Visiting If Expression");
        return {
            type: 'IfExpr',
            condition: this.visit(ctx.expr()),
            thenBranch: this.visit(ctx.block(0)),
            elseBranch: ctx.block().length > 1 ? this.visit(ctx.block(1)) : null
        };
    }

    visitExpr(ctx: any): any {
        console.log("Visiting Expression");
     
        return this.visit(ctx.exprBinary());
    }

    visitBinaryExpr(ctx: any): any {
        console.log("Visiting Binary Expression");
        if (ctx.exprUnary().length === 1) {
            return this.visit(ctx.exprUnary(0));
        }
        
        const left = this.visit(ctx.exprUnary(0));
        const operators = ctx.binOp();
        const rightExprs = ctx.exprUnary().slice(1);

        let result = left;
        for (let i = 0; i < operators.length; i++) {
            result = {
                type: 'BinaryExpr',
                left: result,
                operator: operators[i].getText(),
                right: this.visit(rightExprs[i])
            };
        }
        return result;
    }

    visitExprUnary(ctx: any): any {
        console.log("Visiting Unary Expression");
        if (ctx instanceof UnaryNegationContext) {
            return {
                type: 'UnaryNegation',
                expr: this.visit(ctx.exprUnary())
            };
        } else if (ctx instanceof UnaryNotContext) {
            return {
                type: 'UnaryNot',
                expr: this.visit(ctx.exprUnary())
            };
        } else if (ctx instanceof BorrowExprContext) {
            return this.visit(ctx.exprUnary());
        } else if (ctx instanceof UnaryToAtomContext) {
            return this.visit(ctx.exprAtom());
        }
        return null;
    }

    visitExprAtom(ctx: any): any {
        console.log("Visiting Expression Atom");
        if (ctx instanceof FunctionCallContext) {
            return {
                type: 'FunctionCall',
                name: ctx.IDENTIFIER().getText(),
                args: ctx.argList() ? this.visit(ctx.argList()) : []
            };
        } else if (ctx instanceof MacroCallContext) {
            return {
                type: 'MacroCall',
                name: ctx.IDENTIFIER().getText(),
                args: ctx.argList() ? this.visit(ctx.argList()) : []
            };
        } else if (ctx instanceof ParensExprContext) {
            return this.visit(ctx.expr());
        } else if (ctx instanceof LiteralExprContext) {
            return this.visit(ctx.literal());
        } else if (ctx instanceof IdentExprContext) {
            const name = ctx.IDENTIFIER().getText();
            const ownershipInfo = this.symbolTable.getSymbol(name);
            return {
                type: 'IdentExpr',
                name: name,
                ownership: ownershipInfo || {
                    ownership: 'owned',
                    mutability: 'immutable'
                }
            };
        }
        return null;
    }

    visitIdentExpr(ctx: IdentExprContext): any {
        console.log("Visiting Identifier Expression");
        const name = ctx.IDENTIFIER().getText();
        const ownershipInfo = this.symbolTable.getSymbol(name);
        
        return {
            type: 'IdentExpr',
            name: name,
            ownership: ownershipInfo || {
                ownership: 'owned',
                mutability: 'immutable'
            }
        };
    }

    visitUnaryToAtom(ctx: UnaryToAtomContext): any {
        console.log("Visiting UnaryToAtom");
        return this.visit(ctx.exprAtom());
    }

    visitArgList(ctx: any): any {
        console.log("Visiting Argument List");
        return ctx.expr().map((expr: any) => this.visit(expr));
    }

    visitRefType(ctx: any): any {
        console.log("Visiting RefType");
        return {
            type: 'RefType',
            mutable: ctx.getText().includes('mut'),
            baseType: ctx.IDENTIFIER().getText()
        };
    }
    
    visitBasicType(ctx: any): any {
        console.log("Visiting BasicType");
        return {
            type: 'BasicType',
            name: ctx.IDENTIFIER().getText()
        };
    }

    visitLiteral(ctx: any): any {
        console.log("Visiting Literal");
        const text = ctx.getText();
        let value: any = text;
        
        if (text.match(/^\d+$/)) {
            value = parseInt(text);
        } else if (text.match(/^\d+\.\d*$/)) {
            value = parseFloat(text);
        } else if (text === 'true' || text === 'false') {
            value = text === 'true';
        } else if (text.startsWith('"')) {
            value = text.slice(1, -1);
        }

        return {
            type: 'Literal',
            value: value
        };
    }

    visitUnaryNegation(ctx: UnaryNegationContext): any {
        console.log("Visiting Unary Negation");
        return {
            type: 'UnaryNegation',
            expr: this.visit(ctx.exprUnary())
        };
    }
    
    visitUnaryNot(ctx: UnaryNotContext): any {
        console.log("Visiting Unary Not");
        return {
            type: 'UnaryNot',
            expr: this.visit(ctx.exprUnary())
        };
    }
    
    visitBorrowExpr(ctx: BorrowExprContext): any {
        console.log("Visiting Borrow Expression");
        const isMutable = ctx.getText().includes('mut');
        return {
            type: 'BorrowExpr',
            ownership: {
                ownership: isMutable ? 'mutable_borrowed' : 'borrowed',
                mutability: isMutable ? 'mutable' : 'immutable'
            },
            expr: this.visit(ctx.exprUnary())
        };
    }
    
    visitFunctionCall(ctx: FunctionCallContext): any {
        console.log("Visiting Function Call");
        return {
            type: 'FunctionCall',
            name: ctx.IDENTIFIER().getText(),
            args: ctx.argList() ? this.visit(ctx.argList()) : []
        };
    }
    
    visitMacroCall(ctx: MacroCallContext): any {
        console.log("Visiting Macro Call");
        return {
            type: 'MacroCall',
            name: ctx.IDENTIFIER().getText(),
            args: ctx.argList() ? this.visit(ctx.argList()) : []
        };
    }
    
    visitParensExpr(ctx: ParensExprContext): any {
        console.log("Visiting Parenthesized Expression");
        return this.visit(ctx.expr());
    }
    
    visitLiteralExpr(ctx: LiteralExprContext): any {
        console.log("Visiting Literal Expression");
        return this.visit(ctx.literal());
    }
    
    protected defaultResult(): any {
        return null;
    }
} 

export class RustAstCreator {
    private visitor: RustAstVisitor;

    constructor() {
        this.visitor = new RustAstVisitor();
    }

    createAst(input: string): any {
        const inputStream = CharStream.fromString(input);
        const lexer = new RustLexer(inputStream);
        const tokenStream = new CommonTokenStream(lexer);
        const parser = new RustParser(tokenStream);
        const tree = parser.program();
        const ast = tree.accept(this.visitor);
        // return normalizeRustAst(ast);
        return ast;
    }

    async createAstFromFile(filePath: string): Promise<any> {
        const content = await readFile(filePath, 'utf-8');
        return this.createAst(content);
    }
}
