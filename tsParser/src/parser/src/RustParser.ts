// Generated from src/Rust.g4 by ANTLR 4.13.1

import * as antlr from "antlr4ng";
import { Token } from "antlr4ng";

import { RustListener } from "./RustListener.js";
import { RustVisitor } from "./RustVisitor.js";

// for running tests with parameters, TODO: discuss strategy for typed parameters in CI
// eslint-disable-next-line no-unused-vars
type int = number;


export class RustParser extends antlr.Parser {
    public static readonly T__0 = 1;
    public static readonly T__1 = 2;
    public static readonly T__2 = 3;
    public static readonly T__3 = 4;
    public static readonly T__4 = 5;
    public static readonly T__5 = 6;
    public static readonly T__6 = 7;
    public static readonly T__7 = 8;
    public static readonly T__8 = 9;
    public static readonly T__9 = 10;
    public static readonly T__10 = 11;
    public static readonly T__11 = 12;
    public static readonly T__12 = 13;
    public static readonly T__13 = 14;
    public static readonly T__14 = 15;
    public static readonly T__15 = 16;
    public static readonly T__16 = 17;
    public static readonly T__17 = 18;
    public static readonly T__18 = 19;
    public static readonly T__19 = 20;
    public static readonly T__20 = 21;
    public static readonly T__21 = 22;
    public static readonly T__22 = 23;
    public static readonly T__23 = 24;
    public static readonly T__24 = 25;
    public static readonly T__25 = 26;
    public static readonly T__26 = 27;
    public static readonly MUT = 28;
    public static readonly REF = 29;
    public static readonly IDENTIFIER = 30;
    public static readonly INT = 31;
    public static readonly FLOAT = 32;
    public static readonly STRING = 33;
    public static readonly WS = 34;
    public static readonly COMMENT = 35;
    public static readonly RULE_program = 0;
    public static readonly RULE_statement = 1;
    public static readonly RULE_letDecl = 2;
    public static readonly RULE_fnDecl = 3;
    public static readonly RULE_paramList = 4;
    public static readonly RULE_param = 5;
    public static readonly RULE_returnType = 6;
    public static readonly RULE_whileLoop = 7;
    public static readonly RULE_block = 8;
    public static readonly RULE_returnExpr = 9;
    public static readonly RULE_ifExpr = 10;
    public static readonly RULE_expr = 11;
    public static readonly RULE_exprBinary = 12;
    public static readonly RULE_exprUnary = 13;
    public static readonly RULE_exprAtom = 14;
    public static readonly RULE_argList = 15;
    public static readonly RULE_binOp = 16;
    public static readonly RULE_typeExpr = 17;
    public static readonly RULE_literal = 18;

    public static readonly literalNames = [
        null, "';'", "'let'", "':'", "'='", "'fn'", "'('", "')'", "','", 
        "'->'", "'while'", "'{'", "'}'", "'if'", "'else'", "'-'", "'!'", 
        "'+'", "'*'", "'/'", "'=='", "'!='", "'<'", "'<='", "'>'", "'>='", 
        "'true'", "'false'", "'mut'", "'&'"
    ];

    public static readonly symbolicNames = [
        null, null, null, null, null, null, null, null, null, null, null, 
        null, null, null, null, null, null, null, null, null, null, null, 
        null, null, null, null, null, null, "MUT", "REF", "IDENTIFIER", 
        "INT", "FLOAT", "STRING", "WS", "COMMENT"
    ];
    public static readonly ruleNames = [
        "program", "statement", "letDecl", "fnDecl", "paramList", "param", 
        "returnType", "whileLoop", "block", "returnExpr", "ifExpr", "expr", 
        "exprBinary", "exprUnary", "exprAtom", "argList", "binOp", "typeExpr", 
        "literal",
    ];

    public get grammarFileName(): string { return "Rust.g4"; }
    public get literalNames(): (string | null)[] { return RustParser.literalNames; }
    public get symbolicNames(): (string | null)[] { return RustParser.symbolicNames; }
    public get ruleNames(): string[] { return RustParser.ruleNames; }
    public get serializedATN(): number[] { return RustParser._serializedATN; }

    protected createFailedPredicateException(predicate?: string, message?: string): antlr.FailedPredicateException {
        return new antlr.FailedPredicateException(this, predicate, message);
    }

