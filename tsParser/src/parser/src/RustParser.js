// Generated from src/Rust.g4 by ANTLR 4.13.1
import * as antlr from "antlr4ng";
class RustParser extends antlr.Parser {
    get grammarFileName() { return "Rust.g4"; }
    get literalNames() { return RustParser.literalNames; }
    get symbolicNames() { return RustParser.symbolicNames; }
    get ruleNames() { return RustParser.ruleNames; }
    get serializedATN() { return RustParser._serializedATN; }
    createFailedPredicateException(predicate, message) {
        return new antlr.FailedPredicateException(this, predicate, message);
    }
    constructor(input) {
        super(input);
        this.interpreter = new antlr.ParserATNSimulator(this, RustParser._ATN, RustParser.decisionsToDFA, new antlr.PredictionContextCache());
    }
    program() {
        let localContext = new ProgramContext(this.context, this.state);
        this.enterRule(localContext, 0, RustParser.RULE_program);
        let _la;
        try {
            this.enterOuterAlt(localContext, 1);
            {
                this.state = 41;
                this.errorHandler.sync(this);
                _la = this.tokenStream.LA(1);
                while (((((_la - 2)) & ~0x1F) === 0 && ((1 << (_la - 2)) & 4227978801) !== 0)) {
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
            }
            else {
                throw re;
            }
        }
        finally {
            this.exitRule();
        }
        return localContext;
    }
    statement() {
        let localContext = new StatementContext(this.context, this.state);
        this.enterRule(localContext, 2, RustParser.RULE_statement);
        try {
            this.state = 57;
            this.errorHandler.sync(this);
            switch (this.interpreter.adaptivePredict(this.tokenStream, 1, this.context)) {
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
            }
            else {
                throw re;
            }
        }
        finally {
            this.exitRule();
        }
        return localContext;
    }
    letDecl() {
        let localContext = new LetDeclContext(this.context, this.state);
        this.enterRule(localContext, 4, RustParser.RULE_letDecl);
        let _la;
        try {
            this.enterOuterAlt(localContext, 1);
            {
                this.state = 59;
                this.match(RustParser.T__1);
                this.state = 61;
                this.errorHandler.sync(this);
                _la = this.tokenStream.LA(1);
                if (_la === 3) {
                    {
                        this.state = 60;
                        this.match(RustParser.T__2);
                    }
                }
                this.state = 63;
                this.match(RustParser.IDENTIFIER);
                this.state = 66;
                this.errorHandler.sync(this);
                _la = this.tokenStream.LA(1);
                if (_la === 4) {
                    {
                        this.state = 64;
                        this.match(RustParser.T__3);
                        this.state = 65;
                        this.typeExpr();
                    }
                }
                this.state = 70;
                this.errorHandler.sync(this);
                _la = this.tokenStream.LA(1);
                if (_la === 5) {
                    {
                        this.state = 68;
                        this.match(RustParser.T__4);
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
            }
            else {
                throw re;
            }
        }
        finally {
            this.exitRule();
        }
        return localContext;
    }
    fnDecl() {
        let localContext = new FnDeclContext(this.context, this.state);
        this.enterRule(localContext, 6, RustParser.RULE_fnDecl);
        let _la;
        try {
            this.enterOuterAlt(localContext, 1);
            {
                this.state = 72;
                this.match(RustParser.T__5);
                this.state = 73;
                this.match(RustParser.IDENTIFIER);
                this.state = 74;
                this.match(RustParser.T__6);
                this.state = 76;
                this.errorHandler.sync(this);
                _la = this.tokenStream.LA(1);
                if (_la === 30) {
                    {
                        this.state = 75;
                        this.paramList();
                    }
                }
                this.state = 78;
                this.match(RustParser.T__7);
                this.state = 80;
                this.errorHandler.sync(this);
                _la = this.tokenStream.LA(1);
                if (_la === 10) {
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
            }
            else {
                throw re;
            }
        }
        finally {
            this.exitRule();
        }
        return localContext;
    }
    paramList() {
        let localContext = new ParamListContext(this.context, this.state);
        this.enterRule(localContext, 8, RustParser.RULE_paramList);
        let _la;
        try {
            this.enterOuterAlt(localContext, 1);
            {
                this.state = 84;
                this.param();
                this.state = 89;
                this.errorHandler.sync(this);
                _la = this.tokenStream.LA(1);
                while (_la === 9) {
                    {
                        {
                            this.state = 85;
                            this.match(RustParser.T__8);
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
            }
            else {
                throw re;
            }
        }
        finally {
            this.exitRule();
        }
        return localContext;
    }
    param() {
        let localContext = new ParamContext(this.context, this.state);
        this.enterRule(localContext, 10, RustParser.RULE_param);
        try {
            this.enterOuterAlt(localContext, 1);
            {
                this.state = 92;
                this.match(RustParser.IDENTIFIER);
                this.state = 93;
                this.match(RustParser.T__3);
                this.state = 94;
                this.typeExpr();
            }
        }
        catch (re) {
            if (re instanceof antlr.RecognitionException) {
                this.errorHandler.reportError(this, re);
                this.errorHandler.recover(this, re);
            }
            else {
                throw re;
            }
        }
        finally {
            this.exitRule();
        }
        return localContext;
    }
    returnType() {
        let localContext = new ReturnTypeContext(this.context, this.state);
        this.enterRule(localContext, 12, RustParser.RULE_returnType);
        try {
            this.enterOuterAlt(localContext, 1);
            {
                this.state = 96;
                this.match(RustParser.T__9);
                this.state = 97;
                this.typeExpr();
            }
        }
        catch (re) {
            if (re instanceof antlr.RecognitionException) {
                this.errorHandler.reportError(this, re);
                this.errorHandler.recover(this, re);
            }
            else {
                throw re;
            }
        }
        finally {
            this.exitRule();
        }
        return localContext;
    }
    whileLoop() {
        let localContext = new WhileLoopContext(this.context, this.state);
        this.enterRule(localContext, 14, RustParser.RULE_whileLoop);
        try {
            this.enterOuterAlt(localContext, 1);
            {
                this.state = 99;
                this.match(RustParser.T__10);
                this.state = 100;
                this.expr();
                this.state = 101;
                this.block();
            }
        }
        catch (re) {
            if (re instanceof antlr.RecognitionException) {
                this.errorHandler.reportError(this, re);
                this.errorHandler.recover(this, re);
            }
            else {
                throw re;
            }
        }
        finally {
            this.exitRule();
        }
        return localContext;
    }
    block() {
        let localContext = new BlockContext(this.context, this.state);
        this.enterRule(localContext, 16, RustParser.RULE_block);
        let _la;
        try {
            let alternative;
            this.enterOuterAlt(localContext, 1);
            {
                this.state = 103;
                this.match(RustParser.T__11);
                this.state = 107;
                this.errorHandler.sync(this);
                alternative = this.interpreter.adaptivePredict(this.tokenStream, 8, this.context);
                while (alternative !== 2 && alternative !== antlr.ATN.INVALID_ALT_NUMBER) {
                    if (alternative === 1) {
                        {
                            {
                                this.state = 104;
                                this.statement();
                            }
                        }
                    }
                    this.state = 109;
                    this.errorHandler.sync(this);
                    alternative = this.interpreter.adaptivePredict(this.tokenStream, 8, this.context);
                }
                this.state = 111;
                this.errorHandler.sync(this);
                _la = this.tokenStream.LA(1);
                if (((((_la - 7)) & ~0x1F) === 0 && ((1 << (_la - 7)) & 132124161) !== 0)) {
                    {
                        this.state = 110;
                        this.returnExpr();
                    }
                }
                this.state = 113;
                this.match(RustParser.T__12);
            }
        }
        catch (re) {
            if (re instanceof antlr.RecognitionException) {
                this.errorHandler.reportError(this, re);
                this.errorHandler.recover(this, re);
            }
            else {
                throw re;
            }
        }
        finally {
            this.exitRule();
        }
        return localContext;
    }
    returnExpr() {
        let localContext = new ReturnExprContext(this.context, this.state);
        this.enterRule(localContext, 18, RustParser.RULE_returnExpr);
        try {
            this.state = 119;
            this.errorHandler.sync(this);
            switch (this.interpreter.adaptivePredict(this.tokenStream, 10, this.context)) {
                case 1:
                    localContext = new ImplicitReturnContext(localContext);
                    this.enterOuterAlt(localContext, 1);
                    {
                        this.state = 115;
                        this.expr();
                    }
                    break;
                case 2:
                    localContext = new ExplicitReturnContext(localContext);
                    this.enterOuterAlt(localContext, 2);
                    {
                        this.state = 116;
                        this.expr();
                        this.state = 117;
                        this.match(RustParser.T__0);
                    }
                    break;
            }
        }
        catch (re) {
            if (re instanceof antlr.RecognitionException) {
                this.errorHandler.reportError(this, re);
                this.errorHandler.recover(this, re);
            }
            else {
                throw re;
            }
        }
        finally {
            this.exitRule();
        }
        return localContext;
    }
    ifExpr() {
        let localContext = new IfExprContext(this.context, this.state);
        this.enterRule(localContext, 20, RustParser.RULE_ifExpr);
        let _la;
        try {
            this.enterOuterAlt(localContext, 1);
            {
                this.state = 121;
                this.match(RustParser.T__13);
                this.state = 122;
                this.expr();
                this.state = 123;
                this.block();
                this.state = 126;
                this.errorHandler.sync(this);
                _la = this.tokenStream.LA(1);
                if (_la === 15) {
                    {
                        this.state = 124;
                        this.match(RustParser.T__14);
                        this.state = 125;
                        this.block();
                    }
                }
            }
        }
        catch (re) {
            if (re instanceof antlr.RecognitionException) {
                this.errorHandler.reportError(this, re);
                this.errorHandler.recover(this, re);
            }
            else {
                throw re;
            }
        }
        finally {
            this.exitRule();
        }
        return localContext;
    }
    expr() {
        let localContext = new ExprContext(this.context, this.state);
        this.enterRule(localContext, 22, RustParser.RULE_expr);
        try {
            this.enterOuterAlt(localContext, 1);
            {
                this.state = 128;
                this.exprBinary();
            }
        }
        catch (re) {
            if (re instanceof antlr.RecognitionException) {
                this.errorHandler.reportError(this, re);
                this.errorHandler.recover(this, re);
            }
            else {
                throw re;
            }
        }
        finally {
            this.exitRule();
        }
        return localContext;
    }
    exprBinary() {
        let localContext = new ExprBinaryContext(this.context, this.state);
        this.enterRule(localContext, 24, RustParser.RULE_exprBinary);
        try {
            let alternative;
            localContext = new BinaryExprContext(localContext);
            this.enterOuterAlt(localContext, 1);
            {
                this.state = 130;
                this.exprUnary();
                this.state = 136;
                this.errorHandler.sync(this);
                alternative = this.interpreter.adaptivePredict(this.tokenStream, 12, this.context);
                while (alternative !== 2 && alternative !== antlr.ATN.INVALID_ALT_NUMBER) {
                    if (alternative === 1) {
                        {
                            {
                                this.state = 131;
                                this.binOp();
                                this.state = 132;
                                this.exprUnary();
                            }
                        }
                    }
                    this.state = 138;
                    this.errorHandler.sync(this);
                    alternative = this.interpreter.adaptivePredict(this.tokenStream, 12, this.context);
                }
            }
        }
        catch (re) {
            if (re instanceof antlr.RecognitionException) {
                this.errorHandler.reportError(this, re);
                this.errorHandler.recover(this, re);
            }
            else {
                throw re;
            }
        }
        finally {
            this.exitRule();
        }
        return localContext;
    }
    exprUnary() {
        let localContext = new ExprUnaryContext(this.context, this.state);
        this.enterRule(localContext, 26, RustParser.RULE_exprUnary);
        let _la;
        try {
            this.state = 149;
            this.errorHandler.sync(this);
            switch (this.tokenStream.LA(1)) {
                case RustParser.T__15:
                    localContext = new UnaryNegationContext(localContext);
                    this.enterOuterAlt(localContext, 1);
                    {
                        this.state = 139;
                        this.match(RustParser.T__15);
                        this.state = 140;
                        this.exprUnary();
                    }
                    break;
                case RustParser.T__16:
                    localContext = new UnaryNotContext(localContext);
                    this.enterOuterAlt(localContext, 2);
                    {
                        this.state = 141;
                        this.match(RustParser.T__16);
                        this.state = 142;
                        this.exprUnary();
                    }
                    break;
                case RustParser.T__17:
                    localContext = new BorrowExprContext(localContext);
                    this.enterOuterAlt(localContext, 3);
                    {
                        this.state = 143;
                        this.match(RustParser.T__17);
                        this.state = 145;
                        this.errorHandler.sync(this);
                        _la = this.tokenStream.LA(1);
                        if (_la === 3) {
                            {
                                this.state = 144;
                                this.match(RustParser.T__2);
                            }
                        }
                        this.state = 147;
                        this.exprUnary();
                    }
                    break;
                case RustParser.T__6:
                case RustParser.T__27:
                case RustParser.T__28:
                case RustParser.IDENTIFIER:
                case RustParser.INT:
                case RustParser.FLOAT:
                case RustParser.STRING:
                    localContext = new UnaryToAtomContext(localContext);
                    this.enterOuterAlt(localContext, 4);
                    {
                        this.state = 148;
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
            }
            else {
                throw re;
            }
        }
        finally {
            this.exitRule();
        }
        return localContext;
    }
    exprAtom() {
        let localContext = new ExprAtomContext(this.context, this.state);
        this.enterRule(localContext, 28, RustParser.RULE_exprAtom);
        let _la;
        try {
            this.state = 170;
            this.errorHandler.sync(this);
            switch (this.interpreter.adaptivePredict(this.tokenStream, 17, this.context)) {
                case 1:
                    localContext = new FunctionCallContext(localContext);
                    this.enterOuterAlt(localContext, 1);
                    {
                        this.state = 151;
                        this.match(RustParser.IDENTIFIER);
                        this.state = 152;
                        this.match(RustParser.T__6);
                        this.state = 154;
                        this.errorHandler.sync(this);
                        _la = this.tokenStream.LA(1);
                        if (((((_la - 7)) & ~0x1F) === 0 && ((1 << (_la - 7)) & 132124161) !== 0)) {
                            {
                                this.state = 153;
                                this.argList();
                            }
                        }
                        this.state = 156;
                        this.match(RustParser.T__7);
                    }
                    break;
                case 2:
                    localContext = new MacroCallContext(localContext);
                    this.enterOuterAlt(localContext, 2);
                    {
                        this.state = 157;
                        this.match(RustParser.IDENTIFIER);
                        this.state = 158;
                        this.match(RustParser.T__16);
                        this.state = 159;
                        this.match(RustParser.T__6);
                        this.state = 161;
                        this.errorHandler.sync(this);
                        _la = this.tokenStream.LA(1);
                        if (((((_la - 7)) & ~0x1F) === 0 && ((1 << (_la - 7)) & 132124161) !== 0)) {
                            {
                                this.state = 160;
                                this.argList();
                            }
                        }
                        this.state = 163;
                        this.match(RustParser.T__7);
                    }
                    break;
                case 3:
                    localContext = new ParensExprContext(localContext);
                    this.enterOuterAlt(localContext, 3);
                    {
                        this.state = 164;
                        this.match(RustParser.T__6);
                        this.state = 165;
                        this.expr();
                        this.state = 166;
                        this.match(RustParser.T__7);
                    }
                    break;
                case 4:
                    localContext = new LiteralExprContext(localContext);
                    this.enterOuterAlt(localContext, 4);
                    {
                        this.state = 168;
                        this.literal();
                    }
                    break;
                case 5:
                    localContext = new IdentExprContext(localContext);
                    this.enterOuterAlt(localContext, 5);
                    {
                        this.state = 169;
                        this.match(RustParser.IDENTIFIER);
                    }
                    break;
            }
        }
        catch (re) {
            if (re instanceof antlr.RecognitionException) {
                this.errorHandler.reportError(this, re);
                this.errorHandler.recover(this, re);
            }
            else {
                throw re;
            }
        }
        finally {
            this.exitRule();
        }
        return localContext;
    }
    argList() {
        let localContext = new ArgListContext(this.context, this.state);
        this.enterRule(localContext, 30, RustParser.RULE_argList);
        let _la;
        try {
            this.enterOuterAlt(localContext, 1);
            {
                this.state = 172;
                this.expr();
                this.state = 177;
                this.errorHandler.sync(this);
                _la = this.tokenStream.LA(1);
                while (_la === 9) {
                    {
                        {
                            this.state = 173;
                            this.match(RustParser.T__8);
                            this.state = 174;
                            this.expr();
                        }
                    }
                    this.state = 179;
                    this.errorHandler.sync(this);
                    _la = this.tokenStream.LA(1);
                }
            }
        }
        catch (re) {
            if (re instanceof antlr.RecognitionException) {
                this.errorHandler.reportError(this, re);
                this.errorHandler.recover(this, re);
            }
            else {
                throw re;
            }
        }
        finally {
            this.exitRule();
        }
        return localContext;
    }
    binOp() {
        let localContext = new BinOpContext(this.context, this.state);
        this.enterRule(localContext, 32, RustParser.RULE_binOp);
        let _la;
        try {
            this.enterOuterAlt(localContext, 1);
            {
                this.state = 180;
                _la = this.tokenStream.LA(1);
                if (!((((_la) & ~0x1F) === 0 && ((1 << _la) & 267976704) !== 0))) {
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
            }
            else {
                throw re;
            }
        }
        finally {
            this.exitRule();
        }
        return localContext;
    }
    typeExpr() {
        let localContext = new TypeExprContext(this.context, this.state);
        this.enterRule(localContext, 34, RustParser.RULE_typeExpr);
        let _la;
        try {
            this.state = 188;
            this.errorHandler.sync(this);
            switch (this.tokenStream.LA(1)) {
                case RustParser.T__17:
                    localContext = new RefTypeContext(localContext);
                    this.enterOuterAlt(localContext, 1);
                    {
                        this.state = 182;
                        this.match(RustParser.T__17);
                        this.state = 184;
                        this.errorHandler.sync(this);
                        _la = this.tokenStream.LA(1);
                        if (_la === 3) {
                            {
                                this.state = 183;
                                this.match(RustParser.T__2);
                            }
                        }
                        this.state = 186;
                        this.match(RustParser.IDENTIFIER);
                    }
                    break;
                case RustParser.IDENTIFIER:
                    localContext = new BasicTypeContext(localContext);
                    this.enterOuterAlt(localContext, 2);
                    {
                        this.state = 187;
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
            }
            else {
                throw re;
            }
        }
        finally {
            this.exitRule();
        }
        return localContext;
    }
    literal() {
        let localContext = new LiteralContext(this.context, this.state);
        this.enterRule(localContext, 36, RustParser.RULE_literal);
        let _la;
        try {
            this.enterOuterAlt(localContext, 1);
            {
                this.state = 190;
                _la = this.tokenStream.LA(1);
                if (!(((((_la - 28)) & ~0x1F) === 0 && ((1 << (_la - 28)) & 59) !== 0))) {
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
            }
            else {
                throw re;
            }
        }
        finally {
            this.exitRule();
        }
        return localContext;
    }
    static get _ATN() {
        if (!RustParser.__ATN) {
            RustParser.__ATN = new antlr.ATNDeserializer().deserialize(RustParser._serializedATN);
        }
        return RustParser.__ATN;
    }
    get vocabulary() {
        return RustParser.vocabulary;
    }
}
RustParser.T__0 = 1;
RustParser.T__1 = 2;
RustParser.T__2 = 3;
RustParser.T__3 = 4;
RustParser.T__4 = 5;
RustParser.T__5 = 6;
RustParser.T__6 = 7;
RustParser.T__7 = 8;
RustParser.T__8 = 9;
RustParser.T__9 = 10;
RustParser.T__10 = 11;
RustParser.T__11 = 12;
RustParser.T__12 = 13;
RustParser.T__13 = 14;
RustParser.T__14 = 15;
RustParser.T__15 = 16;
RustParser.T__16 = 17;
RustParser.T__17 = 18;
RustParser.T__18 = 19;
RustParser.T__19 = 20;
RustParser.T__20 = 21;
RustParser.T__21 = 22;
RustParser.T__22 = 23;
RustParser.T__23 = 24;
RustParser.T__24 = 25;
RustParser.T__25 = 26;
RustParser.T__26 = 27;
RustParser.T__27 = 28;
RustParser.T__28 = 29;
RustParser.IDENTIFIER = 30;
RustParser.INT = 31;
RustParser.FLOAT = 32;
RustParser.STRING = 33;
RustParser.WS = 34;
RustParser.COMMENT = 35;
RustParser.RULE_program = 0;
RustParser.RULE_statement = 1;
RustParser.RULE_letDecl = 2;
RustParser.RULE_fnDecl = 3;
RustParser.RULE_paramList = 4;
RustParser.RULE_param = 5;
RustParser.RULE_returnType = 6;
RustParser.RULE_whileLoop = 7;
RustParser.RULE_block = 8;
RustParser.RULE_returnExpr = 9;
RustParser.RULE_ifExpr = 10;
RustParser.RULE_expr = 11;
RustParser.RULE_exprBinary = 12;
RustParser.RULE_exprUnary = 13;
RustParser.RULE_exprAtom = 14;
RustParser.RULE_argList = 15;
RustParser.RULE_binOp = 16;
RustParser.RULE_typeExpr = 17;
RustParser.RULE_literal = 18;
RustParser.literalNames = [
    null, "';'", "'let'", "'mut'", "':'", "'='", "'fn'", "'('", "')'",
    "','", "'->'", "'while'", "'{'", "'}'", "'if'", "'else'", "'-'",
    "'!'", "'&'", "'+'", "'*'", "'/'", "'=='", "'!='", "'<'", "'<='",
    "'>'", "'>='", "'true'", "'false'"
];
RustParser.symbolicNames = [
    null, null, null, null, null, null, null, null, null, null, null,
    null, null, null, null, null, null, null, null, null, null, null,
    null, null, null, null, null, null, null, null, "IDENTIFIER", "INT",
    "FLOAT", "STRING", "WS", "COMMENT"
];
RustParser.ruleNames = [
    "program", "statement", "letDecl", "fnDecl", "paramList", "param",
    "returnType", "whileLoop", "block", "returnExpr", "ifExpr", "expr",
    "exprBinary", "exprUnary", "exprAtom", "argList", "binOp", "typeExpr",
    "literal",
];
RustParser._serializedATN = [
    4, 1, 35, 193, 2, 0, 7, 0, 2, 1, 7, 1, 2, 2, 7, 2, 2, 3, 7, 3, 2, 4, 7, 4, 2, 5, 7, 5, 2, 6, 7,
    6, 2, 7, 7, 7, 2, 8, 7, 8, 2, 9, 7, 9, 2, 10, 7, 10, 2, 11, 7, 11, 2, 12, 7, 12, 2, 13, 7, 13,
    2, 14, 7, 14, 2, 15, 7, 15, 2, 16, 7, 16, 2, 17, 7, 17, 2, 18, 7, 18, 1, 0, 5, 0, 40, 8, 0,
    10, 0, 12, 0, 43, 9, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    1, 1, 3, 1, 58, 8, 1, 1, 2, 1, 2, 3, 2, 62, 8, 2, 1, 2, 1, 2, 1, 2, 3, 2, 67, 8, 2, 1, 2, 1, 2,
    3, 2, 71, 8, 2, 1, 3, 1, 3, 1, 3, 1, 3, 3, 3, 77, 8, 3, 1, 3, 1, 3, 3, 3, 81, 8, 3, 1, 3, 1, 3,
    1, 4, 1, 4, 1, 4, 5, 4, 88, 8, 4, 10, 4, 12, 4, 91, 9, 4, 1, 5, 1, 5, 1, 5, 1, 5, 1, 6, 1, 6,
    1, 6, 1, 7, 1, 7, 1, 7, 1, 7, 1, 8, 1, 8, 5, 8, 106, 8, 8, 10, 8, 12, 8, 109, 9, 8, 1, 8, 3,
    8, 112, 8, 8, 1, 8, 1, 8, 1, 9, 1, 9, 1, 9, 1, 9, 3, 9, 120, 8, 9, 1, 10, 1, 10, 1, 10, 1, 10,
    1, 10, 3, 10, 127, 8, 10, 1, 11, 1, 11, 1, 12, 1, 12, 1, 12, 1, 12, 5, 12, 135, 8, 12, 10,
    12, 12, 12, 138, 9, 12, 1, 13, 1, 13, 1, 13, 1, 13, 1, 13, 1, 13, 3, 13, 146, 8, 13, 1,
    13, 1, 13, 3, 13, 150, 8, 13, 1, 14, 1, 14, 1, 14, 3, 14, 155, 8, 14, 1, 14, 1, 14, 1, 14,
    1, 14, 1, 14, 3, 14, 162, 8, 14, 1, 14, 1, 14, 1, 14, 1, 14, 1, 14, 1, 14, 1, 14, 3, 14,
    171, 8, 14, 1, 15, 1, 15, 1, 15, 5, 15, 176, 8, 15, 10, 15, 12, 15, 179, 9, 15, 1, 16,
    1, 16, 1, 17, 1, 17, 3, 17, 185, 8, 17, 1, 17, 1, 17, 3, 17, 189, 8, 17, 1, 18, 1, 18, 1,
    18, 0, 0, 19, 0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 0,
    2, 2, 0, 16, 16, 19, 27, 2, 0, 28, 29, 31, 33, 204, 0, 41, 1, 0, 0, 0, 2, 57, 1, 0, 0, 0,
    4, 59, 1, 0, 0, 0, 6, 72, 1, 0, 0, 0, 8, 84, 1, 0, 0, 0, 10, 92, 1, 0, 0, 0, 12, 96, 1, 0, 0,
    0, 14, 99, 1, 0, 0, 0, 16, 103, 1, 0, 0, 0, 18, 119, 1, 0, 0, 0, 20, 121, 1, 0, 0, 0, 22,
    128, 1, 0, 0, 0, 24, 130, 1, 0, 0, 0, 26, 149, 1, 0, 0, 0, 28, 170, 1, 0, 0, 0, 30, 172,
    1, 0, 0, 0, 32, 180, 1, 0, 0, 0, 34, 188, 1, 0, 0, 0, 36, 190, 1, 0, 0, 0, 38, 40, 3, 2, 1,
    0, 39, 38, 1, 0, 0, 0, 40, 43, 1, 0, 0, 0, 41, 39, 1, 0, 0, 0, 41, 42, 1, 0, 0, 0, 42, 44,
    1, 0, 0, 0, 43, 41, 1, 0, 0, 0, 44, 45, 5, 0, 0, 1, 45, 1, 1, 0, 0, 0, 46, 47, 3, 4, 2, 0, 47,
    48, 5, 1, 0, 0, 48, 58, 1, 0, 0, 0, 49, 58, 3, 6, 3, 0, 50, 58, 3, 14, 7, 0, 51, 58, 3, 20,
    10, 0, 52, 58, 3, 16, 8, 0, 53, 54, 3, 22, 11, 0, 54, 55, 5, 1, 0, 0, 55, 58, 1, 0, 0, 0,
    56, 58, 3, 18, 9, 0, 57, 46, 1, 0, 0, 0, 57, 49, 1, 0, 0, 0, 57, 50, 1, 0, 0, 0, 57, 51, 1,
    0, 0, 0, 57, 52, 1, 0, 0, 0, 57, 53, 1, 0, 0, 0, 57, 56, 1, 0, 0, 0, 58, 3, 1, 0, 0, 0, 59,
    61, 5, 2, 0, 0, 60, 62, 5, 3, 0, 0, 61, 60, 1, 0, 0, 0, 61, 62, 1, 0, 0, 0, 62, 63, 1, 0, 0,
    0, 63, 66, 5, 30, 0, 0, 64, 65, 5, 4, 0, 0, 65, 67, 3, 34, 17, 0, 66, 64, 1, 0, 0, 0, 66,
    67, 1, 0, 0, 0, 67, 70, 1, 0, 0, 0, 68, 69, 5, 5, 0, 0, 69, 71, 3, 22, 11, 0, 70, 68, 1, 0,
    0, 0, 70, 71, 1, 0, 0, 0, 71, 5, 1, 0, 0, 0, 72, 73, 5, 6, 0, 0, 73, 74, 5, 30, 0, 0, 74, 76,
    5, 7, 0, 0, 75, 77, 3, 8, 4, 0, 76, 75, 1, 0, 0, 0, 76, 77, 1, 0, 0, 0, 77, 78, 1, 0, 0, 0,
    78, 80, 5, 8, 0, 0, 79, 81, 3, 12, 6, 0, 80, 79, 1, 0, 0, 0, 80, 81, 1, 0, 0, 0, 81, 82, 1,
    0, 0, 0, 82, 83, 3, 16, 8, 0, 83, 7, 1, 0, 0, 0, 84, 89, 3, 10, 5, 0, 85, 86, 5, 9, 0, 0, 86,
    88, 3, 10, 5, 0, 87, 85, 1, 0, 0, 0, 88, 91, 1, 0, 0, 0, 89, 87, 1, 0, 0, 0, 89, 90, 1, 0,
    0, 0, 90, 9, 1, 0, 0, 0, 91, 89, 1, 0, 0, 0, 92, 93, 5, 30, 0, 0, 93, 94, 5, 4, 0, 0, 94, 95,
    3, 34, 17, 0, 95, 11, 1, 0, 0, 0, 96, 97, 5, 10, 0, 0, 97, 98, 3, 34, 17, 0, 98, 13, 1, 0,
    0, 0, 99, 100, 5, 11, 0, 0, 100, 101, 3, 22, 11, 0, 101, 102, 3, 16, 8, 0, 102, 15, 1,
    0, 0, 0, 103, 107, 5, 12, 0, 0, 104, 106, 3, 2, 1, 0, 105, 104, 1, 0, 0, 0, 106, 109, 1,
    0, 0, 0, 107, 105, 1, 0, 0, 0, 107, 108, 1, 0, 0, 0, 108, 111, 1, 0, 0, 0, 109, 107, 1,
    0, 0, 0, 110, 112, 3, 18, 9, 0, 111, 110, 1, 0, 0, 0, 111, 112, 1, 0, 0, 0, 112, 113, 1,
    0, 0, 0, 113, 114, 5, 13, 0, 0, 114, 17, 1, 0, 0, 0, 115, 120, 3, 22, 11, 0, 116, 117,
    3, 22, 11, 0, 117, 118, 5, 1, 0, 0, 118, 120, 1, 0, 0, 0, 119, 115, 1, 0, 0, 0, 119, 116,
    1, 0, 0, 0, 120, 19, 1, 0, 0, 0, 121, 122, 5, 14, 0, 0, 122, 123, 3, 22, 11, 0, 123, 126,
    3, 16, 8, 0, 124, 125, 5, 15, 0, 0, 125, 127, 3, 16, 8, 0, 126, 124, 1, 0, 0, 0, 126, 127,
    1, 0, 0, 0, 127, 21, 1, 0, 0, 0, 128, 129, 3, 24, 12, 0, 129, 23, 1, 0, 0, 0, 130, 136,
    3, 26, 13, 0, 131, 132, 3, 32, 16, 0, 132, 133, 3, 26, 13, 0, 133, 135, 1, 0, 0, 0, 134,
    131, 1, 0, 0, 0, 135, 138, 1, 0, 0, 0, 136, 134, 1, 0, 0, 0, 136, 137, 1, 0, 0, 0, 137,
    25, 1, 0, 0, 0, 138, 136, 1, 0, 0, 0, 139, 140, 5, 16, 0, 0, 140, 150, 3, 26, 13, 0, 141,
    142, 5, 17, 0, 0, 142, 150, 3, 26, 13, 0, 143, 145, 5, 18, 0, 0, 144, 146, 5, 3, 0, 0,
    145, 144, 1, 0, 0, 0, 145, 146, 1, 0, 0, 0, 146, 147, 1, 0, 0, 0, 147, 150, 3, 26, 13,
    0, 148, 150, 3, 28, 14, 0, 149, 139, 1, 0, 0, 0, 149, 141, 1, 0, 0, 0, 149, 143, 1, 0,
    0, 0, 149, 148, 1, 0, 0, 0, 150, 27, 1, 0, 0, 0, 151, 152, 5, 30, 0, 0, 152, 154, 5, 7,
    0, 0, 153, 155, 3, 30, 15, 0, 154, 153, 1, 0, 0, 0, 154, 155, 1, 0, 0, 0, 155, 156, 1,
    0, 0, 0, 156, 171, 5, 8, 0, 0, 157, 158, 5, 30, 0, 0, 158, 159, 5, 17, 0, 0, 159, 161,
    5, 7, 0, 0, 160, 162, 3, 30, 15, 0, 161, 160, 1, 0, 0, 0, 161, 162, 1, 0, 0, 0, 162, 163,
    1, 0, 0, 0, 163, 171, 5, 8, 0, 0, 164, 165, 5, 7, 0, 0, 165, 166, 3, 22, 11, 0, 166, 167,
    5, 8, 0, 0, 167, 171, 1, 0, 0, 0, 168, 171, 3, 36, 18, 0, 169, 171, 5, 30, 0, 0, 170, 151,
    1, 0, 0, 0, 170, 157, 1, 0, 0, 0, 170, 164, 1, 0, 0, 0, 170, 168, 1, 0, 0, 0, 170, 169,
    1, 0, 0, 0, 171, 29, 1, 0, 0, 0, 172, 177, 3, 22, 11, 0, 173, 174, 5, 9, 0, 0, 174, 176,
    3, 22, 11, 0, 175, 173, 1, 0, 0, 0, 176, 179, 1, 0, 0, 0, 177, 175, 1, 0, 0, 0, 177, 178,
    1, 0, 0, 0, 178, 31, 1, 0, 0, 0, 179, 177, 1, 0, 0, 0, 180, 181, 7, 0, 0, 0, 181, 33, 1,
    0, 0, 0, 182, 184, 5, 18, 0, 0, 183, 185, 5, 3, 0, 0, 184, 183, 1, 0, 0, 0, 184, 185, 1,
    0, 0, 0, 185, 186, 1, 0, 0, 0, 186, 189, 5, 30, 0, 0, 187, 189, 5, 30, 0, 0, 188, 182,
    1, 0, 0, 0, 188, 187, 1, 0, 0, 0, 189, 35, 1, 0, 0, 0, 190, 191, 7, 1, 0, 0, 191, 37, 1,
    0, 0, 0, 21, 41, 57, 61, 66, 70, 76, 80, 89, 107, 111, 119, 126, 136, 145, 149, 154,
    161, 170, 177, 184, 188
];
RustParser.vocabulary = new antlr.Vocabulary(RustParser.literalNames, RustParser.symbolicNames, []);
RustParser.decisionsToDFA = RustParser._ATN.decisionToState.map((ds, index) => new antlr.DFA(ds, index));
export { RustParser };
export class ProgramContext extends antlr.ParserRuleContext {
    constructor(parent, invokingState) {
        super(parent, invokingState);
    }
    EOF() {
        return this.getToken(RustParser.EOF, 0);
    }
    statement(i) {
        if (i === undefined) {
            return this.getRuleContexts(StatementContext);
        }
        return this.getRuleContext(i, StatementContext);
    }
    get ruleIndex() {
        return RustParser.RULE_program;
    }
    enterRule(listener) {
        if (listener.enterProgram) {
            listener.enterProgram(this);
        }
    }
    exitRule(listener) {
        if (listener.exitProgram) {
            listener.exitProgram(this);
        }
    }
    accept(visitor) {
        if (visitor.visitProgram) {
            return visitor.visitProgram(this);
        }
        else {
            return visitor.visitChildren(this);
        }
    }
}
export class StatementContext extends antlr.ParserRuleContext {
    constructor(parent, invokingState) {
        super(parent, invokingState);
    }
    letDecl() {
        return this.getRuleContext(0, LetDeclContext);
    }
    fnDecl() {
        return this.getRuleContext(0, FnDeclContext);
    }
    whileLoop() {
        return this.getRuleContext(0, WhileLoopContext);
    }
    ifExpr() {
        return this.getRuleContext(0, IfExprContext);
    }
    block() {
        return this.getRuleContext(0, BlockContext);
    }
    expr() {
        return this.getRuleContext(0, ExprContext);
    }
    returnExpr() {
        return this.getRuleContext(0, ReturnExprContext);
    }
    get ruleIndex() {
        return RustParser.RULE_statement;
    }
    enterRule(listener) {
        if (listener.enterStatement) {
            listener.enterStatement(this);
        }
    }
    exitRule(listener) {
        if (listener.exitStatement) {
            listener.exitStatement(this);
        }
    }
    accept(visitor) {
        if (visitor.visitStatement) {
            return visitor.visitStatement(this);
        }
        else {
            return visitor.visitChildren(this);
        }
    }
}
export class LetDeclContext extends antlr.ParserRuleContext {
    constructor(parent, invokingState) {
        super(parent, invokingState);
    }
    IDENTIFIER() {
        return this.getToken(RustParser.IDENTIFIER, 0);
    }
    typeExpr() {
        return this.getRuleContext(0, TypeExprContext);
    }
    expr() {
        return this.getRuleContext(0, ExprContext);
    }
    get ruleIndex() {
        return RustParser.RULE_letDecl;
    }
    enterRule(listener) {
        if (listener.enterLetDecl) {
            listener.enterLetDecl(this);
        }
    }
    exitRule(listener) {
        if (listener.exitLetDecl) {
            listener.exitLetDecl(this);
        }
    }
    accept(visitor) {
        if (visitor.visitLetDecl) {
            return visitor.visitLetDecl(this);
        }
        else {
            return visitor.visitChildren(this);
        }
    }
}
export class FnDeclContext extends antlr.ParserRuleContext {
    constructor(parent, invokingState) {
        super(parent, invokingState);
    }
    IDENTIFIER() {
        return this.getToken(RustParser.IDENTIFIER, 0);
    }
    block() {
        return this.getRuleContext(0, BlockContext);
    }
    paramList() {
        return this.getRuleContext(0, ParamListContext);
    }
    returnType() {
        return this.getRuleContext(0, ReturnTypeContext);
    }
    get ruleIndex() {
        return RustParser.RULE_fnDecl;
    }
    enterRule(listener) {
        if (listener.enterFnDecl) {
            listener.enterFnDecl(this);
        }
    }
    exitRule(listener) {
        if (listener.exitFnDecl) {
            listener.exitFnDecl(this);
        }
    }
    accept(visitor) {
        if (visitor.visitFnDecl) {
            return visitor.visitFnDecl(this);
        }
        else {
            return visitor.visitChildren(this);
        }
    }
}
export class ParamListContext extends antlr.ParserRuleContext {
    constructor(parent, invokingState) {
        super(parent, invokingState);
    }
    param(i) {
        if (i === undefined) {
            return this.getRuleContexts(ParamContext);
        }
        return this.getRuleContext(i, ParamContext);
    }
    get ruleIndex() {
        return RustParser.RULE_paramList;
    }
    enterRule(listener) {
        if (listener.enterParamList) {
            listener.enterParamList(this);
        }
    }
    exitRule(listener) {
        if (listener.exitParamList) {
            listener.exitParamList(this);
        }
    }
    accept(visitor) {
        if (visitor.visitParamList) {
            return visitor.visitParamList(this);
        }
        else {
            return visitor.visitChildren(this);
        }
    }
}
export class ParamContext extends antlr.ParserRuleContext {
    constructor(parent, invokingState) {
        super(parent, invokingState);
    }
    IDENTIFIER() {
        return this.getToken(RustParser.IDENTIFIER, 0);
    }
    typeExpr() {
        return this.getRuleContext(0, TypeExprContext);
    }
    get ruleIndex() {
        return RustParser.RULE_param;
    }
    enterRule(listener) {
        if (listener.enterParam) {
            listener.enterParam(this);
        }
    }
    exitRule(listener) {
        if (listener.exitParam) {
            listener.exitParam(this);
        }
    }
    accept(visitor) {
        if (visitor.visitParam) {
            return visitor.visitParam(this);
        }
        else {
            return visitor.visitChildren(this);
        }
    }
}
export class ReturnTypeContext extends antlr.ParserRuleContext {
    constructor(parent, invokingState) {
        super(parent, invokingState);
    }
    typeExpr() {
        return this.getRuleContext(0, TypeExprContext);
    }
    get ruleIndex() {
        return RustParser.RULE_returnType;
    }
    enterRule(listener) {
        if (listener.enterReturnType) {
            listener.enterReturnType(this);
        }
    }
    exitRule(listener) {
        if (listener.exitReturnType) {
            listener.exitReturnType(this);
        }
    }
    accept(visitor) {
        if (visitor.visitReturnType) {
            return visitor.visitReturnType(this);
        }
        else {
            return visitor.visitChildren(this);
        }
    }
}
export class WhileLoopContext extends antlr.ParserRuleContext {
    constructor(parent, invokingState) {
        super(parent, invokingState);
    }
    expr() {
        return this.getRuleContext(0, ExprContext);
    }
    block() {
        return this.getRuleContext(0, BlockContext);
    }
    get ruleIndex() {
        return RustParser.RULE_whileLoop;
    }
    enterRule(listener) {
        if (listener.enterWhileLoop) {
            listener.enterWhileLoop(this);
        }
    }
    exitRule(listener) {
        if (listener.exitWhileLoop) {
            listener.exitWhileLoop(this);
        }
    }
    accept(visitor) {
        if (visitor.visitWhileLoop) {
            return visitor.visitWhileLoop(this);
        }
        else {
            return visitor.visitChildren(this);
        }
    }
}
export class BlockContext extends antlr.ParserRuleContext {
    constructor(parent, invokingState) {
        super(parent, invokingState);
    }
    statement(i) {
        if (i === undefined) {
            return this.getRuleContexts(StatementContext);
        }
        return this.getRuleContext(i, StatementContext);
    }
    returnExpr() {
        return this.getRuleContext(0, ReturnExprContext);
    }
    get ruleIndex() {
        return RustParser.RULE_block;
    }
    enterRule(listener) {
        if (listener.enterBlock) {
            listener.enterBlock(this);
        }
    }
    exitRule(listener) {
        if (listener.exitBlock) {
            listener.exitBlock(this);
        }
    }
    accept(visitor) {
        if (visitor.visitBlock) {
            return visitor.visitBlock(this);
        }
        else {
            return visitor.visitChildren(this);
        }
    }
}
export class ReturnExprContext extends antlr.ParserRuleContext {
    constructor(parent, invokingState) {
        super(parent, invokingState);
    }
    get ruleIndex() {
        return RustParser.RULE_returnExpr;
    }
    copyFrom(ctx) {
        super.copyFrom(ctx);
    }
}
export class ImplicitReturnContext extends ReturnExprContext {
    constructor(ctx) {
        super(ctx.parent, ctx.invokingState);
        super.copyFrom(ctx);
    }
    expr() {
        return this.getRuleContext(0, ExprContext);
    }
    enterRule(listener) {
        if (listener.enterImplicitReturn) {
            listener.enterImplicitReturn(this);
        }
    }
    exitRule(listener) {
        if (listener.exitImplicitReturn) {
            listener.exitImplicitReturn(this);
        }
    }
    accept(visitor) {
        if (visitor.visitImplicitReturn) {
            return visitor.visitImplicitReturn(this);
        }
        else {
            return visitor.visitChildren(this);
        }
    }
}
export class ExplicitReturnContext extends ReturnExprContext {
    constructor(ctx) {
        super(ctx.parent, ctx.invokingState);
        super.copyFrom(ctx);
    }
    expr() {
        return this.getRuleContext(0, ExprContext);
    }
    enterRule(listener) {
        if (listener.enterExplicitReturn) {
            listener.enterExplicitReturn(this);
        }
    }
    exitRule(listener) {
        if (listener.exitExplicitReturn) {
            listener.exitExplicitReturn(this);
        }
    }
    accept(visitor) {
        if (visitor.visitExplicitReturn) {
            return visitor.visitExplicitReturn(this);
        }
        else {
            return visitor.visitChildren(this);
        }
    }
}
export class IfExprContext extends antlr.ParserRuleContext {
    constructor(parent, invokingState) {
        super(parent, invokingState);
    }
    expr() {
        return this.getRuleContext(0, ExprContext);
    }
    block(i) {
        if (i === undefined) {
            return this.getRuleContexts(BlockContext);
        }
        return this.getRuleContext(i, BlockContext);
    }
    get ruleIndex() {
        return RustParser.RULE_ifExpr;
    }
    enterRule(listener) {
        if (listener.enterIfExpr) {
            listener.enterIfExpr(this);
        }
    }
    exitRule(listener) {
        if (listener.exitIfExpr) {
            listener.exitIfExpr(this);
        }
    }
    accept(visitor) {
        if (visitor.visitIfExpr) {
            return visitor.visitIfExpr(this);
        }
        else {
            return visitor.visitChildren(this);
        }
    }
}
export class ExprContext extends antlr.ParserRuleContext {
    constructor(parent, invokingState) {
        super(parent, invokingState);
    }
    exprBinary() {
        return this.getRuleContext(0, ExprBinaryContext);
    }
    get ruleIndex() {
        return RustParser.RULE_expr;
    }
    enterRule(listener) {
        if (listener.enterExpr) {
            listener.enterExpr(this);
        }
    }
    exitRule(listener) {
        if (listener.exitExpr) {
            listener.exitExpr(this);
        }
    }
    accept(visitor) {
        if (visitor.visitExpr) {
            return visitor.visitExpr(this);
        }
        else {
            return visitor.visitChildren(this);
        }
    }
}
export class ExprBinaryContext extends antlr.ParserRuleContext {
    constructor(parent, invokingState) {
        super(parent, invokingState);
    }
    get ruleIndex() {
        return RustParser.RULE_exprBinary;
    }
    copyFrom(ctx) {
        super.copyFrom(ctx);
    }
}
export class BinaryExprContext extends ExprBinaryContext {
    constructor(ctx) {
        super(ctx.parent, ctx.invokingState);
        super.copyFrom(ctx);
    }
    exprUnary(i) {
        if (i === undefined) {
            return this.getRuleContexts(ExprUnaryContext);
        }
        return this.getRuleContext(i, ExprUnaryContext);
    }
    binOp(i) {
        if (i === undefined) {
            return this.getRuleContexts(BinOpContext);
        }
        return this.getRuleContext(i, BinOpContext);
    }
    enterRule(listener) {
        if (listener.enterBinaryExpr) {
            listener.enterBinaryExpr(this);
        }
    }
    exitRule(listener) {
        if (listener.exitBinaryExpr) {
            listener.exitBinaryExpr(this);
        }
    }
    accept(visitor) {
        if (visitor.visitBinaryExpr) {
            return visitor.visitBinaryExpr(this);
        }
        else {
            return visitor.visitChildren(this);
        }
    }
}
export class ExprUnaryContext extends antlr.ParserRuleContext {
    constructor(parent, invokingState) {
        super(parent, invokingState);
    }
    get ruleIndex() {
        return RustParser.RULE_exprUnary;
    }
    copyFrom(ctx) {
        super.copyFrom(ctx);
    }
}
export class UnaryNotContext extends ExprUnaryContext {
    constructor(ctx) {
        super(ctx.parent, ctx.invokingState);
        super.copyFrom(ctx);
    }
    exprUnary() {
        return this.getRuleContext(0, ExprUnaryContext);
    }
    enterRule(listener) {
        if (listener.enterUnaryNot) {
            listener.enterUnaryNot(this);
        }
    }
    exitRule(listener) {
        if (listener.exitUnaryNot) {
            listener.exitUnaryNot(this);
        }
    }
    accept(visitor) {
        if (visitor.visitUnaryNot) {
            return visitor.visitUnaryNot(this);
        }
        else {
            return visitor.visitChildren(this);
        }
    }
}
export class BorrowExprContext extends ExprUnaryContext {
    constructor(ctx) {
        super(ctx.parent, ctx.invokingState);
        super.copyFrom(ctx);
    }
    exprUnary() {
        return this.getRuleContext(0, ExprUnaryContext);
    }
    enterRule(listener) {
        if (listener.enterBorrowExpr) {
            listener.enterBorrowExpr(this);
        }
    }
    exitRule(listener) {
        if (listener.exitBorrowExpr) {
            listener.exitBorrowExpr(this);
        }
    }
    accept(visitor) {
        if (visitor.visitBorrowExpr) {
            return visitor.visitBorrowExpr(this);
        }
        else {
            return visitor.visitChildren(this);
        }
    }
}
export class UnaryNegationContext extends ExprUnaryContext {
    constructor(ctx) {
        super(ctx.parent, ctx.invokingState);
        super.copyFrom(ctx);
    }
    exprUnary() {
        return this.getRuleContext(0, ExprUnaryContext);
    }
    enterRule(listener) {
        if (listener.enterUnaryNegation) {
            listener.enterUnaryNegation(this);
        }
    }
    exitRule(listener) {
        if (listener.exitUnaryNegation) {
            listener.exitUnaryNegation(this);
        }
    }
    accept(visitor) {
        if (visitor.visitUnaryNegation) {
            return visitor.visitUnaryNegation(this);
        }
        else {
            return visitor.visitChildren(this);
        }
    }
}
export class UnaryToAtomContext extends ExprUnaryContext {
    constructor(ctx) {
        super(ctx.parent, ctx.invokingState);
        super.copyFrom(ctx);
    }
    exprAtom() {
        return this.getRuleContext(0, ExprAtomContext);
    }
    enterRule(listener) {
        if (listener.enterUnaryToAtom) {
            listener.enterUnaryToAtom(this);
        }
    }
    exitRule(listener) {
        if (listener.exitUnaryToAtom) {
            listener.exitUnaryToAtom(this);
        }
    }
    accept(visitor) {
        if (visitor.visitUnaryToAtom) {
            return visitor.visitUnaryToAtom(this);
        }
        else {
            return visitor.visitChildren(this);
        }
    }
}
export class ExprAtomContext extends antlr.ParserRuleContext {
    constructor(parent, invokingState) {
        super(parent, invokingState);
    }
    get ruleIndex() {
        return RustParser.RULE_exprAtom;
    }
    copyFrom(ctx) {
        super.copyFrom(ctx);
    }
}
export class IdentExprContext extends ExprAtomContext {
    constructor(ctx) {
        super(ctx.parent, ctx.invokingState);
        super.copyFrom(ctx);
    }
    IDENTIFIER() {
        return this.getToken(RustParser.IDENTIFIER, 0);
    }
    enterRule(listener) {
        if (listener.enterIdentExpr) {
            listener.enterIdentExpr(this);
        }
    }
    exitRule(listener) {
        if (listener.exitIdentExpr) {
            listener.exitIdentExpr(this);
        }
    }
    accept(visitor) {
        if (visitor.visitIdentExpr) {
            return visitor.visitIdentExpr(this);
        }
        else {
            return visitor.visitChildren(this);
        }
    }
}
export class ParensExprContext extends ExprAtomContext {
    constructor(ctx) {
        super(ctx.parent, ctx.invokingState);
        super.copyFrom(ctx);
    }
    expr() {
        return this.getRuleContext(0, ExprContext);
    }
    enterRule(listener) {
        if (listener.enterParensExpr) {
            listener.enterParensExpr(this);
        }
    }
    exitRule(listener) {
        if (listener.exitParensExpr) {
            listener.exitParensExpr(this);
        }
    }
    accept(visitor) {
        if (visitor.visitParensExpr) {
            return visitor.visitParensExpr(this);
        }
        else {
            return visitor.visitChildren(this);
        }
    }
}
export class LiteralExprContext extends ExprAtomContext {
    constructor(ctx) {
        super(ctx.parent, ctx.invokingState);
        super.copyFrom(ctx);
    }
    literal() {
        return this.getRuleContext(0, LiteralContext);
    }
    enterRule(listener) {
        if (listener.enterLiteralExpr) {
            listener.enterLiteralExpr(this);
        }
    }
    exitRule(listener) {
        if (listener.exitLiteralExpr) {
            listener.exitLiteralExpr(this);
        }
    }
    accept(visitor) {
        if (visitor.visitLiteralExpr) {
            return visitor.visitLiteralExpr(this);
        }
        else {
            return visitor.visitChildren(this);
        }
    }
}
export class FunctionCallContext extends ExprAtomContext {
    constructor(ctx) {
        super(ctx.parent, ctx.invokingState);
        super.copyFrom(ctx);
    }
    IDENTIFIER() {
        return this.getToken(RustParser.IDENTIFIER, 0);
    }
    argList() {
        return this.getRuleContext(0, ArgListContext);
    }
    enterRule(listener) {
        if (listener.enterFunctionCall) {
            listener.enterFunctionCall(this);
        }
    }
    exitRule(listener) {
        if (listener.exitFunctionCall) {
            listener.exitFunctionCall(this);
        }
    }
    accept(visitor) {
        if (visitor.visitFunctionCall) {
            return visitor.visitFunctionCall(this);
        }
        else {
            return visitor.visitChildren(this);
        }
    }
}
export class MacroCallContext extends ExprAtomContext {
    constructor(ctx) {
        super(ctx.parent, ctx.invokingState);
        super.copyFrom(ctx);
    }
    IDENTIFIER() {
        return this.getToken(RustParser.IDENTIFIER, 0);
    }
    argList() {
        return this.getRuleContext(0, ArgListContext);
    }
    enterRule(listener) {
        if (listener.enterMacroCall) {
            listener.enterMacroCall(this);
        }
    }
    exitRule(listener) {
        if (listener.exitMacroCall) {
            listener.exitMacroCall(this);
        }
    }
    accept(visitor) {
        if (visitor.visitMacroCall) {
            return visitor.visitMacroCall(this);
        }
        else {
            return visitor.visitChildren(this);
        }
    }
}
export class ArgListContext extends antlr.ParserRuleContext {
    constructor(parent, invokingState) {
        super(parent, invokingState);
    }
    expr(i) {
        if (i === undefined) {
            return this.getRuleContexts(ExprContext);
        }
        return this.getRuleContext(i, ExprContext);
    }
    get ruleIndex() {
        return RustParser.RULE_argList;
    }
    enterRule(listener) {
        if (listener.enterArgList) {
            listener.enterArgList(this);
        }
    }
    exitRule(listener) {
        if (listener.exitArgList) {
            listener.exitArgList(this);
        }
    }
    accept(visitor) {
        if (visitor.visitArgList) {
            return visitor.visitArgList(this);
        }
        else {
            return visitor.visitChildren(this);
        }
    }
}
export class BinOpContext extends antlr.ParserRuleContext {
    constructor(parent, invokingState) {
        super(parent, invokingState);
    }
    get ruleIndex() {
        return RustParser.RULE_binOp;
    }
    enterRule(listener) {
        if (listener.enterBinOp) {
            listener.enterBinOp(this);
        }
    }
    exitRule(listener) {
        if (listener.exitBinOp) {
            listener.exitBinOp(this);
        }
    }
    accept(visitor) {
        if (visitor.visitBinOp) {
            return visitor.visitBinOp(this);
        }
        else {
            return visitor.visitChildren(this);
        }
    }
}
export class TypeExprContext extends antlr.ParserRuleContext {
    constructor(parent, invokingState) {
        super(parent, invokingState);
    }
    get ruleIndex() {
        return RustParser.RULE_typeExpr;
    }
    copyFrom(ctx) {
        super.copyFrom(ctx);
    }
}
export class RefTypeContext extends TypeExprContext {
    constructor(ctx) {
        super(ctx.parent, ctx.invokingState);
        super.copyFrom(ctx);
    }
    IDENTIFIER() {
        return this.getToken(RustParser.IDENTIFIER, 0);
    }
    enterRule(listener) {
        if (listener.enterRefType) {
            listener.enterRefType(this);
        }
    }
    exitRule(listener) {
        if (listener.exitRefType) {
            listener.exitRefType(this);
        }
    }
    accept(visitor) {
        if (visitor.visitRefType) {
            return visitor.visitRefType(this);
        }
        else {
            return visitor.visitChildren(this);
        }
    }
}
export class BasicTypeContext extends TypeExprContext {
    constructor(ctx) {
        super(ctx.parent, ctx.invokingState);
        super.copyFrom(ctx);
    }
    IDENTIFIER() {
        return this.getToken(RustParser.IDENTIFIER, 0);
    }
    enterRule(listener) {
        if (listener.enterBasicType) {
            listener.enterBasicType(this);
        }
    }
    exitRule(listener) {
        if (listener.exitBasicType) {
            listener.exitBasicType(this);
        }
    }
    accept(visitor) {
        if (visitor.visitBasicType) {
            return visitor.visitBasicType(this);
        }
        else {
            return visitor.visitChildren(this);
        }
    }
}
export class LiteralContext extends antlr.ParserRuleContext {
    constructor(parent, invokingState) {
        super(parent, invokingState);
    }
    INT() {
        return this.getToken(RustParser.INT, 0);
    }
    FLOAT() {
        return this.getToken(RustParser.FLOAT, 0);
    }
    STRING() {
        return this.getToken(RustParser.STRING, 0);
    }
    get ruleIndex() {
        return RustParser.RULE_literal;
    }
    enterRule(listener) {
        if (listener.enterLiteral) {
            listener.enterLiteral(this);
        }
    }
    exitRule(listener) {
        if (listener.exitLiteral) {
            listener.exitLiteral(this);
        }
    }
    accept(visitor) {
        if (visitor.visitLiteral) {
            return visitor.visitLiteral(this);
        }
        else {
            return visitor.visitChildren(this);
        }
    }
}
//# sourceMappingURL=RustParser.js.map