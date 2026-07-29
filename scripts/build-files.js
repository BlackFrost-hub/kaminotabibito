const fs = require("fs");
const path = require("path");
const childProcess = require("child_process");
const ts = require("typescript");
const tstl = require("typescript-to-lua");

const ROOT_DIR = path.resolve(__dirname, "..");
const TS_DIR = fs.realpathSync(path.join(ROOT_DIR, "TS"));
const TSCONFIG_PATH = path.join(ROOT_DIR, "tsconfig.json");
const FIX_LUA_SCRIPT = path.join(ROOT_DIR, "scripts", "fix-lua-for-pack.js");
const SYNC_LUA_SCRIPT = path.join(ROOT_DIR, "scripts", "sync-lua-from-ts.js");
const TSTL_CONFIG_PARSER = require(
  path.join(ROOT_DIR, "node_modules", "typescript-to-lua", "dist", "cli", "tsconfig.js")
);

function isPathInside(parentPath, childPath) {
  const relativePath = path.relative(parentPath, childPath);
  return (
    relativePath !== "" &&
    relativePath !== ".." &&
    !relativePath.startsWith(".." + path.sep) &&
    !path.isAbsolute(relativePath)
  );
}

function resolveSourceFile(sourceArgument) {
  const candidatePath = path.isAbsolute(sourceArgument)
    ? path.normalize(sourceArgument)
    : path.resolve(ROOT_DIR, sourceArgument);

  if (!fs.existsSync(candidatePath) || !fs.statSync(candidatePath).isFile()) {
    throw new Error("Source file does not exist: " + sourceArgument);
  }

  const sourcePath = fs.realpathSync(candidatePath);
  if (!isPathInside(TS_DIR, sourcePath)) {
    throw new Error("Source file must be inside TS/: " + sourceArgument);
  }
  if (!sourcePath.toLowerCase().endsWith(".ts")) {
    throw new Error("Source file must have a .ts extension: " + sourceArgument);
  }

  return sourcePath;
}

function runNodeScript(scriptPath, args) {
  const result = childProcess.spawnSync(process.execPath, [scriptPath].concat(args || []), {
    cwd: ROOT_DIR,
    stdio: "inherit",
    shell: false,
  });

  if (result.error) {
    throw result.error;
  }
  return result.status === null ? 1 : result.status;
}

function normalizePathKey(filePath) {
  const normalizedPath = path.resolve(filePath);
  return process.platform === "win32" ? normalizedPath.toLowerCase() : normalizedPath;
}

function getCanonicalFileName(fileName) {
  return process.platform === "win32" ? fileName.toLowerCase() : fileName;
}

function getCurrentDirectory() {
  return ROOT_DIR;
}

function getNewLine() {
  return ts.sys.newLine;
}

const DIAGNOSTIC_HOST = { getCanonicalFileName, getCurrentDirectory, getNewLine };

function reportDiagnostics(diagnostics) {
  if (diagnostics.length === 0) return;
  const output = ts.formatDiagnosticsWithColorAndContext(diagnostics, DIAGNOSTIC_HOST);
  console.error(output.trimEnd());
}

function hasErrorDiagnostics(diagnostics) {
  for (const diagnostic of diagnostics) {
    if (diagnostic.category === ts.DiagnosticCategory.Error) return true;
  }
  return false;
}

function findProgramSourceFiles(program, sourceFiles) {
  const sourceFileByPath = new Map();
  for (const sourceFile of program.getSourceFiles()) {
    sourceFileByPath.set(normalizePathKey(sourceFile.fileName), sourceFile);
  }

  const selectedSourceFiles = [];
  for (const sourceFile of sourceFiles) {
    const selectedSourceFile = sourceFileByPath.get(normalizePathKey(sourceFile));
    if (!selectedSourceFile) {
      throw new Error("Source file is not included by tsconfig.json: " + path.relative(ROOT_DIR, sourceFile));
    }
    selectedSourceFiles.push(selectedSourceFile);
  }
  return selectedSourceFiles;
}

function getSelectedTypeScriptDiagnostics(program, sourceFiles) {
  const diagnostics = [];
  diagnostics.push(...program.getOptionsDiagnostics());
  diagnostics.push(...program.getGlobalDiagnostics());
  for (const sourceFile of sourceFiles) {
    diagnostics.push(...program.getSyntacticDiagnostics(sourceFile));
    diagnostics.push(...program.getSemanticDiagnostics(sourceFile));
  }
  return ts.sortAndDeduplicateDiagnostics(diagnostics);
}

function compileSelectedFiles(sourceFiles) {
  const config = TSTL_CONFIG_PARSER.parseConfigFileWithSystem(TSCONFIG_PATH, {}, ts.sys);
  const configDiagnostics = ts.getConfigFileParsingDiagnostics(config);
  if (hasErrorDiagnostics(configDiagnostics)) {
    reportDiagnostics(configDiagnostics);
    return 1;
  }

  const program = ts.createProgram({
    rootNames: config.fileNames,
    options: config.options,
    projectReferences: config.projectReferences,
    configFileParsingDiagnostics: configDiagnostics,
  });
  const selectedSourceFiles = findProgramSourceFiles(program, sourceFiles);
  const typeScriptDiagnostics = getSelectedTypeScriptDiagnostics(program, selectedSourceFiles);
  if (hasErrorDiagnostics(typeScriptDiagnostics)) {
    reportDiagnostics(typeScriptDiagnostics);
    return 1;
  }

  const emitResult = new tstl.Transpiler().emit({ program, sourceFiles: selectedSourceFiles });
  const emitDiagnostics = ts.sortAndDeduplicateDiagnostics(emitResult.diagnostics);
  reportDiagnostics(emitDiagnostics);
  return hasErrorDiagnostics(emitDiagnostics) || emitResult.emitSkipped ? 1 : 0;
}

function printSelectedFiles(sourceFiles) {
  console.log("build-files: compiling " + sourceFiles.length + " source file(s):");
  for (const sourceFile of sourceFiles) {
    console.log("  " + path.relative(ROOT_DIR, sourceFile));
  }
}

function main() {
  const sourceArguments = process.argv.slice(2);
  if (sourceArguments.length === 0) {
    console.error('Usage: npm run build:files -- "TS\\path\\file.ts" [more files...]');
    return 1;
  }

  let sourceFiles;
  try {
    sourceFiles = Array.from(new Set(sourceArguments.map(resolveSourceFile)));
  } catch (error) {
    console.error(error instanceof Error ? error.message : String(error));
    return 1;
  }

  printSelectedFiles(sourceFiles);

  try {
    let exitCode = compileSelectedFiles(sourceFiles);
    if (exitCode !== 0) return exitCode;

    exitCode = runNodeScript(FIX_LUA_SCRIPT);
    if (exitCode !== 0) return exitCode;

    return runNodeScript(SYNC_LUA_SCRIPT);
  } catch (error) {
    console.error(error instanceof Error ? error.message : String(error));
    return 1;
  }
}

process.exitCode = main();
