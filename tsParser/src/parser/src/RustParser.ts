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
    public static readonly RETURN = 28;
    public static readonly MUT = 29;
    public static readonly REF = 30;
    public static readonly IDENTIFIER = 31;
    public static readonly INT = 32;
    public static readonly FLOAT = 33;
    public static readonly STRING = 34;
    public static readonly WS = 35;
    public static readonly COMMENT = 36;
    public static readonly RULE_program = 0;
    public static readonly RULE_statement = 1;
    public static readonly RULE_letDecl = 2;
    public static readonly RULE_assignment = 3;
    public static readonly RULE_fnDecl = 4;
    public static readonly RULE_paramList = 5;
    public static readonly RULE_param = 6;
    public static readonly RULE_returnType = 7;
    public static readonly RULE_whileLoop = 8;
    public static readonly RULE_block = 9;
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
        "'*'", "'+'", "'/'", "'=='", "'!='", "'<'", "'<='", "'>'", "'>='", 
        "'true'", "'false'", "'return'", "'mut'", "'&'"
    ];

    public static readonly symbolicNames = [
        null, null, null, null, null, null, null, null, null, null, null, 
        null, null, null, null, null, null, null, null, null, null, null, 
        null, null, null, null, null, null, "RETURN", "MUT", "REF", "IDENTIFIER", 
        "INT", "FLOAT", "STRING", "WS", "COMMENT"
    ];
    public static readonly ruleNames = [
        "program", "statement", "letDecl", "assignment", "fnDecl", "paramList", 
        "param", "returnType", "whileLoop", "block", "ifExpr", "expr", "exprBinary", 
        "exprUnary", "exprAtom", "argList", "binOp", "typeExpr", "literal",
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
            while ((((_la) & ~0x1F) === 0 && ((1 << _la) & 3691228260) !== 0) || ((((_la - 32)) & ~0x1F) === 0 && ((1 << (_la - 32)) & 7) !== 0)) {
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
            this.state = 59;
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
                this.assignment();
                this.state = 50;
                this.match(RustParser.T__0);
                }
                break;
            case 3:
                this.enterOuterAlt(localContext, 3);
                {
                this.state = 52;
                this.fnDecl();
                }
                break;
            case 4:
                this.enterOuterAlt(localContext, 4);
                {
                this.state = 53;
                this.whileLoop();
                }
                break;
            case 5:
                this.enterOuterAlt(localContext, 5);
                {
                this.state = 54;
                this.ifExpr();
                }
                break;
            case 6:
                this.enterOuterAlt(localContext, 6);
                {
                this.state = 55;
                this.block();
                }
                break;
            case 7:
                this.enterOuterAlt(localContext, 7);
                {
                this.state = 56;
                this.expr();
                this.state = 57;
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
    public letDecl(): LetDeclContext {
        let localContext = new LetDeclContext(this.context, this.state);
        this.enterRule(localContext, 4, RustParser.RULE_letDecl);
        let _la: number;
        try {
            this.enterOuterAlt(localContext, 1);
            {
            this.state = 61;
            this.match(RustParser.T__1);
            this.state = 63;
            this.errorHandler.sync(this);
            _la = this.tokenStream.LA(1);
            if (_la === 29) {
                {
                this.state = 62;
                this.match(RustParser.MUT);
                }
            }

            this.state = 65;
            this.match(RustParser.IDENTIFIER);
            this.state = 68;
            this.errorHandler.sync(this);
            _la = this.tokenStream.LA(1);
            if (_la === 3) {
                {
                this.state = 66;
                this.match(RustParser.T__2);
                this.state = 67;
                this.typeExpr();
                }
            }

            this.state = 72;
            this.errorHandler.sync(this);
            _la = this.tokenStream.LA(1);
            if (_la === 4) {
                {
                this.state = 70;
                this.match(RustParser.T__3);
                this.state = 71;
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
    public assignment(): AssignmentContext {
        let localContext = new AssignmentContext(this.context, this.state);
        this.enterRule(localContext, 6, RustParser.RULE_assignment);
        try {
            localContext = new AssignmentStmtContext(localContext);
            this.enterOuterAlt(localContext, 1);
            {
            this.state = 74;
            this.match(RustParser.IDENTIFIER);
            this.state = 75;
            this.match(RustParser.T__3);
            this.state = 76;
            this.expr();
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
        this.enterRule(localContext, 8, RustParser.RULE_fnDecl);
        let _la: number;
        try {
            this.enterOuterAlt(localContext, 1);
            {
            this.state = 78;
            this.match(RustParser.T__4);
            this.state = 79;
            this.match(RustParser.IDENTIFIER);
            this.state = 80;
            this.match(RustParser.T__5);
            this.state = 82;
            this.errorHandler.sync(this);
            _la = this.tokenStream.LA(1);
            if (_la === 31) {
                {
                this.state = 81;
                this.paramList();
                }
            }

            this.state = 84;
            this.match(RustParser.T__6);
            this.state = 86;
            this.errorHandler.sync(this);
            _la = this.tokenStream.LA(1);
            if (_la === 9) {
                {
                this.state = 85;
                this.returnType();
                }
            }

            this.state = 88;
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
        this.enterRule(localContext, 10, RustParser.RULE_paramList);
        let _la: number;
        try {
            this.enterOuterAlt(localContext, 1);
            {
            this.state = 90;
            this.param();
            this.state = 95;
            this.errorHandler.sync(this);
            _la = this.tokenStream.LA(1);
            while (_la === 8) {
                {
                {
                this.state = 91;
                this.match(RustParser.T__7);
                this.state = 92;
                this.param();
                }
                }
                this.state = 97;
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
        this.enterRule(localContext, 12, RustParser.RULE_param);
        try {
            this.enterOuterAlt(localContext, 1);
            {
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
        this.enterRule(localContext, 14, RustParser.RULE_returnType);
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
        this.enterRule(localContext, 16, RustParser.RULE_whileLoop);
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
        this.enterRule(localContext, 18, RustParser.RULE_block);
        let _la: number;
        try {
            this.enterOuterAlt(localContext, 1);
            {
            this.state = 109;
            this.match(RustParser.T__10);
            this.state = 113;
            this.errorHandler.sync(this);
            _la = this.tokenStream.LA(1);
            while ((((_la) & ~0x1F) === 0 && ((1 << _la) & 3691228260) !== 0) || ((((_la - 32)) & ~0x1F) === 0 && ((1 << (_la - 32)) & 7) !== 0)) {
                {
                {
                this.state = 110;
                this.statement();
                }
                }
                this.state = 115;
                this.errorHandler.sync(this);
                _la = this.tokenStream.LA(1);
            }
            this.state = 116;
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
    public ifExpr(): IfExprContext {
        let localContext = new IfExprContext(this.context, this.state);
        this.enterRule(localContext, 20, RustParser.RULE_ifExpr);
        let _la: number;
        try {
            this.enterOuterAlt(localContext, 1);
            {
            this.state = 118;
            this.match(RustParser.T__12);
            this.state = 119;
            this.expr();
            this.state = 120;
            this.block();
            this.state = 123;
            this.errorHandler.sync(this);
            _la = this.tokenStream.LA(1);
            if (_la === 14) {
                {
                this.state = 121;
                this.match(RustParser.T__13);
                this.state = 122;
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
            this.state = 125;
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
            this.state = 127;
            this.exprUnary();
            this.state = 133;
            this.errorHandler.sync(this);
            alternative = this.interpreter.adaptivePredict(this.tokenStream, 10, this.context);
            while (alternative !== 2 && alternative !== antlr.ATN.INVALID_ALT_NUMBER) {
                if (alternative === 1) {
                    {
                    {
                    this.state = 128;
                    this.binOp();
                    this.state = 129;
                    this.exprUnary();
                    }
                    }
                }
                this.state = 135;
                this.errorHandler.sync(this);
                alternative = this.interpreter.adaptivePredict(this.tokenStream, 10, this.context);
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
            this.state = 150;
            this.errorHandler.sync(this);
            switch (this.tokenStream.LA(1)) {
            case RustParser.T__14:
                localContext = new UnaryNegationContext(localContext);
                this.enterOuterAlt(localContext, 1);
                {
                this.state = 136;
                this.match(RustParser.T__14);
                this.state = 137;
                this.exprUnary();
                }
                break;
            case RustParser.T__15:
                localContext = new UnaryNotContext(localContext);
                this.enterOuterAlt(localContext, 2);
                {
                this.state = 138;
                this.match(RustParser.T__15);
                this.state = 139;
                this.exprUnary();
                }
                break;
            case RustParser.RETURN:
                localContext = new ReturnExprContext(localContext);
                this.enterOuterAlt(localContext, 3);
                {
                this.state = 140;
                this.match(RustParser.RETURN);
                this.state = 141;
                this.expr();
                }
                break;
            case RustParser.REF:
                localContext = new BorrowExprContext(localContext);
                this.enterOuterAlt(localContext, 4);
                {
                this.state = 142;
                this.match(RustParser.REF);
                this.state = 144;
                this.errorHandler.sync(this);
                _la = this.tokenStream.LA(1);
                if (_la === 29) {
                    {
                    this.state = 143;
                    this.match(RustParser.MUT);
                    }
                }

                this.state = 146;
                this.exprUnary();
                }
                break;
            case RustParser.T__16:
                localContext = new DerefExprContext(localContext);
                this.enterOuterAlt(localContext, 5);
                {
                this.state = 147;
                this.match(RustParser.T__16);
                this.state = 148;
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
                this.enterOuterAlt(localContext, 6);
                {
                this.state = 149;
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
            this.state = 171;
            this.errorHandler.sync(this);
            switch (this.interpreter.adaptivePredict(this.tokenStream, 15, this.context) ) {
            case 1:
                localContext = new FunctionCallContext(localContext);
                this.enterOuterAlt(localContext, 1);
                {
                this.state = 152;
                this.match(RustParser.IDENTIFIER);
                this.state = 153;
                this.match(RustParser.T__5);
                this.state = 155;
                this.errorHandler.sync(this);
                _la = this.tokenStream.LA(1);
                if (((((_la - 6)) & ~0x1F) === 0 && ((1 << (_la - 6)) & 527437313) !== 0)) {
                    {
                    this.state = 154;
                    this.argList();
                    }
                }

                this.state = 157;
                this.match(RustParser.T__6);
                }
                break;
            case 2:
                localContext = new MacroCallContext(localContext);
                this.enterOuterAlt(localContext, 2);
                {
                this.state = 158;
                this.match(RustParser.IDENTIFIER);
                this.state = 159;
                this.match(RustParser.T__15);
                this.state = 160;
                this.match(RustParser.T__5);
                this.state = 162;
                this.errorHandler.sync(this);
                _la = this.tokenStream.LA(1);
                if (((((_la - 6)) & ~0x1F) === 0 && ((1 << (_la - 6)) & 527437313) !== 0)) {
                    {
                    this.state = 161;
                    this.argList();
                    }
                }

                this.state = 164;
                this.match(RustParser.T__6);
                }
                break;
            case 3:
                localContext = new ParensExprContext(localContext);
                this.enterOuterAlt(localContext, 3);
                {
                this.state = 165;
                this.match(RustParser.T__5);
                this.state = 166;
                this.expr();
                this.state = 167;
                this.match(RustParser.T__6);
                }
                break;
            case 4:
                localContext = new LiteralExprContext(localContext);
                this.enterOuterAlt(localContext, 4);
                {
                this.state = 169;
                this.literal();
                }
                break;
            case 5:
                localContext = new IdentExprContext(localContext);
                this.enterOuterAlt(localContext, 5);
                {
                this.state = 170;
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
            this.state = 173;
            this.expr();
            this.state = 178;
            this.errorHandler.sync(this);
            _la = this.tokenStream.LA(1);
            while (_la === 8) {
                {
                {
                this.state = 174;
                this.match(RustParser.T__7);
                this.state = 175;
                this.expr();
                }
                }
                this.state = 180;
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
            this.state = 181;
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
            this.state = 189;
            this.errorHandler.sync(this);
            switch (this.tokenStream.LA(1)) {
            case RustParser.REF:
                localContext = new RefTypeContext(localContext);
                this.enterOuterAlt(localContext, 1);
                {
                this.state = 183;
                this.match(RustParser.REF);
                this.state = 185;
                this.errorHandler.sync(this);
                _la = this.tokenStream.LA(1);
                if (_la === 29) {
                    {
                    this.state = 184;
                    this.match(RustParser.MUT);
                    }
                }

                this.state = 187;
                this.typeExpr();
                }
                break;
            case RustParser.IDENTIFIER:
                localContext = new BasicTypeContext(localContext);
                this.enterOuterAlt(localContext, 2);
                {
                this.state = 188;
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
            this.state = 191;
            _la = this.tokenStream.LA(1);
            if(!(((((_la - 26)) & ~0x1F) === 0 && ((1 << (_la - 26)) & 451) !== 0))) {
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
        4,1,36,194,2,0,7,0,2,1,7,1,2,2,7,2,2,3,7,3,2,4,7,4,2,5,7,5,2,6,7,
        6,2,7,7,7,2,8,7,8,2,9,7,9,2,10,7,10,2,11,7,11,2,12,7,12,2,13,7,13,
        2,14,7,14,2,15,7,15,2,16,7,16,2,17,7,17,2,18,7,18,1,0,5,0,40,8,0,
        10,0,12,0,43,9,0,1,0,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
        1,1,1,1,1,1,3,1,60,8,1,1,2,1,2,3,2,64,8,2,1,2,1,2,1,2,3,2,69,8,2,
        1,2,1,2,3,2,73,8,2,1,3,1,3,1,3,1,3,1,4,1,4,1,4,1,4,3,4,83,8,4,1,
        4,1,4,3,4,87,8,4,1,4,1,4,1,5,1,5,1,5,5,5,94,8,5,10,5,12,5,97,9,5,
        1,6,1,6,1,6,1,6,1,7,1,7,1,7,1,8,1,8,1,8,1,8,1,9,1,9,5,9,112,8,9,
        10,9,12,9,115,9,9,1,9,1,9,1,10,1,10,1,10,1,10,1,10,3,10,124,8,10,
        1,11,1,11,1,12,1,12,1,12,1,12,5,12,132,8,12,10,12,12,12,135,9,12,
        1,13,1,13,1,13,1,13,1,13,1,13,1,13,1,13,3,13,145,8,13,1,13,1,13,
        1,13,1,13,3,13,151,8,13,1,14,1,14,1,14,3,14,156,8,14,1,14,1,14,1,
        14,1,14,1,14,3,14,163,8,14,1,14,1,14,1,14,1,14,1,14,1,14,1,14,3,
        14,172,8,14,1,15,1,15,1,15,5,15,177,8,15,10,15,12,15,180,9,15,1,
        16,1,16,1,17,1,17,3,17,186,8,17,1,17,1,17,3,17,190,8,17,1,18,1,18,
        1,18,0,0,19,0,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36,
        0,2,2,0,15,15,17,25,2,0,26,27,32,34,205,0,41,1,0,0,0,2,59,1,0,0,
        0,4,61,1,0,0,0,6,74,1,0,0,0,8,78,1,0,0,0,10,90,1,0,0,0,12,98,1,0,
        0,0,14,102,1,0,0,0,16,105,1,0,0,0,18,109,1,0,0,0,20,118,1,0,0,0,
        22,125,1,0,0,0,24,127,1,0,0,0,26,150,1,0,0,0,28,171,1,0,0,0,30,173,
        1,0,0,0,32,181,1,0,0,0,34,189,1,0,0,0,36,191,1,0,0,0,38,40,3,2,1,
        0,39,38,1,0,0,0,40,43,1,0,0,0,41,39,1,0,0,0,41,42,1,0,0,0,42,44,
        1,0,0,0,43,41,1,0,0,0,44,45,5,0,0,1,45,1,1,0,0,0,46,47,3,4,2,0,47,
        48,5,1,0,0,48,60,1,0,0,0,49,50,3,6,3,0,50,51,5,1,0,0,51,60,1,0,0,
        0,52,60,3,8,4,0,53,60,3,16,8,0,54,60,3,20,10,0,55,60,3,18,9,0,56,
        57,3,22,11,0,57,58,5,1,0,0,58,60,1,0,0,0,59,46,1,0,0,0,59,49,1,0,
        0,0,59,52,1,0,0,0,59,53,1,0,0,0,59,54,1,0,0,0,59,55,1,0,0,0,59,56,
        1,0,0,0,60,3,1,0,0,0,61,63,5,2,0,0,62,64,5,29,0,0,63,62,1,0,0,0,
        63,64,1,0,0,0,64,65,1,0,0,0,65,68,5,31,0,0,66,67,5,3,0,0,67,69,3,
        34,17,0,68,66,1,0,0,0,68,69,1,0,0,0,69,72,1,0,0,0,70,71,5,4,0,0,
        71,73,3,22,11,0,72,70,1,0,0,0,72,73,1,0,0,0,73,5,1,0,0,0,74,75,5,
        31,0,0,75,76,5,4,0,0,76,77,3,22,11,0,77,7,1,0,0,0,78,79,5,5,0,0,
        79,80,5,31,0,0,80,82,5,6,0,0,81,83,3,10,5,0,82,81,1,0,0,0,82,83,
        1,0,0,0,83,84,1,0,0,0,84,86,5,7,0,0,85,87,3,14,7,0,86,85,1,0,0,0,
        86,87,1,0,0,0,87,88,1,0,0,0,88,89,3,18,9,0,89,9,1,0,0,0,90,95,3,
        12,6,0,91,92,5,8,0,0,92,94,3,12,6,0,93,91,1,0,0,0,94,97,1,0,0,0,
        95,93,1,0,0,0,95,96,1,0,0,0,96,11,1,0,0,0,97,95,1,0,0,0,98,99,5,
        31,0,0,99,100,5,3,0,0,100,101,3,34,17,0,101,13,1,0,0,0,102,103,5,
        9,0,0,103,104,3,34,17,0,104,15,1,0,0,0,105,106,5,10,0,0,106,107,
        3,22,11,0,107,108,3,18,9,0,108,17,1,0,0,0,109,113,5,11,0,0,110,112,
        3,2,1,0,111,110,1,0,0,0,112,115,1,0,0,0,113,111,1,0,0,0,113,114,
        1,0,0,0,114,116,1,0,0,0,115,113,1,0,0,0,116,117,5,12,0,0,117,19,
        1,0,0,0,118,119,5,13,0,0,119,120,3,22,11,0,120,123,3,18,9,0,121,
        122,5,14,0,0,122,124,3,18,9,0,123,121,1,0,0,0,123,124,1,0,0,0,124,
        21,1,0,0,0,125,126,3,24,12,0,126,23,1,0,0,0,127,133,3,26,13,0,128,
        129,3,32,16,0,129,130,3,26,13,0,130,132,1,0,0,0,131,128,1,0,0,0,
        132,135,1,0,0,0,133,131,1,0,0,0,133,134,1,0,0,0,134,25,1,0,0,0,135,
        133,1,0,0,0,136,137,5,15,0,0,137,151,3,26,13,0,138,139,5,16,0,0,
        139,151,3,26,13,0,140,141,5,28,0,0,141,151,3,22,11,0,142,144,5,30,
        0,0,143,145,5,29,0,0,144,143,1,0,0,0,144,145,1,0,0,0,145,146,1,0,
        0,0,146,151,3,26,13,0,147,148,5,17,0,0,148,151,3,26,13,0,149,151,
        3,28,14,0,150,136,1,0,0,0,150,138,1,0,0,0,150,140,1,0,0,0,150,142,
        1,0,0,0,150,147,1,0,0,0,150,149,1,0,0,0,151,27,1,0,0,0,152,153,5,
        31,0,0,153,155,5,6,0,0,154,156,3,30,15,0,155,154,1,0,0,0,155,156,
        1,0,0,0,156,157,1,0,0,0,157,172,5,7,0,0,158,159,5,31,0,0,159,160,
        5,16,0,0,160,162,5,6,0,0,161,163,3,30,15,0,162,161,1,0,0,0,162,163,
        1,0,0,0,163,164,1,0,0,0,164,172,5,7,0,0,165,166,5,6,0,0,166,167,
        3,22,11,0,167,168,5,7,0,0,168,172,1,0,0,0,169,172,3,36,18,0,170,
        172,5,31,0,0,171,152,1,0,0,0,171,158,1,0,0,0,171,165,1,0,0,0,171,
        169,1,0,0,0,171,170,1,0,0,0,172,29,1,0,0,0,173,178,3,22,11,0,174,
        175,5,8,0,0,175,177,3,22,11,0,176,174,1,0,0,0,177,180,1,0,0,0,178,
        176,1,0,0,0,178,179,1,0,0,0,179,31,1,0,0,0,180,178,1,0,0,0,181,182,
        7,0,0,0,182,33,1,0,0,0,183,185,5,30,0,0,184,186,5,29,0,0,185,184,
        1,0,0,0,185,186,1,0,0,0,186,187,1,0,0,0,187,190,3,34,17,0,188,190,
        5,31,0,0,189,183,1,0,0,0,189,188,1,0,0,0,190,35,1,0,0,0,191,192,
        7,1,0,0,192,37,1,0,0,0,19,41,59,63,68,72,82,86,95,113,123,133,144,
        150,155,162,171,178,185,189
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
    public assignment(): AssignmentContext | null {
        return this.getRuleContext(0, AssignmentContext);
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


export class AssignmentContext extends antlr.ParserRuleContext {
    public constructor(parent: antlr.ParserRuleContext | null, invokingState: number) {
        super(parent, invokingState);
    }
    public override get ruleIndex(): number {
        return RustParser.RULE_assignment;
    }
    public override copyFrom(ctx: AssignmentContext): void {
        super.copyFrom(ctx);
    }
}
export class AssignmentStmtContext extends AssignmentContext {
    public constructor(ctx: AssignmentContext) {
        super(ctx.parent, ctx.invokingState);
        super.copyFrom(ctx);
    }
    public IDENTIFIER(): antlr.TerminalNode {
        return this.getToken(RustParser.IDENTIFIER, 0)!;
    }
    public expr(): ExprContext {
        return this.getRuleContext(0, ExprContext)!;
    }
    public override enterRule(listener: RustListener): void {
        if(listener.enterAssignmentStmt) {
             listener.enterAssignmentStmt(this);
        }
    }
    public override exitRule(listener: RustListener): void {
        if(listener.exitAssignmentStmt) {
             listener.exitAssignmentStmt(this);
        }
    }
    public override accept<Result>(visitor: RustVisitor<Result>): Result | null {
        if (visitor.visitAssignmentStmt) {
            return visitor.visitAssignmentStmt(this);
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
export class DerefExprContext extends ExprUnaryContext {
    public constructor(ctx: ExprUnaryContext) {
        super(ctx.parent, ctx.invokingState);
        super.copyFrom(ctx);
    }
    public exprUnary(): ExprUnaryContext {
        return this.getRuleContext(0, ExprUnaryContext)!;
    }
    public override enterRule(listener: RustListener): void {
        if(listener.enterDerefExpr) {
             listener.enterDerefExpr(this);
        }
    }
    public override exitRule(listener: RustListener): void {
        if(listener.exitDerefExpr) {
             listener.exitDerefExpr(this);
        }
    }
    public override accept<Result>(visitor: RustVisitor<Result>): Result | null {
        if (visitor.visitDerefExpr) {
            return visitor.visitDerefExpr(this);
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
export class ReturnExprContext extends ExprUnaryContext {
    public constructor(ctx: ExprUnaryContext) {
        super(ctx.parent, ctx.invokingState);
        super.copyFrom(ctx);
    }
    public RETURN(): antlr.TerminalNode {
        return this.getToken(RustParser.RETURN, 0)!;
    }
    public expr(): ExprContext {
        return this.getRuleContext(0, ExprContext)!;
    }
    public override enterRule(listener: RustListener): void {
        if(listener.enterReturnExpr) {
             listener.enterReturnExpr(this);
        }
    }
    public override exitRule(listener: RustListener): void {
        if(listener.exitReturnExpr) {
             listener.exitReturnExpr(this);
        }
    }
    public override accept<Result>(visitor: RustVisitor<Result>): Result | null {
        if (visitor.visitReturnExpr) {
            return visitor.visitReturnExpr(this);
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
    public typeExpr(): TypeExprContext {
        return this.getRuleContext(0, TypeExprContext)!;
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
