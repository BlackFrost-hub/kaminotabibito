/**
 * 修复 TSTL 生成的 Lua，使其在魔兽地图环境中可运行。
 * 在 tstl 编译后运行（npm run build:full 或 build 前先 run build:lua）。
 *
 * 常见 TSTL 坑：
 * - 函数调用会多传 nil(self)，如 STES_Register(trig, name) -> X(nil, trig, name)，需 10b 修正。
 * - (globalThis as any).print?.(x) 会变成 ____opt_0(____this_1, x)，需 10c 去掉 self。
 * - 数组下标 arr[i] 会编译成 Lua 的 arr[i+1]，TS 里用 0-based 才能对应 JASS 的 1-based。
 * - Lua 表 1-based：TS 里 random(1,n)+arr[idx-1] 编译后 arr[0]=nil，需在下方对具体文件把 [idx-1] 改为 [idx]。见 .cursor/rules/war3-tstl-jass-pitfalls.mdc 第 7 条。
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

  // 6b. blizzard: -> blizzard.   模块调用用点号
  content = content.replace(/\bblizzard:/g, "blizzard.");

  // 6c. math: -> math.  os: -> os.
  content = content.replace(/\bmath:/g, "math.");
  content = content.replace(/\bos:/g, "os.");

  // 7. string:char( -> string.char(  Lua 标准库用点号
  content = content.replace(/string:char\s*\(/g, "string.char(");

  // 7b. string:byte( -> string.byte(
  content = content.replace(/string:byte\s*\(/g, "string.byte(");

  // 8. tostring(nil, x) -> tostring(x)
  content = content.replace(/tostring\s*\(\s*nil\s*,\s*/g, "tostring(");

  // 9. pcall(nil, function -> pcall(function
  content = content.replace(/pcall\s*\(\s*nil\s*,\s*function\s*/g, "pcall(function ");

  // 10. originalPrint(nil, -> originalPrint(
  content = content.replace(/originalPrint\s*\(\s*nil\s*,\s*/g, "originalPrint(");

  // 10b. STES_Register 仅两参 (trig, eventName)，去掉 TSTL 多传的 nil（任意变量名，第三参为含「事件」的字符串）
  content = content.replace(/(\w+)\s*\(\s*nil\s*,\s*(\w+)\s*,\s*("([^"]*事件[^"]*)"|'([^']*事件[^']*)')\s*\)/g, (m, fn, trig, _q, dq, sq) => {
    const ev = dq !== undefined ? '"' + dq + '"' : "'" + sq + "'";
    return fn + "(" + trig + ", " + ev + ")";
  });

  // 10c. _G.print?.(x) 被 TSTL 编译成 ____opt_N(____this_N, x)，仅当确认为 _G.print 时去掉 self
  if (content.includes("____this_1 = _G") && content.includes(".print")) {
    content = content.replace(/____opt_0\s*\(\s*____this_1\s*,\s*/g, "_G.print(");
  }

  // 11~13. fourCCToString/addStat/initEvents 保留 (nil, ...) 因 TSTL 生成的是 (self, ...) 需要第一个参数

  // 14. unpack(pcall(...), 1, 2) -> pcall(...)   Lua 的 pcall 直接返回 (ok, result)
  content = content.replace(
    /local\s+success\s*,\s*result\s*=\s*unpack\s*\(\s*pcall\s*\(/g,
    "local success, result = pcall("
  );
  // 去掉 pcall 后面的 ), 1, 2 ) 多行
  content = content.replace(/\),\s*\n\s*1\s*,\s*\n\s*2\s*\n\s*\)/g, ")");

  // 14b. local x, y = unpack( pcall(...) ) -> local x, y = pcall(...)  pcall 直接返回多值无需 unpack
  content = content.replace(
    /local\s+(\w+)\s*,\s*(\w+)\s*=\s*unpack\s*\(\s*\n\s*pcall\s*\(/g,
    "local $1, $2 = pcall("
  );

  // 15. equip_data 使用 export default，返回 { default = items }，需取 .default 才是物品表（仅当还没有 .default 时添加）
  content = content.replace(
    /local\s+items\s*=\s*require\s*\(\s*"系统\.装备\.装备数据"\s*\)(?!\s*\.default)/g,
    "local items = require(\"系统.装备.装备数据\").default"
  );

  // 16. Lua 1-based 修复：TS 里 random(1,n) 配 arr[idx-1] 在 Lua 中 idx=1 时 arr[0]=nil。凡此类“从 1-based 表随机取”处改为 [idx]。规则见 .cursor/rules/war3-tstl-jass-pitfalls.mdc §7
  if (filePath.includes("装备掉落")) {
    content = content.replace(
      /out\[#out \+ 1\]\s*=\s*nonAlwaysIds\[idx \- 1\]/g,
      "out[#out + 1] = nonAlwaysIds[idx]"
    );
  }

  // 17. 伤害事件.lua：TSTL 对 jass 调用多传 nil(self)，导致 GroupEnumUnitsInRect(nil,grp,bounds,cond) 等参数错位，去掉首参 nil
  if (filePath.includes("伤害事件")) {
    content = content.replace(/GroupEnumUnitsInRect\s*\(\s*nil\s*,\s*/g, "GroupEnumUnitsInRect(");
    content = content.replace(/Condition\s*\(\s*nil\s*,\s*/g, "Condition(");
    content = content.replace(/CreateTrigger\s*\(\s*nil\s*\)/g, "CreateTrigger()");
    content = content.replace(/CreateRegion\s*\(\s*nil\s*\)/g, "CreateRegion()");
    content = content.replace(/CreateGroup\s*\(\s*nil\s*\)/g, "CreateGroup()");
    content = content.replace(/GetWorldBounds\s*\(\s*nil\s*\)/g, "GetWorldBounds()");
    content = content.replace(/RegionAddRect\s*\(\s*nil\s*,\s*/g, "RegionAddRect(");
    content = content.replace(/TriggerRegisterEnterRegion\s*\(\s*nil\s*,\s*/g, "TriggerRegisterEnterRegion(");
    content = content.replace(/TriggerAddCondition\s*\(\s*nil\s*,\s*/g, "TriggerAddCondition(");
    content = content.replace(/TriggerAddAction\s*\(\s*nil\s*,\s*/g, "TriggerAddAction(");
    content = content.replace(/DestroyGroup\s*\(\s*nil\s*,\s*/g, "DestroyGroup(");
    content = content.replace(/RegisterPlayerUnitEvent\s*\(\s*nil\s*,\s*/g, "RegisterPlayerUnitEvent(");
    content = content.replace(/initEnumUnit\s*\(\s*nil\s*\)/g, "initEnumUnit()");
    content = content.replace(/getEventUnitDamaged\s*\(\s*nil\s*\)/g, "getEventUnitDamaged()");
    content = content.replace(/getUnitTypeHero\s*\(\s*nil\s*\)/g, "getUnitTypeHero()");
    content = content.replace(/recreateDamageTrigger\s*\(\s*nil\s*\)/g, "recreateDamageTrigger()");
    content = content.replace(/ConvertUnitEvent\s*\(\s*nil\s*,\s*/g, "ConvertUnitEvent(");
    content = content.replace(/ConvertUnitType\s*\(\s*nil\s*,\s*/g, "ConvertUnitType(");
    content = content.replace(/(____self_\d+_IsUnitType_\d+)\(\s*____self_\d+\s*,\s*(\w+)\s*,\s*([^)]+)\)/g, "$1($2, $3)");
    // 回调：TSTL 编译成 cb(self, unit, damage, ...)，传 (nil, su, sd, ...) 使 unit=su；去掉多传的第二个 nil 即可
    content = content.replace(/cb\s*\(\s*nil\s*,\s*nil\s*,\s*su\s*,/g, "cb(nil, su,");
  }

  // 18. 装备排泄.lua：去掉 jass 调用多传的 nil，保证 RemoveItem/DestroyTrigger 等参数正确
  if (filePath.includes("装备排泄")) {
    // 修复私有函数签名：TSTL 多加了 self 参数，导致调用时 item 被错位到 self
    content = content.replace(
      /function registerItemForCleanup\s*\(\s*self\s*,\s*item\s*\)/g,
      "function registerItemForCleanup(item)"
    );
    content = content.replace(/CreateTrigger\s*\(\s*nil\s*\)/g, "CreateTrigger()");
    content = content.replace(/TriggerRegisterDeathEvent\s*\(\s*nil\s*,\s*/g, "TriggerRegisterDeathEvent(");
    content = content.replace(/TriggerAddAction\s*\(\s*nil\s*,\s*/g, "TriggerAddAction(");
    content = content.replace(/RemoveItem\s*\(\s*nil\s*,\s*/g, "RemoveItem(");
    content = content.replace(/TriggerRemoveAction\s*\(\s*nil\s*,\s*/g, "TriggerRemoveAction(");
    content = content.replace(/DestroyTrigger\s*\(\s*nil\s*,\s*/g, "DestroyTrigger(");
    content = content.replace(/registerItemForCleanup\s*\(\s*nil\s*,\s*/g, "registerItemForCleanup(");
  }

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
