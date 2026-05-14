const fs = require("fs");
const path = require("path");

const file = path.join("C:/Users/Administrator/Desktop/syzl", "TS", "平台扩展API.ts");
let text = fs.readFileSync(file, "utf8");

const paramList = Array.from({ length: 12 }, (_, i) => `参数${i + 1}?: any`).join(", ");
const callList = Array.from({ length: 12 }, (_, i) => `参数${i + 1}`).join(", ");

text = text.replace(
  /export function ([^\(]+)\(\.\.\.参数: any\[\]\): any \{ return 原生函数表\["([^"]+)"\]\(\.\.\.参数\); \}/g,
  (_m, cnName, rawName) => {
    return `export function ${cnName}(this: void, ${paramList}): any { return 原生函数表["${rawName}"](${callList}); }`;
  }
);

text = text.replace(
  /\* - 可调用平台接口统一包装为 `export function 中文名\(\.\.\.参数\)`；/,
  "* - 可调用平台接口统一包装为 `export function 中文名(this: void, 参数1?, 参数2?, ...)`；"
);

fs.writeFileSync(file, text, "utf8");
console.log("updated wrappers to fixed optional parameters");