    public constructor(input: antlr.TokenStream) {
        super(input);
        this.interpreter = new antlr.ParserATNSimulator(this, RustParser._ATN, RustParser.decisionsToDFA, new antlr.PredictionContextCache());
    }
    public program(): ProgramContext {
        let localContext = new ProgramContext(this.context, this.state);
        this.enterRule(localContext, 0, RustParser.RULE_program);
        let _la: number;
        try {
            this.enterOuterAlt(localContext, 1);
            {
            this.state = 41;
            this.errorHandler.sync(this);
            _la = this.tokenStream.LA(1);
            while (((((_la - 2)) & ~0x1F) === 0 && ((1 << (_la - 2)) & 4211108633) !== 0)) {
                {
                {
                this.state = 38;
                this.statement();
                }
                }
                this.state = 43;
                this.errorHandler.sync(this);
                _la = this.tokenStream.LA(1);
            }
            this.state = 44;
            this.match(RustParser.EOF);
            }
        }
        catch (re) {
            if (re instanceof antlr.RecognitionException) {
                this.errorHandler.reportError(this, re);
                this.errorHandler.recover(this, re);
            } else {
                throw re;
            }
        }
        finally {
            this.exitRule();
        }
        return localContext;
    }
    public statement(): StatementContext {
        let localContext = new StatementContext(this.context, this.state);
        this.enterRule(localContext, 2, RustParser.RULE_statement);
        try {
            this.state = 57;
            this.errorHandler.sync(this);
            switch (this.interpreter.adaptivePredict(this.tokenStream, 1, this.context) ) {
            case 1:
                this.enterOuterAlt(localContext, 1);
                {
                this.state = 46;
                this.letDecl();
                this.state = 47;
                this.match(RustParser.T__0);
                }
                break;
            case 2:
                this.enterOuterAlt(localContext, 2);
                {
                this.state = 49;
                this.fnDecl();
                }
                break;
            case 3:
                this.enterOuterAlt(localContext, 3);
                {
                this.state = 50;
                this.whileLoop();
                }
                break;
            case 4:
                this.enterOuterAlt(localContext, 4);
                {
                this.state = 51;
                this.ifExpr();
                }
                break;
            case 5:
                this.enterOuterAlt(localContext, 5);
                {
                this.state = 52;
                this.block();
                }
                break;
            case 6:
                this.enterOuterAlt(localContext, 6);
                {
                this.state = 53;
                this.expr();
                this.state = 54;
                this.match(RustParser.T__0);
                }
                break;
            case 7:
                this.enterOuterAlt(localContext, 7);
                {
                this.state = 56;
                this.returnExpr();
                }
                break;
            }
        }
        catch (re) {
            if (re instanceof antlr.RecognitionException) {
                this.errorHandler.reportError(this, re);
                this.errorHandler.recover(this, re);
            } else {
                throw re;
            }
        }
        finally {
            this.exitRule();
        }
        return localContext;
    }
    public letDecl(): LetDeclContext {
        let localContext = new LetDeclContext(this.context, this.state);
        this.enterRule(localContext, 4, RustParser.RULE_letDecl);
        let _la: number;
        try {
            this.enterOuterAlt(localContext, 1);
            {
            this.state = 59;
            this.match(RustParser.T__1);
            this.state = 61;
            this.errorHandler.sync(this);
            _la = this.tokenStream.LA(1);
            if (_la === 28) {
                {
                this.state = 60;
                this.match(RustParser.MUT);
                }
            }

            this.state = 63;
            this.match(RustParser.IDENTIFIER);
            this.state = 66;
            this.errorHandler.sync(this);
            _la = this.tokenStream.LA(1);
            if (_la === 3) {
                {
                this.state = 64;
                this.match(RustParser.T__2);
                this.state = 65;
                this.typeExpr();
                }
            }

            this.state = 70;
            this.errorHandler.sync(this);
            _la = this.tokenStream.LA(1);
            if (_la === 4) {
                {
                this.state = 68;
                this.match(RustParser.T__3);
                this.state = 69;
                this.expr();
                }
            }

            }
        }
        catch (re) {
            if (re instanceof antlr.RecognitionException) {
                this.errorHandler.reportError(this, re);
                this.errorHandler.recover(this, re);
            } else {
                throw re;
            }
        }
        finally {
            this.exitRule();
        }
        return localContext;
    }
    public fnDecl(): FnDeclContext {
        let localContext = new FnDeclContext(this.context, this.state);
        this.enterRule(localContext, 6, RustParser.RULE_fnDecl);
        let _la: number;
        try {
            this.enterOuterAlt(localContext, 1);
            {
            this.state = 72;
            this.match(RustParser.T__4);
            this.state = 73;
            this.match(RustParser.IDENTIFIER);
            this.state = 74;
            this.match(RustParser.T__5);
            this.state = 76;
            this.errorHandler.sync(this);
            _la = this.tokenStream.LA(1);
            if ((((_la) & ~0x1F) === 0 && ((1 << _la) & 1879048192) !== 0)) {
                {
                this.state = 75;
                this.paramList();
                }
            }

            this.state = 78;
            this.match(RustParser.T__6);
            this.state = 80;
            this.errorHandler.sync(this);
            _la = this.tokenStream.LA(1);
            if (_la === 9) {
                {
                this.state = 79;
                this.returnType();
                }
            }

            this.state = 82;
            this.block();
            }
        }
        catch (re) {
            if (re instanceof antlr.RecognitionException) {
                this.errorHandler.reportError(this, re);
                this.errorHandler.recover(this, re);
            } else {
                throw re;
            }
        }
        finally {
            this.exitRule();
        }
        return localContext;
    }
    public paramList(): ParamListContext {
        let localContext = new ParamListContext(this.context, this.state);
        this.enterRule(localContext, 8, RustParser.RULE_paramList);
        let _la: number;
        try {
            this.enterOuterAlt(localContext, 1);
            {
            this.state = 84;
            this.param();
            this.state = 89;
            this.errorHandler.sync(this);
            _la = this.tokenStream.LA(1);
            while (_la === 8) {
                {
                {
                this.state = 85;
                this.match(RustParser.T__7);
                this.state = 86;
                this.param();
                }
                }
                this.state = 91;
                this.errorHandler.sync(this);
                _la = this.tokenStream.LA(1);
            }
            }
        }
        catch (re) {
            if (re instanceof antlr.RecognitionException) {
                this.errorHandler.reportError(this, re);
                this.errorHandler.recover(this, re);
            } else {
                throw re;
            }
        }
        finally {
            this.exitRule();
        }
        return localContext;
    }
    public param(): ParamContext {
        let localContext = new ParamContext(this.context, this.state);
        this.enterRule(localContext, 10, RustParser.RULE_param);
        let _la: number;
        try {
            this.enterOuterAlt(localContext, 1);
            {
            this.state = 93;
            this.errorHandler.sync(this);
            _la = this.tokenStream.LA(1);
            if (_la === 29) {
                {
                this.state = 92;
                this.match(RustParser.REF);
                }
            }

            this.state = 96;
            this.errorHandler.sync(this);
            _la = this.tokenStream.LA(1);
            if (_la === 28) {
                {
                this.state = 95;
                this.match(RustParser.MUT);
                }
            }

            this.state = 98;
            this.match(RustParser.IDENTIFIER);
            this.state = 99;
            this.match(RustParser.T__2);
            this.state = 100;
            this.typeExpr();
            }
        }
        catch (re) {
            if (re instanceof antlr.RecognitionException) {
                this.errorHandler.reportError(this, re);
                this.errorHandler.recover(this, re);
            } else {
                throw re;
            }
        }
        finally {
            this.exitRule();
        }
        return localContext;
    }
    public returnType(): ReturnTypeContext {
        let localContext = new ReturnTypeContext(this.context, this.state);
        this.enterRule(localContext, 12, RustParser.RULE_returnType);
        try {
            this.enterOuterAlt(localContext, 1);
            {
            this.state = 102;
            this.match(RustParser.T__8);
            this.state = 103;
            this.typeExpr();
            }
        }
        catch (re) {
            if (re instanceof antlr.RecognitionException) {
                this.errorHandler.reportError(this, re);
                this.errorHandler.recover(this, re);
            } else {
                throw re;
            }
        }
        finally {
            this.exitRule();
        }
        return localContext;
    }
    public whileLoop(): WhileLoopContext {
        let localContext = new WhileLoopContext(this.context, this.state);
        this.enterRule(localContext, 14, RustParser.RULE_whileLoop);
        try {
            this.enterOuterAlt(localContext, 1);
            {
            this.state = 105;
            this.match(RustParser.T__9);
            this.state = 106;
            this.expr();
            this.state = 107;
            this.block();
            }
        }
        catch (re) {
            if (re instanceof antlr.RecognitionException) {
                this.errorHandler.reportError(this, re);
                this.errorHandler.recover(this, re);
            } else {
                throw re;
            }
        }
        finally {
            this.exitRule();
        }
        return localContext;
    }
    public block(): BlockContext {
        let localContext = new BlockContext(this.context, this.state);
        this.enterRule(localContext, 16, RustParser.RULE_block);
        let _la: number;
        try {
            let alternative: number;
            this.enterOuterAlt(localContext, 1);
            {
            this.state = 109;
            this.match(RustParser.T__10);
            this.state = 113;
            this.errorHandler.sync(this);
            alternative = this.interpreter.adaptivePredict(this.tokenStream, 10, this.context);
            while (alternative !== 2 && alternative !== antlr.ATN.INVALID_ALT_NUMBER) {
                if (alternative === 1) {
                    {
                    {
                    this.state = 110;
                    this.statement();
                    }
                    }
                }
                this.state = 115;
                this.errorHandler.sync(this);
                alternative = this.interpreter.adaptivePredict(this.tokenStream, 10, this.context);
            }
            this.state = 117;
            this.errorHandler.sync(this);
            _la = this.tokenStream.LA(1);
            if (((((_la - 6)) & ~0x1F) === 0 && ((1 << (_la - 6)) & 263194113) !== 0)) {
                {
                this.state = 116;
                this.returnExpr();
                }
            }

            this.state = 119;
            this.match(RustParser.T__11);
            }
        }
        catch (re) {
            if (re instanceof antlr.RecognitionException) {
                this.errorHandler.reportError(this, re);
                this.errorHandler.recover(this, re);
            } else {
                throw re;
            }
        }
        finally {
            this.exitRule();
        }
        return localContext;
    }
    public returnExpr(): ReturnExprContext {
        let localContext = new ReturnExprContext(this.context, this.state);
        this.enterRule(localContext, 18, RustParser.RULE_returnExpr);
        try {
            this.state = 125;
            this.errorHandler.sync(this);
            switch (this.interpreter.adaptivePredict(this.tokenStream, 12, this.context) ) {
            case 1:
                localContext = new ImplicitReturnContext(localContext);
                this.enterOuterAlt(localContext, 1);
                {
                this.state = 121;
                this.expr();
                }
                break;
            case 2:
                localContext = new ExplicitReturnContext(localContext);
                this.enterOuterAlt(localContext, 2);
                {
                this.state = 122;
                this.expr();
                this.state = 123;
                this.match(RustParser.T__0);
                }
                break;
            }
        }
        catch (re) {
            if (re instanceof antlr.RecognitionException) {
                this.errorHandler.reportError(this, re);
                this.errorHandler.recover(this, re);
            } else {
                throw re;
            }
        }
        finally {
            this.exitRule();
        }
        return localContext;
    }
    public ifExpr(): IfExprContext {
        let localContext = new IfExprContext(this.context, this.state);
        this.enterRule(localContext, 20, RustParser.RULE_ifExpr);
        let _la: number;
        try {
            this.enterOuterAlt(localContext, 1);
            {
            this.state = 127;
            this.match(RustParser.T__12);
            this.state = 128;
            this.expr();
            this.state = 129;
            this.block();
            this.state = 132;
            this.errorHandler.sync(this);
            _la = this.tokenStream.LA(1);
            if (_la === 14) {
                {
                this.state = 130;
                this.match(RustParser.T__13);
                this.state = 131;
                this.block();
                }
            }

            }
        }
        catch (re) {
            if (re instanceof antlr.RecognitionException) {
                this.errorHandler.reportError(this, re);
                this.errorHandler.recover(this, re);
            } else {
                throw re;
            }
        }
        finally {
            this.exitRule();
        }
        return localContext;
    }
    public expr(): ExprContext {
        let localContext = new ExprContext(this.context, this.state);
        this.enterRule(localContext, 22, RustParser.RULE_expr);
        try {
            this.enterOuterAlt(localContext, 1);
            {
            this.state = 134;
            this.exprBinary();
            }
        }
        catch (re) {
            if (re instanceof antlr.RecognitionException) {
                this.errorHandler.reportError(this, re);
                this.errorHandler.recover(this, re);
            } else {
                throw re;
            }
        }
        finally {
            this.exitRule();
        }
        return localContext;
    }
    public exprBinary(): ExprBinaryContext {
        let localContext = new ExprBinaryContext(this.context, this.state);
        this.enterRule(localContext, 24, RustParser.RULE_exprBinary);
        try {
            let alternative: number;
            localContext = new BinaryExprContext(localContext);
            this.enterOuterAlt(localContext, 1);
            {
            this.state = 136;
            this.exprUnary();
            this.state = 142;
            this.errorHandler.sync(this);
            alternative = this.interpreter.adaptivePredict(this.tokenStream, 14, this.context);
            while (alternative !== 2 && alternative !== antlr.ATN.INVALID_ALT_NUMBER) {
                if (alternative === 1) {
                    {
                    {
                    this.state = 137;
                    this.binOp();
                    this.state = 138;
                    this.exprUnary();
                    }
                    }
                }
                this.state = 144;
                this.errorHandler.sync(this);
                alternative = this.interpreter.adaptivePredict(this.tokenStream, 14, this.context);
            }
            }
        }
        catch (re) {
            if (re instanceof antlr.RecognitionException) {
                this.errorHandler.reportError(this, re);
                this.errorHandler.recover(this, re);
            } else {
                throw re;
            }
        }
        finally {
            this.exitRule();
        }
        return localContext;
    }
    public exprUnary(): ExprUnaryContext {
        let localContext = new ExprUnaryContext(this.context, this.state);
        this.enterRule(localContext, 26, RustParser.RULE_exprUnary);
        let _la: number;
        try {
            this.state = 155;
            this.errorHandler.sync(this);
            switch (this.tokenStream.LA(1)) {
            case RustParser.T__14:
                localContext = new UnaryNegationContext(localContext);
                this.enterOuterAlt(localContext, 1);
                {
                this.state = 145;
                this.match(RustParser.T__14);
                this.state = 146;
                this.exprUnary();
                }
                break;
            case RustParser.T__15:
                localContext = new UnaryNotContext(localContext);
                this.enterOuterAlt(localContext, 2);
                {
                this.state = 147;
                this.match(RustParser.T__15);
                this.state = 148;
                this.exprUnary();
                }
                break;
            case RustParser.REF:
                localContext = new BorrowExprContext(localContext);
                this.enterOuterAlt(localContext, 3);
                {
                this.state = 149;
                this.match(RustParser.REF);
                this.state = 151;
                this.errorHandler.sync(this);
                _la = this.tokenStream.LA(1);
                if (_la === 28) {
                    {
                    this.state = 150;
                    this.match(RustParser.MUT);
                    }
                }

                this.state = 153;
                this.exprUnary();
                }
                break;
            case RustParser.T__5:
            case RustParser.T__25:
            case RustParser.T__26:
            case RustParser.IDENTIFIER:
            case RustParser.INT:
            case RustParser.FLOAT:
            case RustParser.STRING:
                localContext = new UnaryToAtomContext(localContext);
                this.enterOuterAlt(localContext, 4);
                {
                this.state = 154;
                this.exprAtom();
                }
                break;
            default:
                throw new antlr.NoViableAltException(this);
            }
        }
        catch (re) {
            if (re instanceof antlr.RecognitionException) {
                this.errorHandler.reportError(this, re);
                this.errorHandler.recover(this, re);
            } else {
                throw re;
            }
        }
        finally {
            this.exitRule();
        }
        return localContext;
    }
    public exprAtom(): ExprAtomContext {
        let localContext = new ExprAtomContext(this.context, this.state);
        this.enterRule(localContext, 28, RustParser.RULE_exprAtom);
        let _la: number;
        try {
            this.state = 176;
            this.errorHandler.sync(this);
            switch (this.interpreter.adaptivePredict(this.tokenStream, 19, this.context) ) {
            case 1:
                localContext = new FunctionCallContext(localContext);
                this.enterOuterAlt(localContext, 1);
                {
                this.state = 157;
                this.match(RustParser.IDENTIFIER);
                this.state = 158;
                this.match(RustParser.T__5);
                this.state = 160;
                this.errorHandler.sync(this);
                _la = this.tokenStream.LA(1);
                if (((((_la - 6)) & ~0x1F) === 0 && ((1 << (_la - 6)) & 263194113) !== 0)) {
                    {
                    this.state = 159;
                    this.argList();
                    }
                }

                this.state = 162;
                this.match(RustParser.T__6);
                }
                break;
            case 2:
                localContext = new MacroCallContext(localContext);
                this.enterOuterAlt(localContext, 2);
                {
                this.state = 163;
                this.match(RustParser.IDENTIFIER);
                this.state = 164;
                this.match(RustParser.T__15);
                this.state = 165;
                this.match(RustParser.T__5);
                this.state = 167;
                this.errorHandler.sync(this);
                _la = this.tokenStream.LA(1);
                if (((((_la - 6)) & ~0x1F) === 0 && ((1 << (_la - 6)) & 263194113) !== 0)) {
                    {
                    this.state = 166;
                    this.argList();
                    }
                }

                this.state = 169;
                this.match(RustParser.T__6);
                }
                break;
            case 3:
                localContext = new ParensExprContext(localContext);
                this.enterOuterAlt(localContext, 3);
                {
                this.state = 170;
                this.match(RustParser.T__5);
                this.state = 171;
                this.expr();
                this.state = 172;
                this.match(RustParser.T__6);
                }
                break;
            case 4:
                localContext = new LiteralExprContext(localContext);
                this.enterOuterAlt(localContext, 4);
                {
                this.state = 174;
                this.literal();
                }
                break;
            case 5:
                localContext = new IdentExprContext(localContext);
                this.enterOuterAlt(localContext, 5);
                {
                this.state = 175;
                this.match(RustParser.IDENTIFIER);
                }
                break;
            }
        }
        catch (re) {
            if (re instanceof antlr.RecognitionException) {
                this.errorHandler.reportError(this, re);
                this.errorHandler.recover(this, re);
            } else {
                throw re;
            }
        }
        finally {
            this.exitRule();
        }
        return localContext;
    }
    public argList(): ArgListContext {
        let localContext = new ArgListContext(this.context, this.state);
        this.enterRule(localContext, 30, RustParser.RULE_argList);
        let _la: number;
        try {
            this.enterOuterAlt(localContext, 1);
            {
            this.state = 178;
            this.expr();
            this.state = 183;
            this.errorHandler.sync(this);
            _la = this.tokenStream.LA(1);
            while (_la === 8) {
                {
                {
                this.state = 179;
                this.match(RustParser.T__7);
                this.state = 180;
                this.expr();
                }
                }
                this.state = 185;
                this.errorHandler.sync(this);
                _la = this.tokenStream.LA(1);
            }
            }
        }
        catch (re) {
            if (re instanceof antlr.RecognitionException) {
                this.errorHandler.reportError(this, re);
                this.errorHandler.recover(this, re);
            } else {
                throw re;
            }
        }
        finally {
            this.exitRule();
        }
        return localContext;
    }
    public binOp(): BinOpContext {
        let localContext = new BinOpContext(this.context, this.state);
        this.enterRule(localContext, 32, RustParser.RULE_binOp);
        let _la: number;
        try {
            this.enterOuterAlt(localContext, 1);
            {
            this.state = 186;
            _la = this.tokenStream.LA(1);
            if(!((((_la) & ~0x1F) === 0 && ((1 << _la) & 67010560) !== 0))) {
            this.errorHandler.recoverInline(this);
            }
            else {
                this.errorHandler.reportMatch(this);
                this.consume();
            }
            }
        }
        catch (re) {
            if (re instanceof antlr.RecognitionException) {
                this.errorHandler.reportError(this, re);
                this.errorHandler.recover(this, re);
            } else {
                throw re;
            }
        }
        finally {
            this.exitRule();
        }
        return localContext;
    }
    public typeExpr(): TypeExprContext {
        let localContext = new TypeExprContext(this.context, this.state);
        this.enterRule(localContext, 34, RustParser.RULE_typeExpr);
        let _la: number;
        try {
            this.state = 194;
            this.errorHandler.sync(this);
            switch (this.tokenStream.LA(1)) {
            case RustParser.REF:
                localContext = new RefTypeContext(localContext);
                this.enterOuterAlt(localContext, 1);
                {
                this.state = 188;
                this.match(RustParser.REF);
                this.state = 190;
                this.errorHandler.sync(this);
                _la = this.tokenStream.LA(1);
                if (_la === 28) {
                    {
                    this.state = 189;
                    this.match(RustParser.MUT);
                    }
                }

                this.state = 192;
                this.match(RustParser.IDENTIFIER);
                }
                break;
            case RustParser.IDENTIFIER:
                localContext = new BasicTypeContext(localContext);
                this.enterOuterAlt(localContext, 2);
                {
                this.state = 193;
                this.match(RustParser.IDENTIFIER);
                }
                break;
            default:
                throw new antlr.NoViableAltException(this);
            }
        }
        catch (re) {
            if (re instanceof antlr.RecognitionException) {
                this.errorHandler.reportError(this, re);
                this.errorHandler.recover(this, re);
            } else {
                throw re;
            }
        }
        finally {
            this.exitRule();
        }
        return localContext;
    }
    public literal(): LiteralContext {
        let localContext = new LiteralContext(this.context, this.state);
        this.enterRule(localContext, 36, RustParser.RULE_literal);
        let _la: number;
        try {
            this.enterOuterAlt(localContext, 1);
            {
            this.state = 196;
            _la = this.tokenStream.LA(1);
            if(!(((((_la - 26)) & ~0x1F) === 0 && ((1 << (_la - 26)) & 227) !== 0))) {
            this.errorHandler.recoverInline(this);
            }
            else {
                this.errorHandler.reportMatch(this);
                this.consume();
            }
            }
        }
        catch (re) {
            if (re instanceof antlr.RecognitionException) {
                this.errorHandler.reportError(this, re);
                this.errorHandler.recover(this, re);
            } else {
                throw re;
            }
        }
        finally {
            this.exitRule();
        }
        return localContext;
    }

