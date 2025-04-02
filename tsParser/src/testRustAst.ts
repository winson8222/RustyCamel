import { normalizeRustAst } from './astToJSON.js';
import { RustAstCreator } from './RustAstCreator.js';

// Example Rust code snippets
const rustExamples = [
    // Simple function with return
    // `fn add(x: i32, y: i32) -> i32 {
    //     x + y
    // }`,

    // Function with if-else
    // `fn process(x: i32) -> i32 {
    //     if x > 0 {
    //         x * 2
    //     } else {
    //         -x
    //     }
    // }`,

    // Function with let declaration
    // `fn calculate(x: i32) -> i32 {
    //     let result = x * 2;
    //     result + 1
    // }`,

    // Function with multiple operations
    // `fn complex(x: i32) -> i32 {
    //     let doubled = x * 2;
    //     let squared = doubled * doubled;
    //     if squared > 100 {
    //         squared
    //     } else {
    //         doubled
    //     }
    // }`

    `fn factorial(n: i32) -> i32 {
    if n == 0 {
        1
    } else {
        n * factorial(n - 1)
    }
}

factorial(5);`


];

// Create an instance of RustAstCreator
const creator = new RustAstCreator();

// Test each example
console.log('Testing Rust AST creation:');
rustExamples.forEach((code, index) => {
    console.log(`\nExample ${index + 1}:`);
    console.log('Code:');
    console.log(code);

    try {
        const ast = creator.createAst(code);
        const json = normalizeRustAst(ast);
        console.log(JSON.stringify(json));
    } catch (error) {
        console.error('Error parsing code:', error);
    }
});

// // Test with file input
// console.log('\nTesting with file input:');
// creator.createAstFromFile('./test.rs')
//     .then(ast => {
//         console.log('AST from file:');
//         console.log(JSON.stringify(ast, null, 2));
//     })
//     .catch(error => {
//         console.error('Error parsing file:', error);
//     }); 