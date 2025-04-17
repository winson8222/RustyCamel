// Generated from src/Rust.g4 by ANTLR 4.13.1

import { AbstractParseTreeVisitor } from "antlr4ng";


import { ProgramContext } from "./RustParser.js";
import { StatementContext } from "./RustParser.js";
import { LetDeclContext } from "./RustParser.js";
import { FnDeclContext } from "./RustParser.js";
import { ParamListContext } from "./RustParser.js";
import { ParamContext } from "./RustParser.js";
import { ReturnTypeContext } from "./RustParser.js";
import { WhileLoopContext } from "./RustParser.js";
import { BlockContext } from "./RustParser.js";
import { IfExprContext } from "./RustParser.js";
import { ExprContext } from "./RustParser.js";
import { BinaryExprContext } from "./RustParser.js";
import { UnaryNegationContext } from "./RustParser.js";
import { UnaryNotContext } from "./RustParser.js";
import { ReturnExprContext } from "./RustParser.js";
import { BorrowExprContext } from "./RustParser.js";
import { DerefExprContext } from "./RustParser.js";
import { UnaryToAtomContext } from "./RustParser.js";
import { FunctionCallContext } from "./RustParser.js";
import { MacroCallContext } from "./RustParser.js";
import { ParensExprContext } from "./RustParser.js";
import { LiteralExprContext } from "./RustParser.js";
import { IdentExprContext } from "./RustParser.js";
import { ArgListContext } from "./RustParser.js";
import { BinOpContext } from "./RustParser.js";
import { RefTypeContext } from "./RustParser.js";
import { BasicTypeContext } from "./RustParser.js";
import { LiteralContext } from "./RustParser.js";


/**
 * This interface defines a complete generic visitor for a parse tree produced
 * by `RustParser`.
 *
 * @param <Result> The return type of the visit operation. Use `void` for
 * operations with no return type.
 */