    public static readonly _serializedATN: number[] = [
        4,1,35,199,2,0,7,0,2,1,7,1,2,2,7,2,2,3,7,3,2,4,7,4,2,5,7,5,2,6,7,
        6,2,7,7,7,2,8,7,8,2,9,7,9,2,10,7,10,2,11,7,11,2,12,7,12,2,13,7,13,
        2,14,7,14,2,15,7,15,2,16,7,16,2,17,7,17,2,18,7,18,1,0,5,0,40,8,0,
        10,0,12,0,43,9,0,1,0,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
        1,1,3,1,58,8,1,1,2,1,2,3,2,62,8,2,1,2,1,2,1,2,3,2,67,8,2,1,2,1,2,
        3,2,71,8,2,1,3,1,3,1,3,1,3,3,3,77,8,3,1,3,1,3,3,3,81,8,3,1,3,1,3,
        1,4,1,4,1,4,5,4,88,8,4,10,4,12,4,91,9,4,1,5,3,5,94,8,5,1,5,3,5,97,
        8,5,1,5,1,5,1,5,1,5,1,6,1,6,1,6,1,7,1,7,1,7,1,7,1,8,1,8,5,8,112,
        8,8,10,8,12,8,115,9,8,1,8,3,8,118,8,8,1,8,1,8,1,9,1,9,1,9,1,9,3,
        9,126,8,9,1,10,1,10,1,10,1,10,1,10,3,10,133,8,10,1,11,1,11,1,12,
        1,12,1,12,1,12,5,12,141,8,12,10,12,12,12,144,9,12,1,13,1,13,1,13,
        1,13,1,13,1,13,3,13,152,8,13,1,13,1,13,3,13,156,8,13,1,14,1,14,1,
        14,3,14,161,8,14,1,14,1,14,1,14,1,14,1,14,3,14,168,8,14,1,14,1,14,
        1,14,1,14,1,14,1,14,1,14,3,14,177,8,14,1,15,1,15,1,15,5,15,182,8,
        15,10,15,12,15,185,9,15,1,16,1,16,1,17,1,17,3,17,191,8,17,1,17,1,
        17,3,17,195,8,17,1,18,1,18,1,18,0,0,19,0,2,4,6,8,10,12,14,16,18,
        20,22,24,26,28,30,32,34,36,0,2,2,0,15,15,17,25,2,0,26,27,31,33,212,
        0,41,1,0,0,0,2,57,1,0,0,0,4,59,1,0,0,0,6,72,1,0,0,0,8,84,1,0,0,0,
        10,93,1,0,0,0,12,102,1,0,0,0,14,105,1,0,0,0,16,109,1,0,0,0,18,125,
        1,0,0,0,20,127,1,0,0,0,22,134,1,0,0,0,24,136,1,0,0,0,26,155,1,0,
        0,0,28,176,1,0,0,0,30,178,1,0,0,0,32,186,1,0,0,0,34,194,1,0,0,0,
        36,196,1,0,0,0,38,40,3,2,1,0,39,38,1,0,0,0,40,43,1,0,0,0,41,39,1,
        0,0,0,41,42,1,0,0,0,42,44,1,0,0,0,43,41,1,0,0,0,44,45,5,0,0,1,45,
        1,1,0,0,0,46,47,3,4,2,0,47,48,5,1,0,0,48,58,1,0,0,0,49,58,3,6,3,
        0,50,58,3,14,7,0,51,58,3,20,10,0,52,58,3,16,8,0,53,54,3,22,11,0,
        54,55,5,1,0,0,55,58,1,0,0,0,56,58,3,18,9,0,57,46,1,0,0,0,57,49,1,
        0,0,0,57,50,1,0,0,0,57,51,1,0,0,0,57,52,1,0,0,0,57,53,1,0,0,0,57,
        56,1,0,0,0,58,3,1,0,0,0,59,61,5,2,0,0,60,62,5,28,0,0,61,60,1,0,0,
        0,61,62,1,0,0,0,62,63,1,0,0,0,63,66,5,30,0,0,64,65,5,3,0,0,65,67,
        3,34,17,0,66,64,1,0,0,0,66,67,1,0,0,0,67,70,1,0,0,0,68,69,5,4,0,
        0,69,71,3,22,11,0,70,68,1,0,0,0,70,71,1,0,0,0,71,5,1,0,0,0,72,73,
        5,5,0,0,73,74,5,30,0,0,74,76,5,6,0,0,75,77,3,8,4,0,76,75,1,0,0,0,
        76,77,1,0,0,0,77,78,1,0,0,0,78,80,5,7,0,0,79,81,3,12,6,0,80,79,1,
        0,0,0,80,81,1,0,0,0,81,82,1,0,0,0,82,83,3,16,8,0,83,7,1,0,0,0,84,
        89,3,10,5,0,85,86,5,8,0,0,86,88,3,10,5,0,87,85,1,0,0,0,88,91,1,0,
        0,0,89,87,1,0,0,0,89,90,1,0,0,0,90,9,1,0,0,0,91,89,1,0,0,0,92,94,
        5,29,0,0,93,92,1,0,0,0,93,94,1,0,0,0,94,96,1,0,0,0,95,97,5,28,0,
        0,96,95,1,0,0,0,96,97,1,0,0,0,97,98,1,0,0,0,98,99,5,30,0,0,99,100,
        5,3,0,0,100,101,3,34,17,0,101,11,1,0,0,0,102,103,5,9,0,0,103,104,
        3,34,17,0,104,13,1,0,0,0,105,106,5,10,0,0,106,107,3,22,11,0,107,
        108,3,16,8,0,108,15,1,0,0,0,109,113,5,11,0,0,110,112,3,2,1,0,111,
        110,1,0,0,0,112,115,1,0,0,0,113,111,1,0,0,0,113,114,1,0,0,0,114,
        117,1,0,0,0,115,113,1,0,0,0,116,118,3,18,9,0,117,116,1,0,0,0,117,
        118,1,0,0,0,118,119,1,0,0,0,119,120,5,12,0,0,120,17,1,0,0,0,121,
        126,3,22,11,0,122,123,3,22,11,0,123,124,5,1,0,0,124,126,1,0,0,0,
        125,121,1,0,0,0,125,122,1,0,0,0,126,19,1,0,0,0,127,128,5,13,0,0,
        128,129,3,22,11,0,129,132,3,16,8,0,130,131,5,14,0,0,131,133,3,16,
        8,0,132,130,1,0,0,0,132,133,1,0,0,0,133,21,1,0,0,0,134,135,3,24,
        12,0,135,23,1,0,0,0,136,142,3,26,13,0,137,138,3,32,16,0,138,139,
        3,26,13,0,139,141,1,0,0,0,140,137,1,0,0,0,141,144,1,0,0,0,142,140,
        1,0,0,0,142,143,1,0,0,0,143,25,1,0,0,0,144,142,1,0,0,0,145,146,5,
        15,0,0,146,156,3,26,13,0,147,148,5,16,0,0,148,156,3,26,13,0,149,
        151,5,29,0,0,150,152,5,28,0,0,151,150,1,0,0,0,151,152,1,0,0,0,152,
        153,1,0,0,0,153,156,3,26,13,0,154,156,3,28,14,0,155,145,1,0,0,0,
        155,147,1,0,0,0,155,149,1,0,0,0,155,154,1,0,0,0,156,27,1,0,0,0,157,
        158,5,30,0,0,158,160,5,6,0,0,159,161,3,30,15,0,160,159,1,0,0,0,160,
        161,1,0,0,0,161,162,1,0,0,0,162,177,5,7,0,0,163,164,5,30,0,0,164,
        165,5,16,0,0,165,167,5,6,0,0,166,168,3,30,15,0,167,166,1,0,0,0,167,
        168,1,0,0,0,168,169,1,0,0,0,169,177,5,7,0,0,170,171,5,6,0,0,171,
        172,3,22,11,0,172,173,5,7,0,0,173,177,1,0,0,0,174,177,3,36,18,0,
        175,177,5,30,0,0,176,157,1,0,0,0,176,163,1,0,0,0,176,170,1,0,0,0,
        176,174,1,0,0,0,176,175,1,0,0,0,177,29,1,0,0,0,178,183,3,22,11,0,
        179,180,5,8,0,0,180,182,3,22,11,0,181,179,1,0,0,0,182,185,1,0,0,
        0,183,181,1,0,0,0,183,184,1,0,0,0,184,31,1,0,0,0,185,183,1,0,0,0,
        186,187,7,0,0,0,187,33,1,0,0,0,188,190,5,29,0,0,189,191,5,28,0,0,
        190,189,1,0,0,0,190,191,1,0,0,0,191,192,1,0,0,0,192,195,5,30,0,0,
        193,195,5,30,0,0,194,188,1,0,0,0,194,193,1,0,0,0,195,35,1,0,0,0,
        196,197,7,1,0,0,197,37,1,0,0,0,23,41,57,61,66,70,76,80,89,93,96,
        113,117,125,132,142,151,155,160,167,176,183,190,194
    ];

