// Generated from src/SimpleLang.g4 by ANTLR 4.13.1
import * as antlr from "antlr4ng";
export class SimpleLangParser extends antlr.Parser {
    static T__0 = 1;
    static T__1 = 2;
    static T__2 = 3;
    static T__3 = 4;
    static T__4 = 5;
    static T__5 = 6;
    static INT = 7;
    static WS = 8;
    static RULE_prog = 0;
    static RULE_expression = 1;
    static literalNames = [
        null, "'*'", "'/'", "'+'", "'-'", "'('", "')'"
    ];
    static symbolicNames = [
        null, null, null, null, null, null, null, "INT", "WS"
    ];
    static ruleNames = [
        "prog", "expression",
    ];
    get grammarFileName() { return "SimpleLang.g4"; }
    get literalNames() { return SimpleLangParser.literalNames; }
    get symbolicNames() { return SimpleLangParser.symbolicNames; }
    get ruleNames() { return SimpleLangParser.ruleNames; }
    get serializedATN() { return SimpleLangParser._serializedATN; }
    createFailedPredicateException(predicate, message) {
        return new antlr.FailedPredicateException(this, predicate, message);
    }
    constructor(input) {
        super(input);
        this.interpreter = new antlr.ParserATNSimulator(this, SimpleLangParser._ATN, SimpleLangParser.decisionsToDFA, new antlr.PredictionContextCache());
    }
    prog() {
        let localContext = new ProgContext(this.context, this.state);
        this.enterRule(localContext, 0, SimpleLangParser.RULE_prog);
        try {
            this.enterOuterAlt(localContext, 1);
            {
                this.state = 4;
                this.expression(0);
                this.state = 5;
                this.match(SimpleLangParser.EOF);
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
    expression(_p) {
        if (_p === undefined) {
            _p = 0;
        }
        let parentContext = this.context;
        let parentState = this.state;
        let localContext = new ExpressionContext(this.context, parentState);
        let previousContext = localContext;
        let _startState = 2;
        this.enterRecursionRule(localContext, 2, SimpleLangParser.RULE_expression, _p);
        let _la;
        try {
            let alternative;
            this.enterOuterAlt(localContext, 1);
            {
                this.state = 13;
                this.errorHandler.sync(this);
                switch (this.tokenStream.LA(1)) {
                    case SimpleLangParser.INT:
                        {
                            this.state = 8;
                            this.match(SimpleLangParser.INT);
                        }
                        break;
                    case SimpleLangParser.T__4:
                        {
                            this.state = 9;
                            this.match(SimpleLangParser.T__4);
                            this.state = 10;
                            this.expression(0);
                            this.state = 11;
                            this.match(SimpleLangParser.T__5);
                        }
                        break;
                    default:
                        throw new antlr.NoViableAltException(this);
                }
                this.context.stop = this.tokenStream.LT(-1);
                this.state = 23;
                this.errorHandler.sync(this);
                alternative = this.interpreter.adaptivePredict(this.tokenStream, 2, this.context);
                while (alternative !== 2 && alternative !== antlr.ATN.INVALID_ALT_NUMBER) {
                    if (alternative === 1) {
                        if (this.parseListeners != null) {
                            this.triggerExitRuleEvent();
                        }
                        previousContext = localContext;
                        {
                            this.state = 21;
                            this.errorHandler.sync(this);
                            switch (this.interpreter.adaptivePredict(this.tokenStream, 1, this.context)) {
                                case 1:
                                    {
                                        localContext = new ExpressionContext(parentContext, parentState);
                                        this.pushNewRecursionContext(localContext, _startState, SimpleLangParser.RULE_expression);
                                        this.state = 15;
                                        if (!(this.precpred(this.context, 4))) {
                                            throw this.createFailedPredicateException("this.precpred(this.context, 4)");
                                        }
                                        this.state = 16;
                                        localContext._op = this.tokenStream.LT(1);
                                        _la = this.tokenStream.LA(1);
                                        if (!(_la === 1 || _la === 2)) {
                                            localContext._op = this.errorHandler.recoverInline(this);
                                        }
                                        else {
                                            this.errorHandler.reportMatch(this);
                                            this.consume();
                                        }
                                        this.state = 17;
                                        this.expression(5);
                                    }
                                    break;
                                case 2:
                                    {
                                        localContext = new ExpressionContext(parentContext, parentState);
                                        this.pushNewRecursionContext(localContext, _startState, SimpleLangParser.RULE_expression);
                                        this.state = 18;
                                        if (!(this.precpred(this.context, 3))) {
                                            throw this.createFailedPredicateException("this.precpred(this.context, 3)");
                                        }
                                        this.state = 19;
                                        localContext._op = this.tokenStream.LT(1);
                                        _la = this.tokenStream.LA(1);
                                        if (!(_la === 3 || _la === 4)) {
                                            localContext._op = this.errorHandler.recoverInline(this);
                                        }
                                        else {
                                            this.errorHandler.reportMatch(this);
                                            this.consume();
                                        }
                                        this.state = 20;
                                        this.expression(4);
                                    }
                                    break;
                            }
                        }
                    }
                    this.state = 25;
                    this.errorHandler.sync(this);
                    alternative = this.interpreter.adaptivePredict(this.tokenStream, 2, this.context);
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
            this.unrollRecursionContexts(parentContext);
        }
        return localContext;
    }
    sempred(localContext, ruleIndex, predIndex) {
        switch (ruleIndex) {
            case 1:
                return this.expression_sempred(localContext, predIndex);
        }
        return true;
    }
    expression_sempred(localContext, predIndex) {
        switch (predIndex) {
            case 0:
                return this.precpred(this.context, 4);
            case 1:
                return this.precpred(this.context, 3);
        }
        return true;
    }
    static _serializedATN = [
        4, 1, 8, 27, 2, 0, 7, 0, 2, 1, 7, 1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 1,
        14, 8, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 5, 1, 22, 8, 1, 10, 1, 12, 1, 25, 9, 1, 1, 1, 0,
        1, 2, 2, 0, 2, 0, 2, 1, 0, 1, 2, 1, 0, 3, 4, 27, 0, 4, 1, 0, 0, 0, 2, 13, 1, 0, 0, 0, 4, 5, 3,
        2, 1, 0, 5, 6, 5, 0, 0, 1, 6, 1, 1, 0, 0, 0, 7, 8, 6, 1, -1, 0, 8, 14, 5, 7, 0, 0, 9, 10, 5, 5,
        0, 0, 10, 11, 3, 2, 1, 0, 11, 12, 5, 6, 0, 0, 12, 14, 1, 0, 0, 0, 13, 7, 1, 0, 0, 0, 13, 9,
        1, 0, 0, 0, 14, 23, 1, 0, 0, 0, 15, 16, 10, 4, 0, 0, 16, 17, 7, 0, 0, 0, 17, 22, 3, 2, 1, 5,
        18, 19, 10, 3, 0, 0, 19, 20, 7, 1, 0, 0, 20, 22, 3, 2, 1, 4, 21, 15, 1, 0, 0, 0, 21, 18, 1,
        0, 0, 0, 22, 25, 1, 0, 0, 0, 23, 21, 1, 0, 0, 0, 23, 24, 1, 0, 0, 0, 24, 3, 1, 0, 0, 0, 25,
        23, 1, 0, 0, 0, 3, 13, 21, 23
    ];
    static __ATN;
    static get _ATN() {
        if (!SimpleLangParser.__ATN) {
            SimpleLangParser.__ATN = new antlr.ATNDeserializer().deserialize(SimpleLangParser._serializedATN);
        }
        return SimpleLangParser.__ATN;
    }
    static vocabulary = new antlr.Vocabulary(SimpleLangParser.literalNames, SimpleLangParser.symbolicNames, []);
    get vocabulary() {
        return SimpleLangParser.vocabulary;
    }
    static decisionsToDFA = SimpleLangParser._ATN.decisionToState.map((ds, index) => new antlr.DFA(ds, index));
}
export class ProgContext extends antlr.ParserRuleContext {
    constructor(parent, invokingState) {
        super(parent, invokingState);
    }
    expression() {
        return this.getRuleContext(0, ExpressionContext);
    }
    EOF() {
        return this.getToken(SimpleLangParser.EOF, 0);
    }
    get ruleIndex() {
        return SimpleLangParser.RULE_prog;
    }
    enterRule(listener) {
        if (listener.enterProg) {
            listener.enterProg(this);
        }
    }
    exitRule(listener) {
        if (listener.exitProg) {
            listener.exitProg(this);
        }
    }
    accept(visitor) {
        if (visitor.visitProg) {
            return visitor.visitProg(this);
        }
        else {
            return visitor.visitChildren(this);
        }
    }
}
export class ExpressionContext extends antlr.ParserRuleContext {
    _op;
    constructor(parent, invokingState) {
        super(parent, invokingState);
    }
    INT() {
        return this.getToken(SimpleLangParser.INT, 0);
    }
    expression(i) {
        if (i === undefined) {
            return this.getRuleContexts(ExpressionContext);
        }
        return this.getRuleContext(i, ExpressionContext);
    }
    get ruleIndex() {
        return SimpleLangParser.RULE_expression;
    }
    enterRule(listener) {
        if (listener.enterExpression) {
            listener.enterExpression(this);
        }
    }
    exitRule(listener) {
        if (listener.exitExpression) {
            listener.exitExpression(this);
        }
    }
    accept(visitor) {
        if (visitor.visitExpression) {
            return visitor.visitExpression(this);
        }
        else {
            return visitor.visitChildren(this);
        }
    }
}
//# sourceMappingURL=SimpleLangParser.js.map