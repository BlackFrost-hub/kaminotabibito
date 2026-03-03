/**
 * 修复 TSTL 生成的 Lua，使其在魔兽地图环境中可运行。
 * 在 tstl 编译后运行（npm run build:full 或 build 前先 run build:lua）。
 */

const fs = require("fs");
const path = require("path");

const SRC_DIR = path.join(__dirname, "..", "src");

function fixFile(filePath) {
  let content = fs.readFileSync(filePath, "utf8");
  const original = content;

  // 1. require(nil, "xxx") -> require("xxx")  魔兽 require 只接受一个参数
  content = content.replace(/require\s*\(\s*nil\s*,\s*("([^"]*)"|'([^']*)')\s*\)/g, (_, q, dq, sq) => {
    const name = dq !== undefined ? dq : sq;
    return 'require("' + name.replace(/"/g, '\\"') + '")';
  });

  // 2. _G:print( -> _G.print(  Lua 全局调用用点号
  content = content.replace(/_G:print\s*\(/g, "_G.print(");

  // 3. _G.print = function(____, ...) -> _G.print = function(...)  去掉多余的 self 参数
  content = content.replace(/_G\.print\s*=\s*function\s*\(\s*____\s*,\s*\.\.\.\s*\)/g, "_G.print = function(...)");

  // 4. jassConsole:write( -> jassConsole.write(
  content = content.replace(/jassConsole:write\s*\(/g, "jassConsole.write(");

  // 5. jassMain: -> jassMain.   JASS API 用点号调用
  content = content.replace(/jassMain:/g, "jassMain.");

  // 6. jass: -> jass.   JASS 原生函数第一个参数是 handle，不能用冒号
  content = content.replace(/\bjass:/g, "jass.");

  // 7. string:char( -> string.char(  Lua 标准库用点号
  content = content.replace(/string:char\s*\(/g, "string.char(");

  // 8. tostring(nil, x) -> tostring(x)
  content = content.replace(/tostring\s*\(\s*nil\s*,\s*/g, "tostring(");

  // 9. pcall(nil, function -> pcall(function
  content = content.replace(/pcall\s*\(\s*nil\s*,\s*function\s*/g, "pcall(function ");

  // 10. originalPrint(nil, -> originalPrint(
  content = content.replace(/originalPrint\s*\(\s*nil\s*,\s*/g, "originalPrint(");

  // 11~13. fourCCToString/addStat/initEvents 保留 (nil, ...) 因 TSTL 生成的是 (self, ...) 需要第一个参数

  // 14. unpack(pcall(...), 1, 2) -> pcall(...)   Lua 的 pcall 直接返回 (ok, result)
  content = content.replace(
    /local\s+success\s*,\s*result\s*=\s*unpack\s*\(\s*pcall\s*\(/g,
    "local success, result = pcall("
  );
  // 去掉 pcall 后面的 ), 1, 2 ) 多行
  content = content.replace(/\),\s*\n\s*1\s*,\s*\n\s*2\s*\n\s*\)/g, ")");

  // 15. equip_data 使用 export default，返回 { default = items }，需取 .default 才是物品表（仅当还没有 .default 时添加）
  content = content.replace(
    /local\s+items\s*=\s*require\s*\(\s*"系统\.装备\.装备数据"\s*\)(?!\s*\.default)/g,
    "local items = require(\"系统.装备.装备数据\").default"
  );

  if (content !== original) {
    fs.writeFileSync(filePath, content, "utf8");
    return true;
  }
  return false;
}

function walkDir(dir) {
  const files = [];
  const list = fs.readdirSync(dir);
  for (const name of list) {
    const full = path.join(dir, name);
    const stat = fs.statSync(full);
    if (stat.isDirectory()) {
      files.push(...walkDir(full));
    } else if (name.endsWith(".lua")) {
      files.push(full);
    }
  }
  return files;
}

const luaFiles = walkDir(SRC_DIR);
let count = 0;
for (const f of luaFiles) {
  if (fixFile(f)) {
    count++;
    console.log("Fixed: " + path.relative(SRC_DIR, f));
  }
}
console.log("fix-lua-for-pack: " + count + " file(s) updated.");
