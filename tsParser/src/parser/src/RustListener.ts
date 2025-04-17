// Generated from src/Rust.g4 by ANTLR 4.13.1

import { ErrorNode, ParseTreeListener, ParserRuleContext, TerminalNode } from "antlr4ng";


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
 * This interface defines a complete listener for a parse tree produced by
 * `RustParser`.
 */
export class RustListener implements ParseTreeListener {
    /**
     * Enter a parse tree produced by `RustParser.program`.
     * @param ctx the parse tree
     */
    enterProgram?: (ctx: ProgramContext) => void;
    /**
     * Exit a parse tree produced by `RustParser.program`.
     * @param ctx the parse tree
     */
    exitProgram?: (ctx: ProgramContext) => void;
    /**
     * Enter a parse tree produced by `RustParser.statement`.
     * @param ctx the parse tree
     */
    enterStatement?: (ctx: StatementContext) => void;
    /**
     * Exit a parse tree produced by `RustParser.statement`.
     * @param ctx the parse tree
     */
    exitStatement?: (ctx: StatementContext) => void;
    /**
     * Enter a parse tree produced by `RustParser.letDecl`.
     * @param ctx the parse tree
     */
    enterLetDecl?: (ctx: LetDeclContext) => void;
    /**
     * Exit a parse tree produced by `RustParser.letDecl`.
     * @param ctx the parse tree
     */
    exitLetDecl?: (ctx: LetDeclContext) => void;
    /**
     * Enter a parse tree produced by `RustParser.fnDecl`.
     * @param ctx the parse tree
     */
    enterFnDecl?: (ctx: FnDeclContext) => void;
    /**
     * Exit a parse tree produced by `RustParser.fnDecl`.
     * @param ctx the parse tree
     */
    exitFnDecl?: (ctx: FnDeclContext) => void;
    /**
     * Enter a parse tree produced by `RustParser.paramList`.
     * @param ctx the parse tree
     */
    enterParamList?: (ctx: ParamListContext) => void;
    /**
     * Exit a parse tree produced by `RustParser.paramList`.
     * @param ctx the parse tree
     */
    exitParamList?: (ctx: ParamListContext) => void;
    /**
     * Enter a parse tree produced by `RustParser.param`.
     * @param ctx the parse tree
     */
    enterParam?: (ctx: ParamContext) => void;
    /**
     * Exit a parse tree produced by `RustParser.param`.
     * @param ctx the parse tree
     */
    exitParam?: (ctx: ParamContext) => void;
    /**
     * Enter a parse tree produced by `RustParser.returnType`.
     * @param ctx the parse tree
     */
    enterReturnType?: (ctx: ReturnTypeContext) => void;
    /**
     * Exit a parse tree produced by `RustParser.returnType`.
     * @param ctx the parse tree
     */
    exitReturnType?: (ctx: ReturnTypeContext) => void;
    /**
     * Enter a parse tree produced by `RustParser.whileLoop`.
     * @param ctx the parse tree
     */
    enterWhileLoop?: (ctx: WhileLoopContext) => void;
    /**
     * Exit a parse tree produced by `RustParser.whileLoop`.
     * @param ctx the parse tree
     */
    exitWhileLoop?: (ctx: WhileLoopContext) => void;
    /**
     * Enter a parse tree produced by `RustParser.block`.
     * @param ctx the parse tree
     */
    enterBlock?: (ctx: BlockContext) => void;
    /**
     * Exit a parse tree produced by `RustParser.block`.
     * @param ctx the parse tree
     */
    exitBlock?: (ctx: BlockContext) => void;
    /**
     * Enter a parse tree produced by `RustParser.ifExpr`.
     * @param ctx the parse tree
     */
    enterIfExpr?: (ctx: IfExprContext) => void;
    /**
     * Exit a parse tree produced by `RustParser.ifExpr`.
     * @param ctx the parse tree
     */
    exitIfExpr?: (ctx: IfExprContext) => void;
    /**
     * Enter a parse tree produced by `RustParser.expr`.
     * @param ctx the parse tree
     */
    enterExpr?: (ctx: ExprContext) => void;
    /**
     * Exit a parse tree produced by `RustParser.expr`.
     * @param ctx the parse tree
     */
    exitExpr?: (ctx: ExprContext) => void;
    /**
     * Enter a parse tree produced by the `BinaryExpr`
     * labeled alternative in `RustParser.exprBinary`.
     * @param ctx the parse tree
     */
    enterBinaryExpr?: (ctx: BinaryExprContext) => void;
    /**
     * Exit a parse tree produced by the `BinaryExpr`
     * labeled alternative in `RustParser.exprBinary`.
     * @param ctx the parse tree
     */
    exitBinaryExpr?: (ctx: BinaryExprContext) => void;
    /**
     * Enter a parse tree produced by the `UnaryNegation`
     * labeled alternative in `RustParser.exprUnary`.
     * @param ctx the parse tree
     */
    enterUnaryNegation?: (ctx: UnaryNegationContext) => void;
    /**
     * Exit a parse tree produced by the `UnaryNegation`
     * labeled alternative in `RustParser.exprUnary`.
     * @param ctx the parse tree
     */
    exitUnaryNegation?: (ctx: UnaryNegationContext) => void;
    /**
     * Enter a parse tree produced by the `UnaryNot`
     * labeled alternative in `RustParser.exprUnary`.
     * @param ctx the parse tree
     */
    enterUnaryNot?: (ctx: UnaryNotContext) => void;
    /**
     * Exit a parse tree produced by the `UnaryNot`
     * labeled alternative in `RustParser.exprUnary`.
     * @param ctx the parse tree
     */
    exitUnaryNot?: (ctx: UnaryNotContext) => void;
    /**
     * Enter a parse tree produced by the `ReturnExpr`
     * labeled alternative in `RustParser.exprUnary`.
     * @param ctx the parse tree
     */
    enterReturnExpr?: (ctx: ReturnExprContext) => void;
    /**
     * Exit a parse tree produced by the `ReturnExpr`
     * labeled alternative in `RustParser.exprUnary`.
     * @param ctx the parse tree
     */
    exitReturnExpr?: (ctx: ReturnExprContext) => void;
    /**
     * Enter a parse tree produced by the `BorrowExpr`
     * labeled alternative in `RustParser.exprUnary`.
     * @param ctx the parse tree
     */
    enterBorrowExpr?: (ctx: BorrowExprContext) => void;
    /**
     * Exit a parse tree produced by the `BorrowExpr`
     * labeled alternative in `RustParser.exprUnary`.
     * @param ctx the parse tree
     */
    exitBorrowExpr?: (ctx: BorrowExprContext) => void;
    /**
     * Enter a parse tree produced by the `DerefExpr`
     * labeled alternative in `RustParser.exprUnary`.
     * @param ctx the parse tree
     */
    enterDerefExpr?: (ctx: DerefExprContext) => void;
    /**
     * Exit a parse tree produced by the `DerefExpr`
     * labeled alternative in `RustParser.exprUnary`.
     * @param ctx the parse tree
     */
    exitDerefExpr?: (ctx: DerefExprContext) => void;
    /**
     * Enter a parse tree produced by the `UnaryToAtom`
     * labeled alternative in `RustParser.exprUnary`.
     * @param ctx the parse tree
     */
    enterUnaryToAtom?: (ctx: UnaryToAtomContext) => void;
    /**
     * Exit a parse tree produced by the `UnaryToAtom`
     * labeled alternative in `RustParser.exprUnary`.
     * @param ctx the parse tree
     */
    exitUnaryToAtom?: (ctx: UnaryToAtomContext) => void;
    /**
     * Enter a parse tree produced by the `FunctionCall`
     * labeled alternative in `RustParser.exprAtom`.
     * @param ctx the parse tree
     */
    enterFunctionCall?: (ctx: FunctionCallContext) => void;
    /**
     * Exit a parse tree produced by the `FunctionCall`
     * labeled alternative in `RustParser.exprAtom`.
     * @param ctx the parse tree
     */
    exitFunctionCall?: (ctx: FunctionCallContext) => void;
    /**
     * Enter a parse tree produced by the `MacroCall`
     * labeled alternative in `RustParser.exprAtom`.
     * @param ctx the parse tree
     */
    enterMacroCall?: (ctx: MacroCallContext) => void;
    /**
     * Exit a parse tree produced by the `MacroCall`
     * labeled alternative in `RustParser.exprAtom`.
     * @param ctx the parse tree
     */
    exitMacroCall?: (ctx: MacroCallContext) => void;
    /**
     * Enter a parse tree produced by the `ParensExpr`
     * labeled alternative in `RustParser.exprAtom`.
     * @param ctx the parse tree
     */
    enterParensExpr?: (ctx: ParensExprContext) => void;
    /**
     * Exit a parse tree produced by the `ParensExpr`
     * labeled alternative in `RustParser.exprAtom`.
     * @param ctx the parse tree
     */
    exitParensExpr?: (ctx: ParensExprContext) => void;
    /**
     * Enter a parse tree produced by the `LiteralExpr`
     * labeled alternative in `RustParser.exprAtom`.
     * @param ctx the parse tree
     */
    enterLiteralExpr?: (ctx: LiteralExprContext) => void;
    /**
     * Exit a parse tree produced by the `LiteralExpr`
     * labeled alternative in `RustParser.exprAtom`.
     * @param ctx the parse tree
     */
    exitLiteralExpr?: (ctx: LiteralExprContext) => void;
    /**
     * Enter a parse tree produced by the `IdentExpr`
     * labeled alternative in `RustParser.exprAtom`.
     * @param ctx the parse tree
     */
    enterIdentExpr?: (ctx: IdentExprContext) => void;
    /**
     * Exit a parse tree produced by the `IdentExpr`
     * labeled alternative in `RustParser.exprAtom`.
     * @param ctx the parse tree
     */
    exitIdentExpr?: (ctx: IdentExprContext) => void;
    /**
     * Enter a parse tree produced by `RustParser.argList`.
     * @param ctx the parse tree
     */
    enterArgList?: (ctx: ArgListContext) => void;
    /**
     * Exit a parse tree produced by `RustParser.argList`.
     * @param ctx the parse tree
     */
    exitArgList?: (ctx: ArgListContext) => void;
    /**
     * Enter a parse tree produced by `RustParser.binOp`.
     * @param ctx the parse tree
     */
    enterBinOp?: (ctx: BinOpContext) => void;
    /**
     * Exit a parse tree produced by `RustParser.binOp`.
     * @param ctx the parse tree
     */
    exitBinOp?: (ctx: BinOpContext) => void;
    /**
     * Enter a parse tree produced by the `RefType`
     * labeled alternative in `RustParser.typeExpr`.
     * @param ctx the parse tree
     */
    enterRefType?: (ctx: RefTypeContext) => void;
    /**
     * Exit a parse tree produced by the `RefType`
     * labeled alternative in `RustParser.typeExpr`.
     * @param ctx the parse tree
     */
    exitRefType?: (ctx: RefTypeContext) => void;
    /**
     * Enter a parse tree produced by the `BasicType`
     * labeled alternative in `RustParser.typeExpr`.
     * @param ctx the parse tree
     */
    enterBasicType?: (ctx: BasicTypeContext) => void;
    /**
     * Exit a parse tree produced by the `BasicType`
     * labeled alternative in `RustParser.typeExpr`.
     * @param ctx the parse tree
     */
    exitBasicType?: (ctx: BasicTypeContext) => void;
    /**
     * Enter a parse tree produced by `RustParser.literal`.
     * @param ctx the parse tree
     */
    enterLiteral?: (ctx: LiteralContext) => void;
    /**
     * Exit a parse tree produced by `RustParser.literal`.
     * @param ctx the parse tree
     */
    exitLiteral?: (ctx: LiteralContext) => void;

    visitTerminal(node: TerminalNode): void {}
    visitErrorNode(node: ErrorNode): void {}
    enterEveryRule(node: ParserRuleContext): void {}
    exitEveryRule(node: ParserRuleContext): void {}
}