    private static __ATN: antlr.ATN;
    public static get _ATN(): antlr.ATN {
        if (!RustParser.__ATN) {
            RustParser.__ATN = new antlr.ATNDeserializer().deserialize(RustParser._serializedATN);
        }

        return RustParser.__ATN;
    }


    private static readonly vocabulary = new antlr.Vocabulary(RustParser.literalNames, RustParser.symbolicNames, []);

    public override get vocabulary(): antlr.Vocabulary {
        return RustParser.vocabulary;
    }

    private static readonly decisionsToDFA = RustParser._ATN.decisionToState.map( (ds: antlr.DecisionState, index: number) => new antlr.DFA(ds, index) );
}

export class ProgramContext extends antlr.ParserRuleContext {
    public constructor(parent: antlr.ParserRuleContext | null, invokingState: number) {
        super(parent, invokingState);
    }
    public EOF(): antlr.TerminalNode {
        return this.getToken(RustParser.EOF, 0)!;
    }
    public statement(): StatementContext[];
    public statement(i: number): StatementContext | null;
    public statement(i?: number): StatementContext[] | StatementContext | null {
        if (i === undefined) {
            return this.getRuleContexts(StatementContext);
        }

        return this.getRuleContext(i, StatementContext);
    }
    public override get ruleIndex(): number {
        return RustParser.RULE_program;
    }
    public override enterRule(listener: RustListener): void {
        if(listener.enterProgram) {
             listener.enterProgram(this);
        }
    }
    public override exitRule(listener: RustListener): void {
        if(listener.exitProgram) {
             listener.exitProgram(this);
        }
    }
    public override accept<Result>(visitor: RustVisitor<Result>): Result | null {
        if (visitor.visitProgram) {
            return visitor.visitProgram(this);
        } else {
            return visitor.visitChildren(this);
        }
    }
}


