--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____02_FF0E_5267_60C5_52A8_4F5C_6865_63A5 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.02．剧情动作桥接")
local _____5207_6362_5267_60C5_5927_95E8 = ____02_FF0E_5267_60C5_52A8_4F5C_6865_63A5["切换剧情大门"]
local ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.06．剧情通用执行工具")
local _____7ED9_73A9_5BB6_7EC4_6DFB_52A0_591A_4E2A_533A_57DF_89C6_91CE = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["给玩家组添加多个区域视野"]
---
-- @noSelfInFile
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ShowDestructable = jass.ShowDestructable
local function _____6267_884C_738B_57CE_95E8_7981_6536_5C3E()
    _____5207_6362_5267_60C5_5927_95E8({["可破坏物全局名"] = "gg_dest_LTe1_11879", ["开关"] = "打开"})
    local _____963B_6321 = jglobals.gg_dest_B00K_5466
    if _____963B_6321 ~= nil and _____963B_6321 ~= 0 then
        ShowDestructable(_____963B_6321, false)
    end
    _____7ED9_73A9_5BB6_7EC4_6DFB_52A0_591A_4E2A_533A_57DF_89C6_91CE("场景.精灵城大区域,场景.精灵城区域028")
end
do
    local ____21_FF0E_738B_57CE_95E8_7981_5F00_542F = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．第二章.21．王城门禁开启")
    ____exports["王城门禁剧情片段"] = ____21_FF0E_738B_57CE_95E8_7981_5F00_542F["王城门禁剧情片段"]
end
____exports["王城门禁开启剧情动作注册表"] = {["JLC精灵城_王城门禁收尾"] = _____6267_884C_738B_57CE_95E8_7981_6536_5C3E}
return ____exports
