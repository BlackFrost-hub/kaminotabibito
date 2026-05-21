/**
 * Blizzard.j 在地图编译产物里通常会注入 `udg_bj_*` / `jass.globals` 字段。
 * 纯 Lua 或精简运行时可能缺失，这里补默认值并写回 `jass.globals`，避免读 undefined。
 *
 * 数值与 Blizzard.j 一致：`bj_RADTODEG = 180/π`，`bj_DEGTORAD = π/180`。
 * `bj_lastCreatedUnit` / `bj_lastReplacedUnit` 为可变全局，缺省时置为 nil，由创建/替换单位逻辑更新。
 */
const jglobals = require("jass.globals");
const DEFAULT_BJ_PI = 3.141592653589793;
const DEFAULT_BJ_RADTODEG = 180 / DEFAULT_BJ_PI;
const DEFAULT_BJ_DEGTORAD = DEFAULT_BJ_PI / 180;
/** 与 Blizzard.j `bj_PI` 对齐的工程常量 */
export const BJ_PI = DEFAULT_BJ_PI;
/** 弧度 → 角度乘数（Blizzard.j `bj_RADTODEG` = 180/bj_PI） */
export const BJ_RADTODEG = DEFAULT_BJ_RADTODEG;
/** 角度 → 弧度乘数（Blizzard.j `bj_DEGTORAD` = bj_PI/180） */
export const BJ_DEGTORAD = DEFAULT_BJ_DEGTORAD;
// 导出 bj_ 前缀常量（优先从 jglobals 获取）
export const bj_PI = jglobals.bj_PI ?? BJ_PI;
export const bj_RADTODEG = jglobals.bj_RADTODEG ?? BJ_RADTODEG;
export const bj_DEGTORAD = jglobals.bj_DEGTORAD ?? BJ_DEGTORAD;
/**
 * 将缺失的 Blizzard 全局补到 `jass.globals`。
 * 已有非 nil 值（含地图里配好的常数）不会覆盖。
 */
export function ensureBlizzardJGlobals() {
    const g = jglobals;
    if (g.bj_PI == null)
        g.bj_PI = bj_PI;
    if (g.bj_RADTODEG == null)
        g.bj_RADTODEG = bj_RADTODEG;
    if (g.bj_DEGTORAD == null)
        g.bj_DEGTORAD = bj_DEGTORAD;
    if (g.bj_lastCreatedUnit == null)
        g.bj_lastCreatedUnit = null;
    if (g.bj_lastReplacedUnit == null)
        g.bj_lastReplacedUnit = null;
}
ensureBlizzardJGlobals();