export class StatementContext extends antlr.ParserRuleContext {
    public constructor(parent: antlr.ParserRuleContext | null, invokingState: number) {
        super(parent, invokingState);
    }
    public letDecl(): LetDeclContext | null {
        return this.getRuleContext(0, LetDeclContext);
    }
    public fnDecl(): FnDeclContext | null {
        return this.getRuleContext(0, FnDeclContext);
    }
    public whileLoop(): WhileLoopContext | null {
        return this.getRuleContext(0, WhileLoopContext);
    }
    public ifExpr(): IfExprContext | null {
        return this.getRuleContext(0, IfExprContext);
    }
    public block(): BlockContext | null {
        return this.getRuleContext(0, BlockContext);
    }
    public expr(): ExprContext | null {
        return this.getRuleContext(0, ExprContext);
    }
    public returnExpr(): ReturnExprContext | null {
        return this.getRuleContext(0, ReturnExprContext);
    }
    public override get ruleIndex(): number {
        return RustParser.RULE_statement;
    }
    public override enterRule(listener: RustListener): void {
        if(listener.enterStatement) {
             listener.enterStatement(this);
        }
    }
    public override exitRule(listener: RustListener): void {
        if(listener.exitStatement) {
             listener.exitStatement(this);
        }
    }
    public override accept<Result>(visitor: RustVisitor<Result>): Result | null {
        if (visitor.visitStatement) {
            return visitor.visitStatement(this);
        } else {
            return visitor.visitChildren(this);
        }
    }
}


export class LetDeclContext extends antlr.ParserRuleContext {
    public constructor(parent: antlr.ParserRuleContext | null, invokingState: number) {
        super(parent, invokingState);
    }
    public IDENTIFIER(): antlr.TerminalNode {
        return this.getToken(RustParser.IDENTIFIER, 0)!;
    }
    public MUT(): antlr.TerminalNode | null {
        return this.getToken(RustParser.MUT, 0);
    }
    public typeExpr(): TypeExprContext | null {
        return this.getRuleContext(0, TypeExprContext);
    }
    public expr(): ExprContext | null {
        return this.getRuleContext(0, ExprContext);
    }
    public override get ruleIndex(): number {
        return RustParser.RULE_letDecl;
    }
    public override enterRule(listener: RustListener): void {
        if(listener.enterLetDecl) {
             listener.enterLetDecl(this);
        }
    }
    public override exitRule(listener: RustListener): void {
        if(listener.exitLetDecl) {
             listener.exitLetDecl(this);
        }
    }
    public override accept<Result>(visitor: RustVisitor<Result>): Result | null {
        if (visitor.visitLetDecl) {
            return visitor.visitLetDecl(this);
        } else {
            return visitor.visitChildren(this);
        }
    }
}


export class FnDeclContext extends antlr.ParserRuleContext {
    public constructor(parent: antlr.ParserRuleContext | null, invokingState: number) {
        super(parent, invokingState);
    }
    public IDENTIFIER(): antlr.TerminalNode {
        return this.getToken(RustParser.IDENTIFIER, 0)!;
    }
    public block(): BlockContext {
        return this.getRuleContext(0, BlockContext)!;
    }
    public paramList(): ParamListContext | null {
        return this.getRuleContext(0, ParamListContext);
    }
    public returnType(): ReturnTypeContext | null {
        return this.getRuleContext(0, ReturnTypeContext);
    }
    public override get ruleIndex(): number {
        return RustParser.RULE_fnDecl;
    }
    public override enterRule(listener: RustListener): void {
        if(listener.enterFnDecl) {
             listener.enterFnDecl(this);
        }
    }
    public override exitRule(listener: RustListener): void {
        if(listener.exitFnDecl) {
             listener.exitFnDecl(this);
        }
    }
    public override accept<Result>(visitor: RustVisitor<Result>): Result | null {
        if (visitor.visitFnDecl) {
            return visitor.visitFnDecl(this);
        } else {
            return visitor.visitChildren(this);
        }
    }
}


