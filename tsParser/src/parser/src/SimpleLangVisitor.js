// Generated from src/SimpleLang.g4 by ANTLR 4.13.1
import { AbstractParseTreeVisitor } from "antlr4ng";
/**
 * This interface defines a complete generic visitor for a parse tree produced
 * by `SimpleLangParser`.
 *
 * @param <Result> The return type of the visit operation. Use `void` for
 * operations with no return type.
 */
export class SimpleLangVisitor extends AbstractParseTreeVisitor {
    /**
     * Visit a parse tree produced by `SimpleLangParser.prog`.
     * @param ctx the parse tree
     * @return the visitor result
     */
    visitProg;
    /**
     * Visit a parse tree produced by `SimpleLangParser.expression`.
     * @param ctx the parse tree
     * @return the visitor result
     */
    visitExpression;
}
//# sourceMappingURL=SimpleLangVisitor.js.map