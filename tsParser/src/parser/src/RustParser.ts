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
    public static readonly RULE_fnDecl = 3;
    public static readonly RULE_paramList = 4;
    public static readonly RULE_param = 5;
    public static readonly RULE_returnType = 6;
    public static readonly RULE_whileLoop = 7;
    public static readonly RULE_block = 8;
    public static readonly RULE_ifExpr = 9;
    public static readonly RULE_expr = 10;
    public static readonly RULE_exprBinary = 11;
    public static readonly RULE_exprUnary = 12;
    public static readonly RULE_exprAtom = 13;
    public static readonly RULE_argList = 14;
    public static readonly RULE_binOp = 15;
    public static readonly RULE_typeExpr = 16;
    public static readonly RULE_literal = 17;

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
        "program", "statement", "letDecl", "fnDecl", "paramList", "param", 
        "returnType", "whileLoop", "block", "ifExpr", "expr", "exprBinary", 
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
            this.state = 39;
            this.errorHandler.sync(this);
            _la = this.tokenStream.LA(1);
            while ((((_la) & ~0x1F) === 0 && ((1 << _la) & 3691228260) !== 0) || ((((_la - 32)) & ~0x1F) === 0 && ((1 << (_la - 32)) & 7) !== 0)) {
                {
                {
                this.state = 36;
                this.statement();
                }
                }
                this.state = 41;
                this.errorHandler.sync(this);
                _la = this.tokenStream.LA(1);
            }
            this.state = 42;
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
            this.state = 54;
            this.errorHandler.sync(this);
            switch (this.tokenStream.LA(1)) {
            case RustParser.T__1:
                this.enterOuterAlt(localContext, 1);
                {
                this.state = 44;
                this.letDecl();
                this.state = 45;
                this.match(RustParser.T__0);
                }
                break;
            case RustParser.T__4:
                this.enterOuterAlt(localContext, 2);
                {
                this.state = 47;
                this.fnDecl();
                }
                break;
            case RustParser.T__9:
                this.enterOuterAlt(localContext, 3);
                {
                this.state = 48;
                this.whileLoop();
                }
                break;
            case RustParser.T__12:
                this.enterOuterAlt(localContext, 4);
                {
                this.state = 49;
                this.ifExpr();
                }
                break;
            case RustParser.T__10:
                this.enterOuterAlt(localContext, 5);
                {
                this.state = 50;
                this.block();
                }
                break;
            case RustParser.T__5:
            case RustParser.T__14:
            case RustParser.T__15:
            case RustParser.T__16:
            case RustParser.T__25:
            case RustParser.T__26:
            case RustParser.RETURN:
            case RustParser.REF:
            case RustParser.IDENTIFIER:
            case RustParser.INT:
            case RustParser.FLOAT:
            case RustParser.STRING:
                this.enterOuterAlt(localContext, 6);
                {
                this.state = 51;
                this.expr();
                this.state = 52;
                this.match(RustParser.T__0);
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
    public letDecl(): LetDeclContext {
        let localContext = new LetDeclContext(this.context, this.state);
        this.enterRule(localContext, 4, RustParser.RULE_letDecl);
        let _la: number;
        try {
            this.enterOuterAlt(localContext, 1);
            {
            this.state = 56;
            this.match(RustParser.T__1);
            this.state = 58;
            this.errorHandler.sync(this);
            _la = this.tokenStream.LA(1);
            if (_la === 29) {
                {
                this.state = 57;
                this.match(RustParser.MUT);
                }
            }

            this.state = 60;
            this.match(RustParser.IDENTIFIER);
            this.state = 63;
            this.errorHandler.sync(this);
            _la = this.tokenStream.LA(1);
            if (_la === 3) {
                {
                this.state = 61;
                this.match(RustParser.T__2);
                this.state = 62;
                this.typeExpr();
                }
            }

            this.state = 67;
            this.errorHandler.sync(this);
            _la = this.tokenStream.LA(1);
            if (_la === 4) {
                {
                this.state = 65;
                this.match(RustParser.T__3);
                this.state = 66;
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
            this.state = 69;
            this.match(RustParser.T__4);
            this.state = 70;
            this.match(RustParser.IDENTIFIER);
            this.state = 71;
            this.match(RustParser.T__5);
            this.state = 73;
            this.errorHandler.sync(this);
            _la = this.tokenStream.LA(1);
            if (_la === 31) {
                {
                this.state = 72;
                this.paramList();
                }
            }

            this.state = 75;
            this.match(RustParser.T__6);
            this.state = 77;
            this.errorHandler.sync(this);
            _la = this.tokenStream.LA(1);
            if (_la === 9) {
                {
                this.state = 76;
                this.returnType();
                }
            }

            this.state = 79;
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
            this.state = 81;
            this.param();
            this.state = 86;
            this.errorHandler.sync(this);
            _la = this.tokenStream.LA(1);
            while (_la === 8) {
                {
                {
                this.state = 82;
                this.match(RustParser.T__7);
                this.state = 83;
                this.param();
                }
                }
                this.state = 88;
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
        try {
            this.enterOuterAlt(localContext, 1);
            {
            this.state = 89;
            this.match(RustParser.IDENTIFIER);
            this.state = 90;
            this.match(RustParser.T__2);
            this.state = 91;
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
            this.state = 93;
            this.match(RustParser.T__8);
            this.state = 94;
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
            this.state = 96;
            this.match(RustParser.T__9);
            this.state = 97;
            this.expr();
            this.state = 98;
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
            this.enterOuterAlt(localContext, 1);
            {
            this.state = 100;
            this.match(RustParser.T__10);
            this.state = 104;
            this.errorHandler.sync(this);
            _la = this.tokenStream.LA(1);
            while ((((_la) & ~0x1F) === 0 && ((1 << _la) & 3691228260) !== 0) || ((((_la - 32)) & ~0x1F) === 0 && ((1 << (_la - 32)) & 7) !== 0)) {
                {
                {
                this.state = 101;
                this.statement();
                }
                }
                this.state = 106;
                this.errorHandler.sync(this);
                _la = this.tokenStream.LA(1);
            }
            this.state = 107;
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
        this.enterRule(localContext, 18, RustParser.RULE_ifExpr);
        let _la: number;
        try {
            this.enterOuterAlt(localContext, 1);
            {
            this.state = 109;
            this.match(RustParser.T__12);
            this.state = 110;
            this.expr();
            this.state = 111;
            this.block();
            this.state = 114;
            this.errorHandler.sync(this);
            _la = this.tokenStream.LA(1);
            if (_la === 14) {
                {
                this.state = 112;
                this.match(RustParser.T__13);
                this.state = 113;
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
        this.enterRule(localContext, 20, RustParser.RULE_expr);
        try {
            this.enterOuterAlt(localContext, 1);
            {
            this.state = 116;
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
        this.enterRule(localContext, 22, RustParser.RULE_exprBinary);
        try {
            let alternative: number;
            localContext = new BinaryExprContext(localContext);
            this.enterOuterAlt(localContext, 1);
            {
            this.state = 118;
            this.exprUnary();
            this.state = 124;
            this.errorHandler.sync(this);
            alternative = this.interpreter.adaptivePredict(this.tokenStream, 10, this.context);
            while (alternative !== 2 && alternative !== antlr.ATN.INVALID_ALT_NUMBER) {
                if (alternative === 1) {
                    {
                    {
                    this.state = 119;
                    this.binOp();
                    this.state = 120;
                    this.exprUnary();
                    }
                    }
                }
                this.state = 126;
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
        this.enterRule(localContext, 24, RustParser.RULE_exprUnary);
        let _la: number;
        try {
            this.state = 141;
            this.errorHandler.sync(this);
            switch (this.tokenStream.LA(1)) {
            case RustParser.T__14:
                localContext = new UnaryNegationContext(localContext);
                this.enterOuterAlt(localContext, 1);
                {
                this.state = 127;
                this.match(RustParser.T__14);
                this.state = 128;
                this.exprUnary();
                }
                break;
            case RustParser.T__15:
                localContext = new UnaryNotContext(localContext);
                this.enterOuterAlt(localContext, 2);
                {
                this.state = 129;
                this.match(RustParser.T__15);
                this.state = 130;
                this.exprUnary();
                }
                break;
            case RustParser.RETURN:
                localContext = new ReturnExprContext(localContext);
                this.enterOuterAlt(localContext, 3);
                {
                this.state = 131;
                this.match(RustParser.RETURN);
                this.state = 132;
                this.expr();
                }
                break;
            case RustParser.REF:
                localContext = new BorrowExprContext(localContext);
                this.enterOuterAlt(localContext, 4);
                {
                this.state = 133;
                this.match(RustParser.REF);
                this.state = 135;
                this.errorHandler.sync(this);
                _la = this.tokenStream.LA(1);
                if (_la === 29) {
                    {
                    this.state = 134;
                    this.match(RustParser.MUT);
                    }
                }

                this.state = 137;
                this.exprUnary();
                }
                break;
            case RustParser.T__16:
                localContext = new DerefExprContext(localContext);
                this.enterOuterAlt(localContext, 5);
                {
                this.state = 138;
                this.match(RustParser.T__16);
                this.state = 139;
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
                this.state = 140;
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
        this.enterRule(localContext, 26, RustParser.RULE_exprAtom);
        let _la: number;
        try {
            this.state = 162;
            this.errorHandler.sync(this);
            switch (this.interpreter.adaptivePredict(this.tokenStream, 15, this.context) ) {
            case 1:
                localContext = new FunctionCallContext(localContext);
                this.enterOuterAlt(localContext, 1);
                {
                this.state = 143;
                this.match(RustParser.IDENTIFIER);
                this.state = 144;
                this.match(RustParser.T__5);
                this.state = 146;
                this.errorHandler.sync(this);
                _la = this.tokenStream.LA(1);
                if (((((_la - 6)) & ~0x1F) === 0 && ((1 << (_la - 6)) & 527437313) !== 0)) {
                    {
                    this.state = 145;
                    this.argList();
                    }
                }

                this.state = 148;
                this.match(RustParser.T__6);
                }
                break;
            case 2:
                localContext = new MacroCallContext(localContext);
                this.enterOuterAlt(localContext, 2);
                {
                this.state = 149;
                this.match(RustParser.IDENTIFIER);
                this.state = 150;
                this.match(RustParser.T__15);
                this.state = 151;
                this.match(RustParser.T__5);
                this.state = 153;
                this.errorHandler.sync(this);
                _la = this.tokenStream.LA(1);
                if (((((_la - 6)) & ~0x1F) === 0 && ((1 << (_la - 6)) & 527437313) !== 0)) {
                    {
                    this.state = 152;
                    this.argList();
                    }
                }

                this.state = 155;
                this.match(RustParser.T__6);
                }
                break;
            case 3:
                localContext = new ParensExprContext(localContext);
                this.enterOuterAlt(localContext, 3);
                {
                this.state = 156;
                this.match(RustParser.T__5);
                this.state = 157;
                this.expr();
                this.state = 158;
                this.match(RustParser.T__6);
                }
                break;
            case 4:
                localContext = new LiteralExprContext(localContext);
                this.enterOuterAlt(localContext, 4);
                {
                this.state = 160;
                this.literal();
                }
                break;
            case 5:
                localContext = new IdentExprContext(localContext);
                this.enterOuterAlt(localContext, 5);
                {
                this.state = 161;
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
        this.enterRule(localContext, 28, RustParser.RULE_argList);
        let _la: number;
        try {
            this.enterOuterAlt(localContext, 1);
            {
            this.state = 164;
            this.expr();
            this.state = 169;
            this.errorHandler.sync(this);
            _la = this.tokenStream.LA(1);
            while (_la === 8) {
                {
                {
                this.state = 165;
                this.match(RustParser.T__7);
                this.state = 166;
                this.expr();
                }
                }
                this.state = 171;
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
        this.enterRule(localContext, 30, RustParser.RULE_binOp);
        let _la: number;
        try {
            this.enterOuterAlt(localContext, 1);
            {
            this.state = 172;
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
        this.enterRule(localContext, 32, RustParser.RULE_typeExpr);
        let _la: number;
        try {
            this.state = 180;
            this.errorHandler.sync(this);
            switch (this.tokenStream.LA(1)) {
            case RustParser.REF:
                localContext = new RefTypeContext(localContext);
                this.enterOuterAlt(localContext, 1);
                {
                this.state = 174;
                this.match(RustParser.REF);
                this.state = 176;
                this.errorHandler.sync(this);
                _la = this.tokenStream.LA(1);
                if (_la === 29) {
                    {
                    this.state = 175;
                    this.match(RustParser.MUT);
                    }
                }

                this.state = 178;
                this.typeExpr();
                }
                break;
            case RustParser.IDENTIFIER:
                localContext = new BasicTypeContext(localContext);
                this.enterOuterAlt(localContext, 2);
                {
                this.state = 179;
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
        this.enterRule(localContext, 34, RustParser.RULE_literal);
        let _la: number;
        try {
            this.enterOuterAlt(localContext, 1);
            {
            this.state = 182;
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
        4,1,36,185,2,0,7,0,2,1,7,1,2,2,7,2,2,3,7,3,2,4,7,4,2,5,7,5,2,6,7,
        6,2,7,7,7,2,8,7,8,2,9,7,9,2,10,7,10,2,11,7,11,2,12,7,12,2,13,7,13,
        2,14,7,14,2,15,7,15,2,16,7,16,2,17,7,17,1,0,5,0,38,8,0,10,0,12,0,
        41,9,0,1,0,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,1,55,8,
        1,1,2,1,2,3,2,59,8,2,1,2,1,2,1,2,3,2,64,8,2,1,2,1,2,3,2,68,8,2,1,
        3,1,3,1,3,1,3,3,3,74,8,3,1,3,1,3,3,3,78,8,3,1,3,1,3,1,4,1,4,1,4,
        5,4,85,8,4,10,4,12,4,88,9,4,1,5,1,5,1,5,1,5,1,6,1,6,1,6,1,7,1,7,
        1,7,1,7,1,8,1,8,5,8,103,8,8,10,8,12,8,106,9,8,1,8,1,8,1,9,1,9,1,
        9,1,9,1,9,3,9,115,8,9,1,10,1,10,1,11,1,11,1,11,1,11,5,11,123,8,11,
        10,11,12,11,126,9,11,1,12,1,12,1,12,1,12,1,12,1,12,1,12,1,12,3,12,
        136,8,12,1,12,1,12,1,12,1,12,3,12,142,8,12,1,13,1,13,1,13,3,13,147,
        8,13,1,13,1,13,1,13,1,13,1,13,3,13,154,8,13,1,13,1,13,1,13,1,13,
        1,13,1,13,1,13,3,13,163,8,13,1,14,1,14,1,14,5,14,168,8,14,10,14,
        12,14,171,9,14,1,15,1,15,1,16,1,16,3,16,177,8,16,1,16,1,16,3,16,
        181,8,16,1,17,1,17,1,17,0,0,18,0,2,4,6,8,10,12,14,16,18,20,22,24,
        26,28,30,32,34,0,2,2,0,15,15,17,25,2,0,26,27,32,34,196,0,39,1,0,
        0,0,2,54,1,0,0,0,4,56,1,0,0,0,6,69,1,0,0,0,8,81,1,0,0,0,10,89,1,
        0,0,0,12,93,1,0,0,0,14,96,1,0,0,0,16,100,1,0,0,0,18,109,1,0,0,0,
        20,116,1,0,0,0,22,118,1,0,0,0,24,141,1,0,0,0,26,162,1,0,0,0,28,164,
        1,0,0,0,30,172,1,0,0,0,32,180,1,0,0,0,34,182,1,0,0,0,36,38,3,2,1,
        0,37,36,1,0,0,0,38,41,1,0,0,0,39,37,1,0,0,0,39,40,1,0,0,0,40,42,
        1,0,0,0,41,39,1,0,0,0,42,43,5,0,0,1,43,1,1,0,0,0,44,45,3,4,2,0,45,
        46,5,1,0,0,46,55,1,0,0,0,47,55,3,6,3,0,48,55,3,14,7,0,49,55,3,18,
        9,0,50,55,3,16,8,0,51,52,3,20,10,0,52,53,5,1,0,0,53,55,1,0,0,0,54,
        44,1,0,0,0,54,47,1,0,0,0,54,48,1,0,0,0,54,49,1,0,0,0,54,50,1,0,0,
        0,54,51,1,0,0,0,55,3,1,0,0,0,56,58,5,2,0,0,57,59,5,29,0,0,58,57,
        1,0,0,0,58,59,1,0,0,0,59,60,1,0,0,0,60,63,5,31,0,0,61,62,5,3,0,0,
        62,64,3,32,16,0,63,61,1,0,0,0,63,64,1,0,0,0,64,67,1,0,0,0,65,66,
        5,4,0,0,66,68,3,20,10,0,67,65,1,0,0,0,67,68,1,0,0,0,68,5,1,0,0,0,
        69,70,5,5,0,0,70,71,5,31,0,0,71,73,5,6,0,0,72,74,3,8,4,0,73,72,1,
        0,0,0,73,74,1,0,0,0,74,75,1,0,0,0,75,77,5,7,0,0,76,78,3,12,6,0,77,
        76,1,0,0,0,77,78,1,0,0,0,78,79,1,0,0,0,79,80,3,16,8,0,80,7,1,0,0,
        0,81,86,3,10,5,0,82,83,5,8,0,0,83,85,3,10,5,0,84,82,1,0,0,0,85,88,
        1,0,0,0,86,84,1,0,0,0,86,87,1,0,0,0,87,9,1,0,0,0,88,86,1,0,0,0,89,
        90,5,31,0,0,90,91,5,3,0,0,91,92,3,32,16,0,92,11,1,0,0,0,93,94,5,
        9,0,0,94,95,3,32,16,0,95,13,1,0,0,0,96,97,5,10,0,0,97,98,3,20,10,
        0,98,99,3,16,8,0,99,15,1,0,0,0,100,104,5,11,0,0,101,103,3,2,1,0,
        102,101,1,0,0,0,103,106,1,0,0,0,104,102,1,0,0,0,104,105,1,0,0,0,
        105,107,1,0,0,0,106,104,1,0,0,0,107,108,5,12,0,0,108,17,1,0,0,0,
        109,110,5,13,0,0,110,111,3,20,10,0,111,114,3,16,8,0,112,113,5,14,
        0,0,113,115,3,16,8,0,114,112,1,0,0,0,114,115,1,0,0,0,115,19,1,0,
        0,0,116,117,3,22,11,0,117,21,1,0,0,0,118,124,3,24,12,0,119,120,3,
        30,15,0,120,121,3,24,12,0,121,123,1,0,0,0,122,119,1,0,0,0,123,126,
        1,0,0,0,124,122,1,0,0,0,124,125,1,0,0,0,125,23,1,0,0,0,126,124,1,
        0,0,0,127,128,5,15,0,0,128,142,3,24,12,0,129,130,5,16,0,0,130,142,
        3,24,12,0,131,132,5,28,0,0,132,142,3,20,10,0,133,135,5,30,0,0,134,
        136,5,29,0,0,135,134,1,0,0,0,135,136,1,0,0,0,136,137,1,0,0,0,137,
        142,3,24,12,0,138,139,5,17,0,0,139,142,3,24,12,0,140,142,3,26,13,
        0,141,127,1,0,0,0,141,129,1,0,0,0,141,131,1,0,0,0,141,133,1,0,0,
        0,141,138,1,0,0,0,141,140,1,0,0,0,142,25,1,0,0,0,143,144,5,31,0,
        0,144,146,5,6,0,0,145,147,3,28,14,0,146,145,1,0,0,0,146,147,1,0,
        0,0,147,148,1,0,0,0,148,163,5,7,0,0,149,150,5,31,0,0,150,151,5,16,
        0,0,151,153,5,6,0,0,152,154,3,28,14,0,153,152,1,0,0,0,153,154,1,
        0,0,0,154,155,1,0,0,0,155,163,5,7,0,0,156,157,5,6,0,0,157,158,3,
        20,10,0,158,159,5,7,0,0,159,163,1,0,0,0,160,163,3,34,17,0,161,163,
        5,31,0,0,162,143,1,0,0,0,162,149,1,0,0,0,162,156,1,0,0,0,162,160,
        1,0,0,0,162,161,1,0,0,0,163,27,1,0,0,0,164,169,3,20,10,0,165,166,
        5,8,0,0,166,168,3,20,10,0,167,165,1,0,0,0,168,171,1,0,0,0,169,167,
        1,0,0,0,169,170,1,0,0,0,170,29,1,0,0,0,171,169,1,0,0,0,172,173,7,
        0,0,0,173,31,1,0,0,0,174,176,5,30,0,0,175,177,5,29,0,0,176,175,1,
        0,0,0,176,177,1,0,0,0,177,178,1,0,0,0,178,181,3,32,16,0,179,181,
        5,31,0,0,180,174,1,0,0,0,180,179,1,0,0,0,181,33,1,0,0,0,182,183,
        7,1,0,0,183,35,1,0,0,0,19,39,54,58,63,67,73,77,86,104,114,124,135,
        141,146,153,162,169,176,180
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