export class ParamListContext extends antlr.ParserRuleContext {
    public constructor(parent: antlr.ParserRuleContext | null, invokingState: number) {
        super(parent, invokingState);
    }
    public param(): ParamContext[];
    public param(i: number): ParamContext | null;
    public param(i?: number): ParamContext[] | ParamContext | null {
        if (i === undefined) {
            return this.getRuleContexts(ParamContext);
        }

        return this.getRuleContext(i, ParamContext);
    }
    public override get ruleIndex(): number {
        return RustParser.RULE_paramList;
    }
    public override enterRule(listener: RustListener): void {
        if(listener.enterParamList) {
             listener.enterParamList(this);
        }
    }
    public override exitRule(listener: RustListener): void {
        if(listener.exitParamList) {
             listener.exitParamList(this);
        }
    }
    public override accept<Result>(visitor: RustVisitor<Result>): Result | null {
        if (visitor.visitParamList) {
            return visitor.visitParamList(this);
        } else {
            return visitor.visitChildren(this);
        }
    }
}


export class ParamContext extends antlr.ParserRuleContext {
    public constructor(parent: antlr.ParserRuleContext | null, invokingState: number) {
        super(parent, invokingState);
    }
    public IDENTIFIER(): antlr.TerminalNode {
        return this.getToken(RustParser.IDENTIFIER, 0)!;
    }
    public typeExpr(): TypeExprContext {
        return this.getRuleContext(0, TypeExprContext)!;
    }
    public REF(): antlr.TerminalNode | null {
        return this.getToken(RustParser.REF, 0);
    }
    public MUT(): antlr.TerminalNode | null {
        return this.getToken(RustParser.MUT, 0);
    }
    public override get ruleIndex(): number {
        return RustParser.RULE_param;
    }
    public override enterRule(listener: RustListener): void {
        if(listener.enterParam) {
             listener.enterParam(this);
        }
    }
    public override exitRule(listener: RustListener): void {
        if(listener.exitParam) {
             listener.exitParam(this);
        }
    }
    public override accept<Result>(visitor: RustVisitor<Result>): Result | null {
        if (visitor.visitParam) {
            return visitor.visitParam(this);
        } else {
            return visitor.visitChildren(this);
        }
    }
}


export class ReturnTypeContext extends antlr.ParserRuleContext {
    public constructor(parent: antlr.ParserRuleContext | null, invokingState: number) {
        super(parent, invokingState);
    }
    public typeExpr(): TypeExprContext {
        return this.getRuleContext(0, TypeExprContext)!;
    }
    public override get ruleIndex(): number {
        return RustParser.RULE_returnType;
    }
    public override enterRule(listener: RustListener): void {
        if(listener.enterReturnType) {
             listener.enterReturnType(this);
        }
    }
    public override exitRule(listener: RustListener): void {
        if(listener.exitReturnType) {
             listener.exitReturnType(this);
        }
    }
    public override accept<Result>(visitor: RustVisitor<Result>): Result | null {
        if (visitor.visitReturnType) {
            return visitor.visitReturnType(this);
        } else {
            return visitor.visitChildren(this);
        }
    }
}


export class WhileLoopContext extends antlr.ParserRuleContext {
    public constructor(parent: antlr.ParserRuleContext | null, invokingState: number) {
        super(parent, invokingState);
    }
    public expr(): ExprContext {
        return this.getRuleContext(0, ExprContext)!;
    }
    public block(): BlockContext {
        return this.getRuleContext(0, BlockContext)!;
    }
    public override get ruleIndex(): number {
        return RustParser.RULE_whileLoop;
    }
    public override enterRule(listener: RustListener): void {
        if(listener.enterWhileLoop) {
             listener.enterWhileLoop(this);
        }
    }
    public override exitRule(listener: RustListener): void {
        if(listener.exitWhileLoop) {
             listener.exitWhileLoop(this);
        }
    }
    public override accept<Result>(visitor: RustVisitor<Result>): Result | null {
        if (visitor.visitWhileLoop) {
            return visitor.visitWhileLoop(this);
        } else {
            return visitor.visitChildren(this);
        }
    }
}


export class BlockContext extends antlr.ParserRuleContext {
    public constructor(parent: antlr.ParserRuleContext | null, invokingState: number) {
        super(parent, invokingState);
    }
    public statement(): StatementContext[];
    public statement(i: number): StatementContext | null;
    public statement(i?: number): StatementContext[] | StatementContext | null {
        if (i === undefined) {
            return this.getRuleContexts(StatementContext);
        }

        return this.getRuleContext(i, StatementContext);
    }
    public returnExpr(): ReturnExprContext | null {
        return this.getRuleContext(0, ReturnExprContext);
    }
    public override get ruleIndex(): number {
        return RustParser.RULE_block;
    }
    public override enterRule(listener: RustListener): void {
        if(listener.enterBlock) {
             listener.enterBlock(this);
        }
    }
    public override exitRule(listener: RustListener): void {
        if(listener.exitBlock) {
             listener.exitBlock(this);
        }
    }
    public override accept<Result>(visitor: RustVisitor<Result>): Result | null {
        if (visitor.visitBlock) {
            return visitor.visitBlock(this);
        } else {
            return visitor.visitChildren(this);
        }
    }
}


export class ReturnExprContext extends antlr.ParserRuleContext {
    public constructor(parent: antlr.ParserRuleContext | null, invokingState: number) {
        super(parent, invokingState);
    }
    public override get ruleIndex(): number {
        return RustParser.RULE_returnExpr;
    }
    public override copyFrom(ctx: ReturnExprContext): void {
        super.copyFrom(ctx);
    }
}
export class ImplicitReturnContext extends ReturnExprContext {
    public constructor(ctx: ReturnExprContext) {
        super(ctx.parent, ctx.invokingState);
        super.copyFrom(ctx);
    }
    public expr(): ExprContext {
        return this.getRuleContext(0, ExprContext)!;
    }
    public override enterRule(listener: RustListener): void {
        if(listener.enterImplicitReturn) {
             listener.enterImplicitReturn(this);
        }
    }
    public override exitRule(listener: RustListener): void {
        if(listener.exitImplicitReturn) {
             listener.exitImplicitReturn(this);
        }
    }
    public override accept<Result>(visitor: RustVisitor<Result>): Result | null {
        if (visitor.visitImplicitReturn) {
            return visitor.visitImplicitReturn(this);
        } else {
            return visitor.visitChildren(this);
        }
    }
}
export class ExplicitReturnContext extends ReturnExprContext {
    public constructor(ctx: ReturnExprContext) {
        super(ctx.parent, ctx.invokingState);
        super.copyFrom(ctx);
    }
    public expr(): ExprContext {
        return this.getRuleContext(0, ExprContext)!;
    }
    public override enterRule(listener: RustListener): void {
        if(listener.enterExplicitReturn) {
             listener.enterExplicitReturn(this);
        }
    }
    public override exitRule(listener: RustListener): void {
        if(listener.exitExplicitReturn) {
             listener.exitExplicitReturn(this);
        }
    }
    public override accept<Result>(visitor: RustVisitor<Result>): Result | null {
        if (visitor.visitExplicitReturn) {
            return visitor.visitExplicitReturn(this);
        } else {
            return visitor.visitChildren(this);
        }
    }
}


export class IfExprContext extends antlr.ParserRuleContext {
    public constructor(parent: antlr.ParserRuleContext | null, invokingState: number) {
        super(parent, invokingState);
    }
    public expr(): ExprContext {
        return this.getRuleContext(0, ExprContext)!;
    }
    public block(): BlockContext[];
    public block(i: number): BlockContext | null;
    public block(i?: number): BlockContext[] | BlockContext | null {
        if (i === undefined) {
            return this.getRuleContexts(BlockContext);
        }

        return this.getRuleContext(i, BlockContext);
    }
    public override get ruleIndex(): number {
        return RustParser.RULE_ifExpr;
    }
    public override enterRule(listener: RustListener): void {
        if(listener.enterIfExpr) {
             listener.enterIfExpr(this);
        }
    }
    public override exitRule(listener: RustListener): void {
        if(listener.exitIfExpr) {
             listener.exitIfExpr(this);
        }
    }
    public override accept<Result>(visitor: RustVisitor<Result>): Result | null {
        if (visitor.visitIfExpr) {
            return visitor.visitIfExpr(this);
        } else {
            return visitor.visitChildren(this);
        }
    }
}


