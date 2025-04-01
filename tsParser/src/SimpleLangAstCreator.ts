import { CharStream, CommonTokenStream, AbstractParseTreeVisitor } from 'antlr4ng';
import { SimpleLangLexer } from './parser/src/SimpleLangLexer.js';
import { SimpleLangParser } from './parser/src/SimpleLangParser.js';
import { SimpleLangVisitor } from './parser/src/SimpleLangVisitor.js';
import { readFile } from 'fs/promises';

class SimpleLangAstVisitor extends AbstractParseTreeVisitor<any> implements SimpleLangVisitor<any> {
    visitChildren(node: any): any {
        const result: any = {
            type: node.constructor.name,
            children: []
        };

        for (let i = 0; i < node.getChildCount(); i++) {
            const child = node.getChild(i);
            if (child) {
                result.children.push(this.visit(child));
            }
        }

        return result;
    }

    visitProg(ctx: any): any {
        return {
            type: 'Program',
            expression: this.visit(ctx.expression())
        };
    }

    visitExpression(ctx: any): any {
        if (ctx.getChildCount() === 1) {
            // INT case
            return {
                type: 'Integer',
                value: parseInt(ctx.getText())
            };
        } else if (ctx.getChildCount() === 3) {
            if (ctx.getChild(0).getText() === '(' && ctx.getChild(2).getText() === ')') {
                // Parenthesized expression
                return {
                    type: 'ParenthesizedExpression',
                    expression: this.visit(ctx.getChild(1))
                };
            } else {
                // Binary operation
                return {
                    type: 'BinaryOperation',
                    operator: ctx.getChild(1).getText(),
                    left: this.visit(ctx.getChild(0)),
                    right: this.visit(ctx.getChild(2))
                };
            }
        }
        return this.visitChildren(ctx);
    }

    protected defaultResult(): any {
        return null;
    }
}

export class SimpleLangAstCreator {
    private visitor: SimpleLangAstVisitor;

    constructor() {
        this.visitor = new SimpleLangAstVisitor();
    }

    createAst(input: string): any {
        const inputStream = CharStream.fromString(input);
        const lexer = new SimpleLangLexer(inputStream);
        const tokenStream = new CommonTokenStream(lexer);
        const parser = new SimpleLangParser(tokenStream);
        const tree = parser.prog();
        return this.visitor.visit(tree);
    }

    async createAstFromFile(filePath: string): Promise<any> {
        const content = await readFile(filePath, 'utf-8');
        return this.createAst(content);
    }
} 