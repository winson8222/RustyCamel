export function normalizeRustAst(node) {
    if (!node || typeof node !== "object")
        return node;
    switch (node.type) {
        case "Literal":
            return {
                tag: "lit",
                val: node.value
            };
        case "IdentExpr":
            return {
                tag: "nam",
                sym: node.name
            };
        case "FunctionCall":
            return {
                tag: "app",
                fun: normalizeRustAst({ type: "IdentExpr", name: node.name }),
                args: node.args.map(normalizeRustAst)
            };
        case "BinaryExpr":
            return {
                tag: "binop",
                sym: node.operator,
                frst: normalizeRustAst(node.left),
                scnd: normalizeRustAst(node.right)
            };
        case "UnaryNegation":
        case "UnaryNot":
            return {
                tag: "unop",
                sym: node.type === "UnaryNegation" ? "-unary" : "!",
                frst: normalizeRustAst(node.expr)
            };
        case "ReturnExpr":
            return {
                tag: "ret",
                expr: normalizeRustAst(node.expr)
            };
        case "LetDecl":
            return {
                tag: "let",
                sym: node.name,
                expr: normalizeRustAst(node.value)
            };
        case "FnDecl":
            return {
                tag: "fun",
                sym: node.name,
                prms: node.params.map((p) => p.name),
                body: normalizeRustAst(node.body)
            };
        case "Block":
            return {
                tag: "blk",
                body: normalizeRustAst(node.returnExpr ?? { type: "Literal", value: undefined })
            };
        case "IfExpr":
            return {
                tag: "cond",
                pred: normalizeRustAst(node.condition),
                cons: normalizeRustAst(node.thenBranch),
                alt: normalizeRustAst(node.elseBranch ?? { type: "Literal", value: undefined })
            };
        default:
            if (node.children) {
                return {
                    tag: node.type,
                    children: node.children.map(normalizeRustAst)
                };
            }
            else if (node.text) {
                return node.text;
            }
            else {
                return node;
            }
    }
}
//# sourceMappingURL=astToJSON.js.map