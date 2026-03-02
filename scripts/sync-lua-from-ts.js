/**
 * 根据 TS 目录同步 src 下的 Lua：删除没有对应 .ts 的 .lua，并清理空目录。
 * 约定：TS/ 与 src/ 一一对应，TS/a/b/c.ts -> src/a/b/c.lua
 * 不在此对应关系内的 .lua（如 lualib_bundle.lua）保留不删。
 */

const fs = require("fs");
const path = require("path");

const ROOT = path.join(__dirname, "..");
const TS_DIR = path.join(ROOT, "TS");
const SRC_DIR = path.join(ROOT, "src");

// 这些文件由 TSTL 生成到 src/ 但无对应 TS 源，不删除
const KEEP_LUA_WITHOUT_TS = ["lualib_bundle.lua"];

function walk(dir, baseDir, list) {
  const names = fs.readdirSync(dir);
  for (const name of names) {
    const full = path.join(dir, name);
    const rel = path.relative(baseDir, full);
    const stat = fs.statSync(full);
    if (stat.isDirectory()) {
      walk(full, baseDir, list);
    } else {
      list.push(rel);
    }
  }
}

function removeEmptyDirs(dir) {
  if (!fs.existsSync(dir)) return 0;
  let count = 0;
  let names = fs.readdirSync(dir);
  for (const name of names) {
    const full = path.join(dir, name);
    try {
      if (fs.statSync(full).isDirectory()) {
        count += removeEmptyDirs(full);
      }
    } catch (_) {
      // 可能已被删除
    }
  }
  names = fs.readdirSync(dir);
  if (names.length === 0) {
    fs.rmdirSync(dir);
    return 1;
  }
  return count;
}

const srcLua = [];
walk(SRC_DIR, SRC_DIR, srcLua);
const toDelete = [];

for (const rel of srcLua) {
  if (!rel.endsWith(".lua")) continue;
  const basename = path.basename(rel);
  if (KEEP_LUA_WITHOUT_TS.includes(basename)) continue;

  const tsRel = rel.slice(0, -4) + ".ts";
  const tsPath = path.join(TS_DIR, tsRel);
  if (!fs.existsSync(tsPath)) {
    toDelete.push(path.join(SRC_DIR, rel));
  }
}

let deleted = 0;
for (const file of toDelete) {
  fs.unlinkSync(file);
  deleted++;
  console.log("Deleted (no TS): " + path.relative(SRC_DIR, file));
}

removeEmptyDirs(SRC_DIR);

console.log("sync-lua-from-ts: removed " + deleted + " file(s), cleaned empty dirs.");
