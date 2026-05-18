const fs = require("fs");
const path = require("path");

const baseDir = "C:/Users/Administrator/Desktop/syzl/TS/系统/02．物品系统/15．装备技能/00．物品";
const skipFiles = new Set(["index.ts", "01．回沙之书.ts", "02．女妖头饰.ts"]);

const files = fs.readdirSync(baseDir)
  .filter(f => f.endsWith(".ts") && !skipFiles.has(f))
  .sort();

for (const file of files) {
  const fullPath = path.join(baseDir, file);
  let content = fs.readFileSync(fullPath, "utf8");

  // Extract function name - use [一-鿿\w] for Chinese chars
  const match = content.match(/export function ([一-鿿\w]+)\(/);
  if (!match) {
    console.log(file + ": no export function found, skipping");
    continue;
  }
  const funcName = match[1];
  const moduleName = file.replace(".ts", "");

  // 1. Add debugLogForce import after @noSelfInFile
  const importBlock = 'const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {\n  debugLogForce: (this: void, module: string, ...args: any[]) => void;\n};\n';
  const nsifIdx = content.indexOf("/** @noSelfInFile */");
  if (nsifIdx >= 0) {
    let afterNsif = nsifIdx + 21;
    while (afterNsif < content.length && (content[afterNsif] === "\r" || content[afterNsif] === "\n")) {
      afterNsif++;
    }
    content = content.slice(0, afterNsif) + "\n" + importBlock + "\n" + content.slice(afterNsif);
  }

  // 2. Find the function body start {
  const searchStart = content.indexOf("export function " + funcName);
  if (searchStart < 0) {
    console.log(file + ": function not found in content after insert, skipping");
    continue;
  }
  const bodyStart = content.indexOf("{", searchStart);
  if (bodyStart < 0) {
    console.log(file + ": no { found after function signature, skipping");
    continue;
  }

  const debugLine = '  debugLogForce("' + moduleName + '", "进入", "' + funcName + '");';
  content = content.slice(0, bodyStart + 1) + "\n" + debugLine + "\n" + content.slice(bodyStart + 1);

  fs.writeFileSync(fullPath, content, "utf8");
  console.log(file + ": OK - " + funcName);
}

console.log("\nDone!");
