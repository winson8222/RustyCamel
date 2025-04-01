export function normalizeRustAst(node: any): any {
	if (!node || typeof node !== "object") return node;

	// Simplify ANTLR context nodes with only 1 child
	if (node.constructor?.name?.endsWith('Context')) {
		const children = node.children?.map(normalizeRustAst) || [];
		if (children.length === 1) {
			return children[0];
		}
		return { tag: node.constructor.name, children };
	}

	switch (node.type) {
		case "Program":
			return {
				tag: "blk",
				body: {
					tag: "seq",
					stmts: node.statements.map(normalizeRustAst)
				}
			};

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
				fun: { tag: "nam", sym: node.name },
				args: node.args.map(normalizeRustAst)
			};

		case "MacroCall":
			return {
				tag: "macro",
				name: node.name,
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
			return {
				tag: "unop",
				sym: "-unary",
				frst: normalizeRustAst(node.expr)
			};

		case "UnaryNot":
			return {
				tag: "unop",
				sym: "!",
				frst: normalizeRustAst(node.expr)
			};

		case "BorrowExpr":
			return {
				tag: "borrow",
				mut: node.mutable,
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
				prms: node.params,
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

		case "WhileLoop":
			return {
				tag: "while",
				pred: normalizeRustAst(node.condition),
				body: normalizeRustAst(node.body)
			};

		case "ParensExpr":
			return normalizeRustAst(node.expr);

		default:
			if (node.children) {
				return {
					tag: node.type,
					children: node.children.map(normalizeRustAst)
				};
			}
			if (node.text) {
				return node.text;
			}
			return node;
	}
}