import { CharStream, CommonTokenStream, AbstractParseTreeVisitor } from 'antlr4ng';
import { RustLexer } from './parser/src/RustLexer.js';
import { RustParser } from './parser/src/RustParser.js';
import { readFile } from 'fs/promises';
// Import parser context types
import { ImplicitReturnContext, ExplicitReturnContext, UnaryNegationContext, UnaryNotContext, BorrowExprContext, UnaryToAtomContext, FunctionCallContext, MacroCallContext, ParensExprContext, LiteralExprContext, IdentExprContext } from './parser/src/RustParser.js';
class RustAstVisitor extends AbstractParseTreeVisitor {
    // visitChildren(node: any): any {
    //     console.log("Visiting children of:", node.constructor.name);
    //     const result: any = {
    //         type: node.constructor.name,
    //         children: []
    //     };
    //     for (let i = 0; i < node.getChildCount(); i++) {
    //         const child = node.getChild(i);
    //         if (child) {
    //             const childResult = this.visit(child);
    //             if (childResult !== null) {
    //                 result.children.push(childResult);
    //             }
    //         }
    //     }
    //     // If there are no children, include the text content
    //     if (result.children.length === 0 && node.getText()) {
    //         result.text = node.getText();
    //     }
    //     return result;
    // }
    visitProgram(ctx) {
        console.log("Visiting Program");
        return {
            type: 'Program',
            statements: ctx.statement().map((stmt) => this.visit(stmt))
        };
    }
    visitStatement(ctx) {
        if (ctx.letDecl()) {
            return this.visit(ctx.letDecl());
        }
        else if (ctx.fnDecl()) {
            return this.visit(ctx.fnDecl());
        }
        else if (ctx.whileLoop()) {
            return this.visit(ctx.whileLoop());
        }
        else if (ctx.ifExpr()) {
            return this.visit(ctx.ifExpr());
        }
        else if (ctx.block()) {
            return this.visit(ctx.block());
        }
        else if (ctx.expr()) {
            return this.visit(ctx.expr()); // ← this line is catching it
        }
        else if (ctx.returnExpr()) {
            return this.visit(ctx.returnExpr());
        }
        return null;
    }
    visitLetDecl(ctx) {
        console.log("Visiting Let Declaration");
        return {
            type: 'LetDecl',
            name: ctx.IDENTIFIER().getText(),
            value: ctx.expr() ? this.visit(ctx.expr()) : null
        };
    }
    visitFnDecl(ctx) {
        console.log("Visiting Function Declaration");
        return {
            type: 'FnDecl',
            name: ctx.IDENTIFIER().getText(),
            params: ctx.paramList() ? this.visit(ctx.paramList()) : [],
            returnType: ctx.returnType() ? this.visit(ctx.returnType()) : null,
            body: this.visit(ctx.block())
        };
    }
    visitParamList(ctx) {
        console.log("Visiting Parameter List");
        return ctx.param().map((param) => this.visit(param));
    }
    visitParam(ctx) {
        console.log("Visiting Parameter");
        return {
            type: 'Param',
            name: ctx.IDENTIFIER().getText(),
            paramType: this.visit(ctx.typeExpr())
        };
    }
    visitReturnType(ctx) {
        console.log("Visiting Return Type");
        return this.visit(ctx.typeExpr());
    }
    visitWhileLoop(ctx) {
        console.log("Visiting While Loop");
        return {
            type: 'WhileLoop',
            condition: this.visit(ctx.expr()),
            body: this.visit(ctx.block())
        };
    }
    visitBlock(ctx) {
        console.log("Visiting Block");
        const statements = ctx.statement().map((stmt) => this.visit(stmt));
        return {
            type: 'Block',
            statements: statements
        };
    }
    visitReturnExpr(ctx) {
        console.log("Visiting Return Expression");
        if (ctx instanceof ImplicitReturnContext) {
            return {
                type: 'ReturnExpr',
                expr: this.visit(ctx.expr())
            };
        }
        else if (ctx instanceof ExplicitReturnContext) {
            return {
                type: 'ReturnExpr',
                expr: this.visit(ctx.expr())
            };
        }
        return null;
    }
    visitIfExpr(ctx) {
        console.log("Visiting If Expression");
        return {
            type: 'IfExpr',
            condition: this.visit(ctx.expr()),
            thenBranch: this.visit(ctx.block(0)),
            elseBranch: ctx.block().length > 1 ? this.visit(ctx.block(1)) : null
        };
    }
    visitExpr(ctx) {
        console.log("Visiting Expression");
        return this.visit(ctx.exprBinary());
    }
    visitBinaryExpr(ctx) {
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
    visitExprUnary(ctx) {
        console.log("Visiting Unary Expression");
        if (ctx instanceof UnaryNegationContext) {
            return {
                type: 'UnaryNegation',
                expr: this.visit(ctx.exprUnary())
            };
        }
        else if (ctx instanceof UnaryNotContext) {
            return {
                type: 'UnaryNot',
                expr: this.visit(ctx.exprUnary())
            };
        }
        else if (ctx instanceof BorrowExprContext) {
            return {
                type: 'BorrowExpr',
                mutable: ctx.getText().includes('mut'),
                expr: this.visit(ctx.exprUnary())
            };
        }
        else if (ctx instanceof UnaryToAtomContext) {
            return this.visit(ctx.exprAtom());
        }
        return null;
    }
    visitExprAtom(ctx) {
        console.log("Visiting Expression Atom");
        if (ctx instanceof FunctionCallContext) {
            return {
                type: 'FunctionCall',
                name: ctx.IDENTIFIER().getText(),
                args: ctx.argList() ? this.visit(ctx.argList()) : []
            };
        }
        else if (ctx instanceof MacroCallContext) {
            return {
                type: 'MacroCall',
                name: ctx.IDENTIFIER().getText(),
                args: ctx.argList() ? this.visit(ctx.argList()) : []
            };
        }
        else if (ctx instanceof ParensExprContext) {
            return this.visit(ctx.expr());
        }
        else if (ctx instanceof LiteralExprContext) {
            return this.visit(ctx.literal());
        }
        else if (ctx instanceof IdentExprContext) {
            return {
                type: 'IdentExpr',
                name: ctx.IDENTIFIER().getText()
            };
        }
        return null;
    }
    visitIdentExpr(ctx) {
        console.log("Visiting Identifier Expression");
        return {
            type: 'IdentExpr',
            name: ctx.IDENTIFIER().getText()
        };
    }
    visitUnaryToAtom(ctx) {
        console.log("Visiting UnaryToAtom");
        return this.visit(ctx.exprAtom());
    }
    visitArgList(ctx) {
        console.log("Visiting Argument List");
        return ctx.expr().map((expr) => this.visit(expr));
    }
    visitRefType(ctx) {
        console.log("Visiting RefType");
        return {
            type: 'RefType',
            mutable: ctx.getText().includes('mut'),
            baseType: ctx.IDENTIFIER().getText()
        };
    }
    visitBasicType(ctx) {
        console.log("Visiting BasicType");
        return {
            type: 'BasicType',
            name: ctx.IDENTIFIER().getText()
        };
    }
    visitLiteral(ctx) {
        console.log("Visiting Literal");
        const text = ctx.getText();
        let value = text;
        if (text.match(/^\d+$/)) {
            value = parseInt(text);
        }
        else if (text.match(/^\d+\.\d*$/)) {
            value = parseFloat(text);
        }
        else if (text === 'true' || text === 'false') {
            value = text === 'true';
        }
        else if (text.startsWith('"')) {
            value = text.slice(1, -1);
        }
        return {
            type: 'Literal',
            value: value
        };
    }
    visitUnaryNegation(ctx) {
        console.log("Visiting Unary Negation");
        return {
            type: 'UnaryNegation',
            expr: this.visit(ctx.exprUnary())
        };
    }
    visitUnaryNot(ctx) {
        console.log("Visiting Unary Not");
        return {
            type: 'UnaryNot',
            expr: this.visit(ctx.exprUnary())
        };
    }
    visitBorrowExpr(ctx) {
        console.log("Visiting Borrow Expression");
        return {
            type: 'BorrowExpr',
            mutable: ctx.getText().includes('mut'),
            expr: this.visit(ctx.exprUnary())
        };
    }
    visitFunctionCall(ctx) {
        console.log("Visiting Function Call");
        return {
            type: 'FunctionCall',
            name: ctx.IDENTIFIER().getText(),
            args: ctx.argList() ? this.visit(ctx.argList()) : []
        };
    }
    visitMacroCall(ctx) {
        console.log("Visiting Macro Call");
        return {
            type: 'MacroCall',
            name: ctx.IDENTIFIER().getText(),
            args: ctx.argList() ? this.visit(ctx.argList()) : []
        };
    }
    visitParensExpr(ctx) {
        console.log("Visiting Parenthesized Expression");
        return this.visit(ctx.expr());
    }
    visitLiteralExpr(ctx) {
        console.log("Visiting Literal Expression");
        return this.visit(ctx.literal());
    }
    defaultResult() {
        return null;
    }
}
export class RustAstCreator {
    constructor() {
        this.visitor = new RustAstVisitor();
    }
    createAst(input) {
        const inputStream = CharStream.fromString(input);
        const lexer = new RustLexer(inputStream);
        const tokenStream = new CommonTokenStream(lexer);
        const parser = new RustParser(tokenStream);
        const tree = parser.program();
        const ast = tree.accept(this.visitor);
        // return normalizeRustAst(ast);
        return ast;
    }
    async createAstFromFile(filePath) {
        const content = await readFile(filePath, 'utf-8');
        return this.createAst(content);
    }
}
//# sourceMappingURL=RustAstCreator.js.map