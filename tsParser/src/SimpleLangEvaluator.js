import { BasicEvaluator } from "conductor/dist/conductor/runner";
import { CharStream, CommonTokenStream, AbstractParseTreeVisitor } from 'antlr4ng';
import { SimpleLangLexer } from './parser/src/SimpleLangLexer';
import { SimpleLangParser } from './parser/src/SimpleLangParser';
class SimpleLangEvaluatorVisitor extends AbstractParseTreeVisitor {
    // Visit a parse tree produced by SimpleLangParser#prog
    visitProg(ctx) {
        return this.visit(ctx.expression());
    }
    // Visit a parse tree produced by SimpleLangParser#expression
    visitExpression(ctx) {
        if (ctx.getChildCount() === 1) {
            // INT case
            return parseInt(ctx.getText());
        }
        else if (ctx.getChildCount() === 3) {
            if (ctx.getChild(0).getText() === '(' && ctx.getChild(2).getText() === ')') {
                // Parenthesized expression
                return this.visit(ctx.getChild(1));
            }
            else {
                // Binary operation
                const left = this.visit(ctx.getChild(0));
                const op = ctx.getChild(1).getText();
                const right = this.visit(ctx.getChild(2));
                switch (op) {
                    case '+': return left + right;
                    case '-': return left - right;
                    case '*': return left * right;
                    case '/':
                        if (right === 0) {
                            throw new Error("Division by zero");
                        }
                        return left / right;
                    default:
                        throw new Error(`Unknown operator: ${op}`);
                }
            }
        }
        throw new Error(`Invalid expression: ${ctx.getText()}`);
    }
    // Override the default result method from AbstractParseTreeVisitor
    defaultResult() {
        return 0;
    }
    // Override the aggregate result method
    aggregateResult(aggregate, nextResult) {
        return nextResult;
    }
}
export class SimpleLangEvaluator extends BasicEvaluator {
    executionCount;
    visitor;
    constructor(conductor) {
        super(conductor);
        this.executionCount = 0;
        this.visitor = new SimpleLangEvaluatorVisitor();
    }
    async evaluateChunk(chunk) {
        this.executionCount++;
        try {
            // Create the lexer and parser
            const inputStream = CharStream.fromString(chunk);
            const lexer = new SimpleLangLexer(inputStream);
            const tokenStream = new CommonTokenStream(lexer);
            const parser = new SimpleLangParser(tokenStream);
            // Parse the input
            const tree = parser.prog();
            // Evaluate the parsed tree
            const result = this.visitor.visit(tree);
            // Send the result to the REPL
            this.conductor.sendOutput(`Result of expression: ${result}`);
        }
        catch (error) {
            // Handle errors and send them to the REPL
            if (error instanceof Error) {
                this.conductor.sendOutput(`Error: ${error.message}`);
            }
            else {
                this.conductor.sendOutput(`Error: ${String(error)}`);
            }
        }
    }
}
//# sourceMappingURL=SimpleLangEvaluator.js.map