export class ExprContext extends antlr.ParserRuleContext {
    public constructor(parent: antlr.ParserRuleContext | null, invokingState: number) {
        super(parent, invokingState);
    }
    public exprBinary(): ExprBinaryContext {
        return this.getRuleContext(0, ExprBinaryContext)!;
    }
    public override get ruleIndex(): number {
        return RustParser.RULE_expr;
    }
    public override enterRule(listener: RustListener): void {
        if(listener.enterExpr) {
             listener.enterExpr(this);
        }
    }
    public override exitRule(listener: RustListener): void {
        if(listener.exitExpr) {
             listener.exitExpr(this);
        }
    }
    public override accept<Result>(visitor: RustVisitor<Result>): Result | null {
        if (visitor.visitExpr) {
            return visitor.visitExpr(this);
        } else {
            return visitor.visitChildren(this);
        }
    }
}


export class ExprBinaryContext extends antlr.ParserRuleContext {
    public constructor(parent: antlr.ParserRuleContext | null, invokingState: number) {
        super(parent, invokingState);
    }
    public override get ruleIndex(): number {
        return RustParser.RULE_exprBinary;
    }
    public override copyFrom(ctx: ExprBinaryContext): void {
        super.copyFrom(ctx);
    }
}
export class BinaryExprContext extends ExprBinaryContext {
    public constructor(ctx: ExprBinaryContext) {
        super(ctx.parent, ctx.invokingState);
        super.copyFrom(ctx);
    }
    public exprUnary(): ExprUnaryContext[];
    public exprUnary(i: number): ExprUnaryContext | null;
    public exprUnary(i?: number): ExprUnaryContext[] | ExprUnaryContext | null {
        if (i === undefined) {
            return this.getRuleContexts(ExprUnaryContext);
        }

        return this.getRuleContext(i, ExprUnaryContext);
    }
    public binOp(): BinOpContext[];
    public binOp(i: number): BinOpContext | null;
    public binOp(i?: number): BinOpContext[] | BinOpContext | null {
        if (i === undefined) {
            return this.getRuleContexts(BinOpContext);
        }

        return this.getRuleContext(i, BinOpContext);
    }
    public override enterRule(listener: RustListener): void {
        if(listener.enterBinaryExpr) {
             listener.enterBinaryExpr(this);
        }
    }
    public override exitRule(listener: RustListener): void {
        if(listener.exitBinaryExpr) {
             listener.exitBinaryExpr(this);
        }
    }
    public override accept<Result>(visitor: RustVisitor<Result>): Result | null {
        if (visitor.visitBinaryExpr) {
            return visitor.visitBinaryExpr(this);
        } else {
            return visitor.visitChildren(this);
        }
    }
}


export class ExprUnaryContext extends antlr.ParserRuleContext {
    public constructor(parent: antlr.ParserRuleContext | null, invokingState: number) {
        super(parent, invokingState);
    }
    public override get ruleIndex(): number {
        return RustParser.RULE_exprUnary;
    }
    public override copyFrom(ctx: ExprUnaryContext): void {
        super.copyFrom(ctx);
    }
}
export class UnaryNotContext extends ExprUnaryContext {
    public constructor(ctx: ExprUnaryContext) {
        super(ctx.parent, ctx.invokingState);
        super.copyFrom(ctx);
    }
    public exprUnary(): ExprUnaryContext {
        return this.getRuleContext(0, ExprUnaryContext)!;
    }
    public override enterRule(listener: RustListener): void {
        if(listener.enterUnaryNot) {
             listener.enterUnaryNot(this);
        }
    }
    public override exitRule(listener: RustListener): void {
        if(listener.exitUnaryNot) {
             listener.exitUnaryNot(this);
        }
    }
    public override accept<Result>(visitor: RustVisitor<Result>): Result | null {
        if (visitor.visitUnaryNot) {
            return visitor.visitUnaryNot(this);
        } else {
            return visitor.visitChildren(this);
        }
    }
}
export class BorrowExprContext extends ExprUnaryContext {
    public constructor(ctx: ExprUnaryContext) {
        super(ctx.parent, ctx.invokingState);
        super.copyFrom(ctx);
    }
    public REF(): antlr.TerminalNode {
        return this.getToken(RustParser.REF, 0)!;
    }
    public exprUnary(): ExprUnaryContext {
        return this.getRuleContext(0, ExprUnaryContext)!;
    }
    public MUT(): antlr.TerminalNode | null {
        return this.getToken(RustParser.MUT, 0);
    }
    public override enterRule(listener: RustListener): void {
        if(listener.enterBorrowExpr) {
             listener.enterBorrowExpr(this);
        }
    }
    public override exitRule(listener: RustListener): void {
        if(listener.exitBorrowExpr) {
             listener.exitBorrowExpr(this);
        }
    }
    public override accept<Result>(visitor: RustVisitor<Result>): Result | null {
        if (visitor.visitBorrowExpr) {
            return visitor.visitBorrowExpr(this);
        } else {
            return visitor.visitChildren(this);
        }
    }
}
export class UnaryNegationContext extends ExprUnaryContext {
    public constructor(ctx: ExprUnaryContext) {
        super(ctx.parent, ctx.invokingState);
        super.copyFrom(ctx);
    }
    public exprUnary(): ExprUnaryContext {
        return this.getRuleContext(0, ExprUnaryContext)!;
    }
    public override enterRule(listener: RustListener): void {
        if(listener.enterUnaryNegation) {
             listener.enterUnaryNegation(this);
        }
    }
    public override exitRule(listener: RustListener): void {
        if(listener.exitUnaryNegation) {
             listener.exitUnaryNegation(this);
        }
    }
    public override accept<Result>(visitor: RustVisitor<Result>): Result | null {
        if (visitor.visitUnaryNegation) {
            return visitor.visitUnaryNegation(this);
        } else {
            return visitor.visitChildren(this);
        }
    }
}
export class UnaryToAtomContext extends ExprUnaryContext {
    public constructor(ctx: ExprUnaryContext) {
        super(ctx.parent, ctx.invokingState);
        super.copyFrom(ctx);
    }
    public exprAtom(): ExprAtomContext {
        return this.getRuleContext(0, ExprAtomContext)!;
    }
    public override enterRule(listener: RustListener): void {
        if(listener.enterUnaryToAtom) {
             listener.enterUnaryToAtom(this);
        }
    }
    public override exitRule(listener: RustListener): void {
        if(listener.exitUnaryToAtom) {
             listener.exitUnaryToAtom(this);
        }
    }
    public override accept<Result>(visitor: RustVisitor<Result>): Result | null {
        if (visitor.visitUnaryToAtom) {
            return visitor.visitUnaryToAtom(this);
        } else {
            return visitor.visitChildren(this);
        }
    }
}


