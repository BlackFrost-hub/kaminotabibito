/**
 * 在 tstl 之后修正生成的 Lua，适配魔兽/YDWE 运行环境。
 * 背景：TSTL 默认把不少 TS 调用当成「带 self 的 Lua 方法」，会生成 table:fn(...)、多传 nil、
 * 以及 export 与点号调用错位等；地图侧 require 与原生 API 与 Node 不一致，不能指望上游改完。
 * 详细坑位见 .cursor/rules/war3-tstl/jass-pitfalls.mdc
 *
 * require("…")：已在 TS/global.d.ts 对 declare require 使用 @noSelf，并由 tsconfig tstl.noResolvePaths
 * 避免 TSTL 解析点分路径失败；此处不再做 require(nil, …) 替换。
 */

const fs = require("fs");
const path = require("path");

const SRC_DIR = path.join(__dirname, "..", "src");

/** 对同一内容串行应用 [RegExp, string | function] */
function applyPairs(content, pairs) {
  let c = content;
  for (const [re, rep] of pairs) {
    c = c.replace(re, rep);
  }
  return c;
}

/** 原「伤害事件」+「装备排泄」里与 JASS/BJ 多传 nil 相关的替换；API 名足够特殊，全局应用不易误伤 */
const WC3_NIL_FIRST = [
  [/GroupEnumUnitsInRect\s*\(\s*nil\s*,\s*/g, "GroupEnumUnitsInRect("],
  [/Condition\s*\(\s*nil\s*,\s*/g, "Condition("],
  [/CreateTrigger\s*\(\s*nil\s*\)/g, "CreateTrigger()"],
  [/CreateRegion\s*\(\s*nil\s*\)/g, "CreateRegion()"],
  [/CreateGroup\s*\(\s*nil\s*\)/g, "CreateGroup()"],
  [/GetWorldBounds\s*\(\s*nil\s*\)/g, "GetWorldBounds()"],
  [/RegionAddRect\s*\(\s*nil\s*,\s*/g, "RegionAddRect("],
  [/TriggerRegisterEnterRegion\s*\(\s*nil\s*,\s*/g, "TriggerRegisterEnterRegion("],
  [/TriggerAddCondition\s*\(\s*nil\s*,\s*/g, "TriggerAddCondition("],
  [/TriggerAddAction\s*\(\s*nil\s*,\s*/g, "TriggerAddAction("],
  [/DestroyGroup\s*\(\s*nil\s*,\s*/g, "DestroyGroup("],
  [/RegisterPlayerUnitEvent\s*\(\s*nil\s*,\s*/g, "RegisterPlayerUnitEvent("],
  [/initEnumUnit\s*\(\s*nil\s*\)/g, "initEnumUnit()"],
  [/getEventUnitDamaged\s*\(\s*nil\s*\)/g, "getEventUnitDamaged()"],
  [/getUnitTypeHero\s*\(\s*nil\s*\)/g, "getUnitTypeHero()"],
  [/recreateDamageTrigger\s*\(\s*nil\s*\)/g, "recreateDamageTrigger()"],
  [/ConvertUnitEvent\s*\(\s*nil\s*,\s*/g, "ConvertUnitEvent("],
  [/ConvertUnitType\s*\(\s*nil\s*,\s*/g, "ConvertUnitType("],
  [/(____self_\d+_IsUnitType_\d+)\(\s*____self_\d+\s*,\s*(\w+)\s*,\s*([^)]+)\)/g, "$1($2, $3)"],
  [/cb\s*\(\s*nil\s*,\s*nil\s*,\s*su\s*,/g, "cb(nil, su,"],
  [/TriggerRegisterDeathEvent\s*\(\s*nil\s*,\s*/g, "TriggerRegisterDeathEvent("],
  [/RemoveItem\s*\(\s*nil\s*,\s*/g, "RemoveItem("],
  [/TriggerRemoveAction\s*\(\s*nil\s*,\s*/g, "TriggerRemoveAction("],
  [/DestroyTrigger\s*\(\s*nil\s*,\s*/g, "DestroyTrigger("],
  [/registerItemForCleanup\s*\(\s*nil\s*,\s*/g, "registerItemForCleanup("],
  [/function registerItemForCleanup\s*\(\s*self\s*,\s*item\s*\)/g, "function registerItemForCleanup(item)"],
];

const GLOBAL_RULES = [
  [/_G:print\s*\(/g, "_G.print("],
  [/_G:DzBindEffect\s*\(/g, "_G.DzBindEffect("],
  [/_G:DzUnbindEffect\s*\(/g, "_G.DzUnbindEffect("],
  [/jassConsole:write\s*\(/g, "jassConsole.write("],
  [/\b(jass|japi|jassMain|blizzard|math|os):/g, "$1."],
  [/g:GetEventDamageSource\s*\(/g, "g.GetEventDamageSource("],
  [/GetEventDamageSource\s*\(\s*nil\s*\)/g, "GetEventDamageSource()"],
  [/BlzGetUnitMaxHP\s*\(\s*nil\s*,\s*/g, "BlzGetUnitMaxHP("],
  [/\bjassGetSrc\s*\(\s*nil\s*\)/g, "jassGetSrc()"],
  [/\bgGetSrc\s*\(\s*nil\s*\)/g, "gGetSrc()"],
  [/gt\.BlzGetUnitMaxHP\s*\(\s*gt\s*,\s*targetUnit\s*\)/g, "BlzGetUnitMaxHP(targetUnit)"],
  [/gt\.GetUnitState\s*\(\s*gt\s*,\s*targetUnit\s*,\s*maxLife\s*\)/g, "GetUnitState(targetUnit, maxLife)"],
  [/function (____exports\.STES_\w+)\((self|____self),\s*/g, "function $1("],
  [/function (____exports\.STES_\w+)\((self|____self)\)/g, "function $1()"],
  [/_____4F24_5BB3_51FD_6570:/g, "_____4F24_5BB3_51FD_6570."],
  // TSTL：从 require 表取出导出函数再调用时，会多传一个 nil 当「self」，但 @noSelfInFile 已去掉导出签名里的 self → 首参错位 / 直接早退
  [/\bonDamageEvent\s*\(\s*nil\s*,\s*/g, "onDamageEvent("],
  [/string:(char|byte)\s*\(/g, "string.$1("],
  [/tostring\s*\(\s*nil\s*,\s*/g, "tostring("],
  [/pcall\s*\(\s*nil\s*,\s*function\s*/g, "pcall(function "],
  [/originalPrint\s*\(\s*nil\s*,\s*/g, "originalPrint("],
  [
    /(\w+)\s*\(\s*nil\s*,\s*(\w+)\s*,\s*("([^"]*事件[^"]*)"|'([^']*事件[^']*)')\s*\)/g,
    (_m, fn, trig, _q, dq, sq) => {
      const ev = dq !== undefined ? '"' + dq + '"' : "'" + sq + "'";
      return fn + "(" + trig + ", " + ev + ")";
    },
  ],
  [/STES_Register\s*\(\s*nil\s*,\s*(\w+)\s*,\s*([^)]+)\s*\)/g, "STES_Register($1, $2)"],
  [
    /local\s+success\s*,\s*result\s*=\s*unpack\s*\(\s*pcall\s*\(/g,
    "local success, result = pcall(",
  ],
  [/\),\s*\n\s*1\s*,\s*\n\s*2\s*\n\s*\)/g, ")"],
  [
    /local\s+(\w+)\s*,\s*(\w+)\s*=\s*unpack\s*\(\s*\n\s*pcall\s*\(/g,
    "local $1, $2 = pcall(",
  ],
  [
    /local\s+items\s*=\s*require\s*\(\s*"系统\.02．物品系统\.01．装备数据"\s*\)(?!\s*\.default)/g,
    'local items = require("系统.02．物品系统.01．装备数据").default',
  ],
  [/(_G\.print\s*=\s*function)\s*\(\s*____\s*,\s*\.\.\.\s*\)/g, "$1(...)"],
  [/(____opt_\d+)\s*\(\s*self\s*,\s*/g, "$1("],
  [/\bgetPid\s*\(\s*nil\s*,\s*/g, "getPid("],
  [/\bpr\s*\(\s*nil\s*,\s*/g, "pr("],
  ...WC3_NIL_FIRST,
];

/** 仅当路径命中时应用；`f(nil,` 等过宽模式仍锁在「硬件函数」等文件内 */
const FILE_RULES = [
  {
    test: (rel) =>
      rel.includes("07．技能函数") || rel.includes("08．伤害函数") || rel.includes("Star自定义事件"),
    rules: [
      [/function (____exports\.\w+)\((self|____self),\s*/g, "function $1("],
      [/function (____exports\.\w+)\((self|____self)\)/g, "function $1()"],
      [/____exports\.(\w+)\(nil,\s*/g, "____exports.$1("],
      [/____exports\.(\w+)\(nil\)/g, "____exports.$1()"],
    ],
  },
  {
    test: (rel) => rel.includes("02．伤害修正"),
    rules: [
      [/\bcalcArmorReduction\(nil,\s*/g, "calcArmorReduction("],
      [/\bcalcPiercedArmorReduction\(nil,\s*/g, "calcPiercedArmorReduction("],
    ],
  },
  {
    test: (rel) => rel.includes("05．装备掉落"),
    rules: [
      [
        /out\[#out \+ 1\]\s*=\s*nonAlwaysIds\[idx \- 1\]/g,
        "out[#out + 1] = nonAlwaysIds[idx]",
      ],
    ],
  },
  {
    test: (rel) => rel.includes("硬件函数"),
    rules: [
      [/\bfTrg\s*\(\s*nil\s*,\s*/g, "fTrg("],
      [/\bfByCode\s*\(\s*nil\s*,\s*/g, "fByCode("],
      [/\bfStr\s*\(\s*nil\s*,\s*/g, "fStr("],
      [/\bf\s*\(\s*nil\s*,\s*/g, "f("],
      [/\bf\s*\(\s*nil\s*\)/g, "f()"],
      [/\bgetP\s*\(\s*nil\s*\)/g, "getP()"],
      [/\bgetK\s*\(\s*nil\s*\)/g, "getK()"],
      [/\bDzTriggerRegisterKeyEventTrg\s*\(\s*_G\s*,\s*/g, "DzTriggerRegisterKeyEventTrg("],
      [/\bDzTriggerRegisterKeyEventByCode\s*\(\s*_G\s*,\s*/g, "DzTriggerRegisterKeyEventByCode("],
      [/\bDzTriggerRegisterKeyEvent\s*\(\s*_G\s*,\s*/g, "DzTriggerRegisterKeyEvent("],
    ],
  },
  {
    test: (rel) => rel.includes("测试233注册"),
    rules: [[/\bf\s*\(\s*nil\s*,\s*/g, "f("]],
  },
  {
    test: (rel) => rel.includes("基础UI"),
    // japi: 已由 GLOBAL_RULES 统一处理
    rules: [
      [/getGameUI\s*\(\s*nil\s*\)/g, "getGameUI()"],
      [/disp\s*\(\s*\n\s*nil\s*,\s*\n\s*pl\s*,/g, "disp(pl,"],
    ],
  },
  {
    test: (rel) => rel.includes("任意测试2"),
    rules: [
      [/\bp\s*\(\s*nil\s*,\s*/g, "p("],
      [/\bstesMod:/g, "stesMod."],
    ],
  },
  {
    test: (rel) => rel.includes("dot伤害"),
    rules: [
      [
        /____self_(\d+)_ConvertUnitType_(\d+)\(\s*____self_\1\s*,\s*([^)]+)\s*\)/g,
        "jass.ConvertUnitType($3)",
      ],
    ],
  },
];

/**
 * @param {string} rel 相对 SRC_DIR 的路径（/ 分隔）
 */
function applyRules(content, rel) {
  let c = applyPairs(content, GLOBAL_RULES);

  if (c.includes("____this_1 = _G") && c.includes(".print")) {
    c = c.replace(/____opt_0\s*\(\s*____this_1\s*,\s*/g, "_G.print(");
  }

  for (const block of FILE_RULES) {
    if (!block.test(rel)) continue;
    c = applyPairs(c, block.rules);
  }

  return c;
}

function fixFile(filePath) {
  const original = fs.readFileSync(filePath, "utf8");
  const rel = path.relative(SRC_DIR, filePath).split(path.sep).join("/");
  const next = applyRules(original, rel);
  if (next !== original) {
    fs.writeFileSync(filePath, next, "utf8");
    return true;
  }
  return false;
}

function walkDir(dir) {
  const files = [];
  for (const name of fs.readdirSync(dir)) {
    const full = path.join(dir, name);
    if (fs.statSync(full).isDirectory()) files.push(...walkDir(full));
    else if (name.endsWith(".lua")) files.push(full);
  }
  return files;
}

let count = 0;
for (const f of walkDir(SRC_DIR)) {
  if (fixFile(f)) {
    count++;
    console.log("Fixed: " + path.relative(SRC_DIR, f));
  }
}
console.log("fix-lua-for-pack: " + count + " file(s) updated.");