export class RustVisitor<Result> extends AbstractParseTreeVisitor<Result> {
    /**
     * Visit a parse tree produced by `RustParser.program`.
     * @param ctx the parse tree
     * @return the visitor result
     */
    visitProgram?: (ctx: ProgramContext) => Result;
    /**
     * Visit a parse tree produced by `RustParser.statement`.
     * @param ctx the parse tree
     * @return the visitor result
     */
    visitStatement?: (ctx: StatementContext) => Result;
    /**
     * Visit a parse tree produced by `RustParser.letDecl`.
     * @param ctx the parse tree
     * @return the visitor result
     */
    visitLetDecl?: (ctx: LetDeclContext) => Result;
    /**
     * Visit a parse tree produced by `RustParser.fnDecl`.
     * @param ctx the parse tree
     * @return the visitor result
     */
    visitFnDecl?: (ctx: FnDeclContext) => Result;
    /**
     * Visit a parse tree produced by `RustParser.paramList`.
     * @param ctx the parse tree
     * @return the visitor result
     */
    visitParamList?: (ctx: ParamListContext) => Result;
    /**
     * Visit a parse tree produced by `RustParser.param`.
     * @param ctx the parse tree
     * @return the visitor result
     */
    visitParam?: (ctx: ParamContext) => Result;
    /**
     * Visit a parse tree produced by `RustParser.returnType`.
     * @param ctx the parse tree
     * @return the visitor result
     */
    visitReturnType?: (ctx: ReturnTypeContext) => Result;
    /**
     * Visit a parse tree produced by `RustParser.whileLoop`.
     * @param ctx the parse tree
     * @return the visitor result
     */
    visitWhileLoop?: (ctx: WhileLoopContext) => Result;
    /**
     * Visit a parse tree produced by `RustParser.block`.
     * @param ctx the parse tree
     * @return the visitor result
     */
    visitBlock?: (ctx: BlockContext) => Result;
    /**
     * Visit a parse tree produced by `RustParser.ifExpr`.
     * @param ctx the parse tree
     * @return the visitor result
     */
    visitIfExpr?: (ctx: IfExprContext) => Result;
    /**
     * Visit a parse tree produced by `RustParser.expr`.
     * @param ctx the parse tree
     * @return the visitor result
     */
    visitExpr?: (ctx: ExprContext) => Result;
    /**
     * Visit a parse tree produced by the `BinaryExpr`
     * labeled alternative in `RustParser.exprBinary`.
     * @param ctx the parse tree
     * @return the visitor result
     */
    visitBinaryExpr?: (ctx: BinaryExprContext) => Result;
    /**
     * Visit a parse tree produced by the `UnaryNegation`
     * labeled alternative in `RustParser.exprUnary`.
     * @param ctx the parse tree
     * @return the visitor result
     */
    visitUnaryNegation?: (ctx: UnaryNegationContext) => Result;
    /**
     * Visit a parse tree produced by the `UnaryNot`
     * labeled alternative in `RustParser.exprUnary`.
     * @param ctx the parse tree
     * @return the visitor result
     */
    visitUnaryNot?: (ctx: UnaryNotContext) => Result;
    /**
     * Visit a parse tree produced by the `ReturnExpr`
     * labeled alternative in `RustParser.exprUnary`.
     * @param ctx the parse tree
     * @return the visitor result
     */
    visitReturnExpr?: (ctx: ReturnExprContext) => Result;
    /**
     * Visit a parse tree produced by the `BorrowExpr`
     * labeled alternative in `RustParser.exprUnary`.
     * @param ctx the parse tree
     * @return the visitor result
     */
    visitBorrowExpr?: (ctx: BorrowExprContext) => Result;
    /**
     * Visit a parse tree produced by the `DerefExpr`
     * labeled alternative in `RustParser.exprUnary`.
     * @param ctx the parse tree
     * @return the visitor result
     */
    visitDerefExpr?: (ctx: DerefExprContext) => Result;
    /**
     * Visit a parse tree produced by the `UnaryToAtom`
     * labeled alternative in `RustParser.exprUnary`.
     * @param ctx the parse tree
     * @return the visitor result
     */
    visitUnaryToAtom?: (ctx: UnaryToAtomContext) => Result;
    /**
     * Visit a parse tree produced by the `FunctionCall`
     * labeled alternative in `RustParser.exprAtom`.
     * @param ctx the parse tree
     * @return the visitor result
     */
    visitFunctionCall?: (ctx: FunctionCallContext) => Result;
    /**
     * Visit a parse tree produced by the `MacroCall`
     * labeled alternative in `RustParser.exprAtom`.
     * @param ctx the parse tree
     * @return the visitor result
     */
    visitMacroCall?: (ctx: MacroCallContext) => Result;
    /**
     * Visit a parse tree produced by the `ParensExpr`
     * labeled alternative in `RustParser.exprAtom`.
     * @param ctx the parse tree
     * @return the visitor result
     */
    visitParensExpr?: (ctx: ParensExprContext) => Result;
    /**
     * Visit a parse tree produced by the `LiteralExpr`
     * labeled alternative in `RustParser.exprAtom`.
     * @param ctx the parse tree
     * @return the visitor result
     */
    visitLiteralExpr?: (ctx: LiteralExprContext) => Result;
    /**
     * Visit a parse tree produced by the `IdentExpr`
     * labeled alternative in `RustParser.exprAtom`.
     * @param ctx the parse tree
     * @return the visitor result
     */
    visitIdentExpr?: (ctx: IdentExprContext) => Result;
    /**
     * Visit a parse tree produced by `RustParser.argList`.
     * @param ctx the parse tree
     * @return the visitor result
     */
    visitArgList?: (ctx: ArgListContext) => Result;
    /**
     * Visit a parse tree produced by `RustParser.binOp`.
     * @param ctx the parse tree
     * @return the visitor result
     */
    visitBinOp?: (ctx: BinOpContext) => Result;
    /**
     * Visit a parse tree produced by the `RefType`
     * labeled alternative in `RustParser.typeExpr`.
     * @param ctx the parse tree
     * @return the visitor result
     */
    visitRefType?: (ctx: RefTypeContext) => Result;
    /**
     * Visit a parse tree produced by the `BasicType`
     * labeled alternative in `RustParser.typeExpr`.
     * @param ctx the parse tree
     * @return the visitor result
     */
    visitBasicType?: (ctx: BasicTypeContext) => Result;
    /**
     * Visit a parse tree produced by `RustParser.literal`.
     * @param ctx the parse tree
     * @return the visitor result
     */
    visitLiteral?: (ctx: LiteralContext) => Result;
}