export class ExprAtomContext extends antlr.ParserRuleContext {
    public constructor(parent: antlr.ParserRuleContext | null, invokingState: number) {
        super(parent, invokingState);
    }
    public override get ruleIndex(): number {
        return RustParser.RULE_exprAtom;
    }
    public override copyFrom(ctx: ExprAtomContext): void {
        super.copyFrom(ctx);
    }
}
export class IdentExprContext extends ExprAtomContext {
    public constructor(ctx: ExprAtomContext) {
        super(ctx.parent, ctx.invokingState);
        super.copyFrom(ctx);
    }
    public IDENTIFIER(): antlr.TerminalNode {
        return this.getToken(RustParser.IDENTIFIER, 0)!;
    }
    public override enterRule(listener: RustListener): void {
        if(listener.enterIdentExpr) {
             listener.enterIdentExpr(this);
        }
    }
    public override exitRule(listener: RustListener): void {
        if(listener.exitIdentExpr) {
             listener.exitIdentExpr(this);
        }
    }
    public override accept<Result>(visitor: RustVisitor<Result>): Result | null {
        if (visitor.visitIdentExpr) {
            return visitor.visitIdentExpr(this);
        } else {
            return visitor.visitChildren(this);
        }
    }
}
export class ParensExprContext extends ExprAtomContext {
    public constructor(ctx: ExprAtomContext) {
        super(ctx.parent, ctx.invokingState);
        super.copyFrom(ctx);
    }
    public expr(): ExprContext {
        return this.getRuleContext(0, ExprContext)!;
    }
    public override enterRule(listener: RustListener): void {
        if(listener.enterParensExpr) {
             listener.enterParensExpr(this);
        }
    }
    public override exitRule(listener: RustListener): void {
        if(listener.exitParensExpr) {
             listener.exitParensExpr(this);
        }
    }
    public override accept<Result>(visitor: RustVisitor<Result>): Result | null {
        if (visitor.visitParensExpr) {
            return visitor.visitParensExpr(this);
        } else {
            return visitor.visitChildren(this);
        }
    }
}
export class LiteralExprContext extends ExprAtomContext {
    public constructor(ctx: ExprAtomContext) {
        super(ctx.parent, ctx.invokingState);
        super.copyFrom(ctx);
    }
    public literal(): LiteralContext {
        return this.getRuleContext(0, LiteralContext)!;
    }
    public override enterRule(listener: RustListener): void {
        if(listener.enterLiteralExpr) {
             listener.enterLiteralExpr(this);
        }
    }
    public override exitRule(listener: RustListener): void {
        if(listener.exitLiteralExpr) {
             listener.exitLiteralExpr(this);
        }
    }
    public override accept<Result>(visitor: RustVisitor<Result>): Result | null {
        if (visitor.visitLiteralExpr) {
            return visitor.visitLiteralExpr(this);
        } else {
            return visitor.visitChildren(this);
        }
    }
}
export class FunctionCallContext extends ExprAtomContext {
    public constructor(ctx: ExprAtomContext) {
        super(ctx.parent, ctx.invokingState);
        super.copyFrom(ctx);
    }
    public IDENTIFIER(): antlr.TerminalNode {
        return this.getToken(RustParser.IDENTIFIER, 0)!;
    }
    public argList(): ArgListContext | null {
        return this.getRuleContext(0, ArgListContext);
    }
    public override enterRule(listener: RustListener): void {
        if(listener.enterFunctionCall) {
             listener.enterFunctionCall(this);
        }
    }
    public override exitRule(listener: RustListener): void {
        if(listener.exitFunctionCall) {
             listener.exitFunctionCall(this);
        }
    }
    public override accept<Result>(visitor: RustVisitor<Result>): Result | null {
        if (visitor.visitFunctionCall) {
            return visitor.visitFunctionCall(this);
        } else {
            return visitor.visitChildren(this);
        }
    }
}
export class MacroCallContext extends ExprAtomContext {
    public constructor(ctx: ExprAtomContext) {
        super(ctx.parent, ctx.invokingState);
        super.copyFrom(ctx);
    }
    public IDENTIFIER(): antlr.TerminalNode {
        return this.getToken(RustParser.IDENTIFIER, 0)!;
    }
    public argList(): ArgListContext | null {
        return this.getRuleContext(0, ArgListContext);
    }
    public override enterRule(listener: RustListener): void {
        if(listener.enterMacroCall) {
             listener.enterMacroCall(this);
        }
    }
    public override exitRule(listener: RustListener): void {
        if(listener.exitMacroCall) {
             listener.exitMacroCall(this);
        }
    }
    public override accept<Result>(visitor: RustVisitor<Result>): Result | null {
        if (visitor.visitMacroCall) {
            return visitor.visitMacroCall(this);
        } else {
            return visitor.visitChildren(this);
        }
    }
}


export class ArgListContext extends antlr.ParserRuleContext {
    public constructor(parent: antlr.ParserRuleContext | null, invokingState: number) {
        super(parent, invokingState);
    }
    public expr(): ExprContext[];
    public expr(i: number): ExprContext | null;
    public expr(i?: number): ExprContext[] | ExprContext | null {
        if (i === undefined) {
            return this.getRuleContexts(ExprContext);
        }

        return this.getRuleContext(i, ExprContext);
    }
    public override get ruleIndex(): number {
        return RustParser.RULE_argList;
    }
    public override enterRule(listener: RustListener): void {
        if(listener.enterArgList) {
             listener.enterArgList(this);
        }
    }
    public override exitRule(listener: RustListener): void {
        if(listener.exitArgList) {
             listener.exitArgList(this);
        }
    }
    public override accept<Result>(visitor: RustVisitor<Result>): Result | null {
        if (visitor.visitArgList) {
            return visitor.visitArgList(this);
        } else {
            return visitor.visitChildren(this);
        }
    }
}


export class BinOpContext extends antlr.ParserRuleContext {
    public constructor(parent: antlr.ParserRuleContext | null, invokingState: number) {
        super(parent, invokingState);
    }
    public override get ruleIndex(): number {
        return RustParser.RULE_binOp;
    }
    public override enterRule(listener: RustListener): void {
        if(listener.enterBinOp) {
             listener.enterBinOp(this);
        }
    }
    public override exitRule(listener: RustListener): void {
        if(listener.exitBinOp) {
             listener.exitBinOp(this);
        }
    }
    public override accept<Result>(visitor: RustVisitor<Result>): Result | null {
        if (visitor.visitBinOp) {
            return visitor.visitBinOp(this);
        } else {
            return visitor.visitChildren(this);
        }
    }
}


export class TypeExprContext extends antlr.ParserRuleContext {
    public constructor(parent: antlr.ParserRuleContext | null, invokingState: number) {
        super(parent, invokingState);
    }
    public override get ruleIndex(): number {
        return RustParser.RULE_typeExpr;
    }
    public override copyFrom(ctx: TypeExprContext): void {
        super.copyFrom(ctx);
    }
}
export class RefTypeContext extends TypeExprContext {
    public constructor(ctx: TypeExprContext) {
        super(ctx.parent, ctx.invokingState);
        super.copyFrom(ctx);
    }
    public REF(): antlr.TerminalNode {
        return this.getToken(RustParser.REF, 0)!;
    }
    public IDENTIFIER(): antlr.TerminalNode {
        return this.getToken(RustParser.IDENTIFIER, 0)!;
    }
    public MUT(): antlr.TerminalNode | null {
        return this.getToken(RustParser.MUT, 0);
    }
    public override enterRule(listener: RustListener): void {
        if(listener.enterRefType) {
             listener.enterRefType(this);
        }
    }
    public override exitRule(listener: RustListener): void {
        if(listener.exitRefType) {
             listener.exitRefType(this);
        }
    }
    public override accept<Result>(visitor: RustVisitor<Result>): Result | null {
        if (visitor.visitRefType) {
            return visitor.visitRefType(this);
        } else {
            return visitor.visitChildren(this);
        }
    }
}
export class BasicTypeContext extends TypeExprContext {
    public constructor(ctx: TypeExprContext) {
        super(ctx.parent, ctx.invokingState);
        super.copyFrom(ctx);
    }
    public IDENTIFIER(): antlr.TerminalNode {
        return this.getToken(RustParser.IDENTIFIER, 0)!;
    }
    public override enterRule(listener: RustListener): void {
        if(listener.enterBasicType) {
             listener.enterBasicType(this);
        }
    }
    public override exitRule(listener: RustListener): void {
        if(listener.exitBasicType) {
             listener.exitBasicType(this);
        }
    }
    public override accept<Result>(visitor: RustVisitor<Result>): Result | null {
        if (visitor.visitBasicType) {
            return visitor.visitBasicType(this);
        } else {
            return visitor.visitChildren(this);
        }
    }
}


export class LiteralContext extends antlr.ParserRuleContext {
    public constructor(parent: antlr.ParserRuleContext | null, invokingState: number) {
        super(parent, invokingState);
    }
    public INT(): antlr.TerminalNode | null {
        return this.getToken(RustParser.INT, 0);
    }
    public FLOAT(): antlr.TerminalNode | null {
        return this.getToken(RustParser.FLOAT, 0);
    }
    public STRING(): antlr.TerminalNode | null {
        return this.getToken(RustParser.STRING, 0);
    }
    public override get ruleIndex(): number {
        return RustParser.RULE_literal;
    }
    public override enterRule(listener: RustListener): void {
        if(listener.enterLiteral) {
             listener.enterLiteral(this);
        }
    }
    public override exitRule(listener: RustListener): void {
        if(listener.exitLiteral) {
             listener.exitLiteral(this);
        }
    }
    public override accept<Result>(visitor: RustVisitor<Result>): Result | null {
        if (visitor.visitLiteral) {
            return visitor.visitLiteral(this);
        } else {
            return visitor.visitChildren(this);
        }
    }
}
