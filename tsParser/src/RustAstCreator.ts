import {
  CharStream,
  CommonTokenStream,
  AbstractParseTreeVisitor,
} from "antlr4ng";
import { RustLexer } from "./parser/src/RustLexer.js";
import { DerefExprContext, RustParser } from "./parser/src/RustParser.js";
import { RustVisitor } from "./parser/src/RustVisitor.js";
import { readFile } from "fs/promises";

// Import parser context types
import {
  UnaryNegationContext,
  UnaryNotContext,
  BorrowExprContext,
  RefTypeContext,
  BasicTypeContext,
  UnaryToAtomContext,
  FunctionCallContext,
  MacroCallContext,
  ParensExprContext,
  LiteralExprContext,
  IdentExprContext,
  BlockContext,
  IfExprContext,
  AssignmentContext,
  AssignmentStmtContext,
} from "./parser/src/RustParser.js";

class RustAstVisitor
  extends AbstractParseTreeVisitor<any>
  implements RustVisitor<any>
{
  visitProgram(ctx: any): any {
    
    return {
      type: "Program",
      statements: ctx.statement().map((stmt: any) => this.visit(stmt)),
    };
  }

  visitStatement(ctx: any): any {
    if (ctx.letDecl()) {
      return this.visit(ctx.letDecl());
    } else if (ctx.fnDecl()) {
      return this.visit(ctx.fnDecl());
    } else if (ctx.assignment()) {
      return this.visit(ctx.assignment());
    } else if (ctx.whileLoop()) {
      return this.visit(ctx.whileLoop());
    } else if (ctx.ifExpr()) {
      return this.visit(ctx.ifExpr());
    } else if (ctx.block()) {
      return this.visit(ctx.block());
    } else if (ctx.expr()) {
      return this.visit(ctx.expr());
    } else if (ctx.returnExpr()) {
      return this.visit(ctx.returnExpr());
    }
    return null;
  }

  visitAssignment(ctx: any): any {
    
    return {
      type: "AssignmentStmt",
      name: ctx.IDENTIFIER().getText(),
      value: this.visit(ctx.expr()),
    };
  }

  visitAssignmentStmt(ctx: AssignmentStmtContext): any {

    return {
      type: "AssignmentStmt",
      name: ctx.IDENTIFIER().getText(),
      value: this.visit(ctx.expr()),
    };
  }

  visitLetDecl(ctx: any): any {
    if (!ctx.expr() || !ctx.typeExpr()) {
      throw new Error(
        "Invalid let declaration: both expr and typeExpr are required"
      );
    }


    return {
      type: "LetDecl",
      name: ctx.IDENTIFIER().getText(),
      value: ctx.expr() ? this.visit(ctx.expr()) : null,
      declaredType: ctx.typeExpr() ? this.visit(ctx.typeExpr()) : null,
      isMutable: ctx.MUT() !== null,
    };
  }

  visitFnDecl(ctx: any): any {
    
    if (!ctx.returnType()) {
      console.log("Warning: No return type specified for function implicitly means it returns ()");
    }
  
    return {
      type: "FnDecl",
      name: ctx.IDENTIFIER().getText(),
      params: ctx.paramList() ? this.visit(ctx.paramList()) : [],
      returnType: ctx.returnType() ? this.visit(ctx.returnType()) : null,
      body: this.visit(ctx.block()),
    };
  }

  visitParamList(ctx: any): any {

    return ctx.param().map((param: any) => this.visit(param));
  }

  visitParam(ctx: any): any {

    return {
      type: "Param",
      name: ctx.IDENTIFIER().getText(),
      paramType: this.visit(ctx.typeExpr()),
      isMutable: ctx.MUT() !== null,
    };
  }


  visitReturnType(ctx: any): any {
    
    return this.visit(ctx.typeExpr());
  }

  visitWhileLoop(ctx: any): any {
 
    return {
      type: "WhileLoop",
      condition: this.visit(ctx.expr()),
      body: this.visit(ctx.block()),
    };
  }

  visitBlock(ctx: any): any {
  

    const statements = ctx.statement().map((stmt: any) => this.visit(stmt));

    return {
      type: "Block",
      statements: statements,
    };
  }

  visitReturnExpr(ctx: any): any {
 

    return {
      type: "ReturnExpr",
      expr: this.visit(ctx.expr()),
    };
  }

  visitIfExpr(ctx: IfExprContext): any {

    return {
      type: "IfExpr",
      condition: this.visit(ctx.expr()),
      thenBranch: this.visit(ctx.block(0)),
      elseBranch: ctx.block().length > 1 ? this.visit(ctx.block(1)) : null,
    };
  }

  visitExpr(ctx: any): any {

    return this.visit(ctx.exprBinary());
  }

  visitBinaryExpr(ctx: any): any {
   
    if (ctx.exprUnary().length === 1) {
      return this.visit(ctx.exprUnary(0));
    }

    const left = this.visit(ctx.exprUnary(0));
    const operators = ctx.binOp();
    const rightExprs = ctx.exprUnary().slice(1);

    let result = left;
    for (let i = 0; i < operators.length; i++) {
      result = {
        type: "BinaryExpr",
        left: result,
        operator: operators[i].getText(),
        right: this.visit(rightExprs[i]),
      };
    }
    return result;
  }

  visitExprUnary(ctx: any): any {

    if (ctx instanceof UnaryNegationContext) {
      return {
        type: "UnaryNegation",
        expr: this.visit(ctx.exprUnary()),
      };
    } else if (ctx instanceof UnaryNotContext) {
      return {
        type: "UnaryNot",
        expr: this.visit(ctx.exprUnary()),
      };
    } else if (ctx instanceof BorrowExprContext) {
      return {
        type: "BorrowExpr",
        mutable: ctx.MUT() !== null,
        expr: this.visit(ctx.exprUnary()),
      };
    } else if (ctx instanceof UnaryToAtomContext) {
      return this.visit(ctx.exprAtom());
    }
    return null;
  }

  visitExprAtom(ctx: any): any {

    if (ctx instanceof FunctionCallContext) {
      return {
        type: "FunctionCall",
        name: ctx.IDENTIFIER().getText(),
        args: ctx.argList() ? this.visit(ctx.argList()) : [],
      };
    } else if (ctx instanceof MacroCallContext) {
      return {
        type: "MacroCall",
        name: ctx.IDENTIFIER().getText(),
        args: ctx.argList() ? this.visit(ctx.argList()) : [],
      };
    } else if (ctx instanceof ParensExprContext) {
      return this.visit(ctx.expr());
    } else if (ctx instanceof LiteralExprContext) {
      return this.visit(ctx.literal());
    } else if (ctx instanceof IdentExprContext) {
    
      return {
        type: "IdentExpr",
        name: ctx.IDENTIFIER().getText(),
      };
    } else if (ctx instanceof DerefExprContext) {


      return {
        type: "DerefExpr",
        expr: this.visit(ctx.expr()),
      } 
    }
    return null;
  }

  visitIdentExpr(ctx: IdentExprContext): any {
  
    return {
      type: "IdentExpr",
      name: ctx.IDENTIFIER().getText(),
    };
  }

  visitDerefExpr(ctx: DerefExprContext): any {

    return {
      type: "DerefExpr",
      expr: this.visit(ctx.expr()),
    };
  }

  visitUnaryToAtom(ctx: UnaryToAtomContext): any {

    return this.visit(ctx.exprAtom());
  }

  visitArgList(ctx: any): any {
    
    return ctx.expr().map((expr: any) => this.visit(expr));
  }

  visitRefType(ctx: any): any {
  
    return {
      type: "RefType",
      isMutable: ctx.MUT() !== null,
      value: this.visit(ctx.typeExpr()),
    };
  }

  visitBasicType(ctx: any): any {
 
    return {
      type: "BasicType",
      name: ctx.IDENTIFIER().getText(),
    };
  }

  visitLiteral(ctx: any): any {
 
    const text = ctx.getText();
    let value: any = text;

    if (text.match(/^\d+$/)) {
      value = parseInt(text);
    } else if (text.match(/^\d+\.\d*$/)) {
      value = parseFloat(text);
    } else if (text === "true" || text === "false") {
      value = text === "true";
    } else if (text.startsWith('"')) {
      value = text.slice(1, -1);
    }

    return {
      type: "Literal",
      value: value,
    };
  }

  visitUnaryNegation(ctx: UnaryNegationContext): any {
 
    return {
      type: "UnaryNegation",
      expr: this.visit(ctx.exprUnary()),
    };
  }

  visitUnaryNot(ctx: UnaryNotContext): any {
 
    return {
      type: "UnaryNot",
      expr: this.visit(ctx.exprUnary()),
    };
  }

  visitBorrowExpr(ctx: BorrowExprContext): any {
   
    return {
      type: "BorrowExpr",
      isMutable: ctx.MUT() !== null,
      expr: this.visit(ctx.exprUnary()),
    };
  }

  visitFunctionCall(ctx: FunctionCallContext): any {

    return {
      type: "FunctionCall",
      name: ctx.IDENTIFIER().getText(),
      args: ctx.argList() ? this.visit(ctx.argList()) : [],
    };
  }

  visitMacroCall(ctx: MacroCallContext): any {
  
    return {
      type: "MacroCall",
      name: ctx.IDENTIFIER().getText(),
      args: ctx.argList() ? this.visit(ctx.argList()) : [],
    };
  }

  visitParensExpr(ctx: ParensExprContext): any {

    return this.visit(ctx.expr());
  }

  visitLiteralExpr(ctx: LiteralExprContext): any {

    return this.visit(ctx.literal());
  }

  protected defaultResult(): any {
    return null;
  }
}

export class RustAstCreator {
  private visitor: RustAstVisitor;

  constructor() {
    this.visitor = new RustAstVisitor();
  }

  createAst(input: string): any {
    const inputStream = CharStream.fromString(input);
    const lexer = new RustLexer(inputStream);
    const tokenStream = new CommonTokenStream(lexer);
    const parser = new RustParser(tokenStream);
    const tree = parser.program();
    const ast = tree.accept(this.visitor);
    // return normalizeRustAst(ast);
    return ast;
  }

  async createAstFromFile(filePath: string): Promise<any> {
    const content = await readFile(filePath, "utf-8");
    return this.createAst(content);
  }

}
