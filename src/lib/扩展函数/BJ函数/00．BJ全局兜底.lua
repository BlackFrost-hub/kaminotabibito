--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- Blizzard.j 在地图编译产物里通常会注入 `udg_bj_*` / `jass.globals` 字段。
-- 纯 Lua 或精简运行时可能缺失，这里补默认值并写回 `jass.globals`，避免读 undefined。
-- 
-- 数值与 Blizzard.j 一致：`bj_RADTODEG = 180/π`，`bj_DEGTORAD = π/180`。
-- `bj_lastCreatedUnit` / `bj_lastReplacedUnit` 为可变全局，缺省时置为 nil，由创建/替换单位逻辑更新。
local jglobals = require("jass.globals")
--- 弧度 → 角度乘数（Blizzard.j `bj_RADTODEG`）
____exports.BJ_RADTODEG = 180 / math.pi
--- 角度 → 弧度乘数（Blizzard.j `bj_DEGTORAD`）
____exports.BJ_DEGTORAD = math.pi / 180
--- 与 Blizzard.j `bj_PI` 对齐的工程常量
____exports.BJ_PI = math.pi
--- 将缺失的 Blizzard 全局补到 `jass.globals`。
-- 已有非 nil 值（含地图里配好的常数）不会覆盖。
function ____exports.ensureBlizzardJGlobals(self)
    local g = jglobals
    if g.bj_PI == nil then
        g.bj_PI = ____exports.BJ_PI
    end
    if g.bj_RADTODEG == nil then
        g.bj_RADTODEG = ____exports.BJ_RADTODEG
    end
    if g.bj_DEGTORAD == nil then
        g.bj_DEGTORAD = ____exports.BJ_DEGTORAD
    end
    if g.bj_lastCreatedUnit == nil then
        g.bj_lastCreatedUnit = nil
    end
    if g.bj_lastReplacedUnit == nil then
        g.bj_lastReplacedUnit = nil
    end
end
____exports.ensureBlizzardJGlobals(nil)
return ____exports
