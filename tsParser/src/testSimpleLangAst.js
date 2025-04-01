import { SimpleLangAstCreator } from './SimpleLangAstCreator.js';
// Example SimpleLang expressions
const expressions = [
    // Simple integer
    "42",
    // Basic arithmetic
    "1 + 2",
    "3 * 4",
    "10 - 5",
    "15 / 3",
    // Parenthesized expressions
    "(1 + 2) * 3",
    "2 * (3 + 4)",
    // Complex expressions
    "1 + 2 * 3",
    "(1 + 2) * (3 + 4)",
    "10 / (2 + 3)"
];
// Create an instance of SimpleLangAstCreator
const creator = new SimpleLangAstCreator();
// Test each expression
console.log('Testing SimpleLang AST creation:');
expressions.forEach((expr, index) => {
    console.log(`\nExpression ${index + 1}: ${expr}`);
    try {
        const ast = creator.createAst(expr);
        console.log('AST:');
        console.log(JSON.stringify(ast, null, 2));
    }
    catch (error) {
        console.error('Error parsing expression:', error);
    }
});
//# sourceMappingURL=testSimpleLangAst.js.map