local ____lualib = require("lualib_bundle")
local __TS__StringIncludes = ____lualib.__TS__StringIncludes
local __TS__StringSplit = ____lualib.__TS__StringSplit
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_0.YDUserDataGetSafe
do
    local ____08_FF0E_86C7_4EBA_65CF_85CF_54C1_7BA1_5BB6_521D_89C1 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.01．第一章.08．蛇人族藏品管家初见")
    ____exports["蛇人族藏品管家初见剧情片段"] = ____08_FF0E_86C7_4EBA_65CF_85CF_54C1_7BA1_5BB6_521D_89C1["蛇人族藏品管家初见剧情片段"]
end
local Player = jass.Player
local SetUnitOwner = jass.SetUnitOwner
____exports["执行蛇人族藏品管家初见"] = function(_____53C2_6570)
    local ____53C2_6570_NPC_1 = _____53C2_6570.NPC
    if ____53C2_6570_NPC_1 == nil then
        ____53C2_6570_NPC_1 = ""
    end
    local ____npc_5F15_7528 = tostring(____53C2_6570_NPC_1)
    local _____952E_540D = __TS__StringIncludes(____npc_5F15_7528, ".") and (__TS__StringSplit(____npc_5F15_7528, ".")[2] or "") or ____npc_5F15_7528
    if _____952E_540D == "" then
        return
    end
    local npc = YDUserDataGetSafe("string", "主线NPC", _____952E_540D, "unit")
    if npc == nil or npc == 0 then
        return
    end
    SetUnitOwner(
        npc,
        Player(6),
        true
    )
end
____exports["蛇人族藏品管家初见剧情动作注册表"] = {["SRZ蛇人族_藏品管家初见"] = ____exports["执行蛇人族藏品管家初见"]}
return ____exports
