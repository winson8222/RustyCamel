import { RustAstCreator } from './RustAstCreator.js';
import { writeFileSync } from 'fs';


const creator = new RustAstCreator();

const parseRustToJson = async (file: string, outputPath: string) => {
    console.log('Parsing Rust File into JSON:');
    try {
        const ast = await creator.createAstFromFile(file);
        console.log('AST:', ast);
        writeFileSync(outputPath, JSON.stringify(ast, null, 2));
        return true;
    } catch (error) {
        console.error('Error parsing Rust code:', error);
        return false;
    }
};

await parseRustToJson('./src/tests/test1.rs', './src/tests/test1.json');