import { RustAstCreator } from "./RustAstCreator.js";
import { writeFileSync } from "fs";
import path from "path";

const creator = new RustAstCreator();

const parseRustToJson = async (inputPath: string, outputPath: string) => {
  console.log(`Parsing Rust File: ${inputPath}`);
  try {
    const ast = await creator.createAstFromFile(inputPath);
    console.log("AST created successfully");
    writeFileSync(outputPath, JSON.stringify(ast, null, 2));
    console.log(`Output written to: ${outputPath}`);
    return true;
  } catch (error) {
    console.error("Error parsing Rust code:", error);
    return false;
  }
};

// Get input file from command line arguments
const inputFile = process.argv[2];
if (!inputFile) {
  console.error("Please provide a Rust file path");
  process.exit(1);
}

const outputPath = path.join(
  "./src/output",
  `${path.basename(inputFile, '.rs')}.json`
);

(async () => await parseRustToJson(inputFile,outputPath))();