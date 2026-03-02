const fs = require("fs");
const path = require("path");

const luaPath = path.join(__dirname, "..", "src", "item_modules", "equip_data.lua");
const tsPath = path.join(__dirname, "..", "TS", "item_modules", "equip_data.ts");

let content = fs.readFileSync(luaPath, "utf8");

// Remove return items at end
content = content.replace(/\s*return\s+items\s*$/, "");

// Convert each items['ID'] = { ... } line to TypeScript
content = content.replace(/^items\s*\[\s*['"]([^'"]+)['"]\s*\]\s*=\s*(\{[^}]+\})\s*$/gm, (_, id, obj) => {
  const tsObj = obj.replace(/(\w+)\s*=\s*([^,}]+)(?=[,}])/g, (m, key, val) => {
    const v = val.trim();
    if (/^['"]/.test(v)) return key + ': ' + v.replace(/^'/, '"').replace(/'$/, '"');
    if (/^\d+\.?\d*$/.test(v)) return key + ': ' + v;
    return key + ': ' + v;
  });
  return 'items["' + id + '"] = ' + tsObj + ';';
});

// Remove Lua comments (-- ...) that are on their own line
content = content.replace(/^\s*--.*$/gm, "");

const header = [
  "/** 物品属性表（由 equip_data.lua 转换） */",
  "interface ItemDataEntry {",
  "  name?: string;",
  "  level?: string;",
  "  hp?: number;",
  "  mp?: number;",
  "  dmg?: number;",
  "  armor?: number;",
  "  [key: string]: string | number | undefined;",
  "}",
  "",
  "const items: Record<string, ItemDataEntry> = {};",
  ""
].join("\n");

const footer = "\nexport default items;\n";

const outDir = path.dirname(tsPath);
if (!fs.existsSync(outDir)) fs.mkdirSync(outDir, { recursive: true });
fs.writeFileSync(tsPath, header + content.trim() + footer, "utf8");
console.log("Wrote", tsPath);
