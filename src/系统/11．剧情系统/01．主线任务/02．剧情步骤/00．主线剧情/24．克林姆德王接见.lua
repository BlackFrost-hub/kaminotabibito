local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataClearSafe = ____require_result_0.YDUserDataClearSafe
local YDUserDataGetSafe = ____require_result_0.YDUserDataGetSafe
local YDUserDataSetSafe = ____require_result_0.YDUserDataSetSafe
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
do
    local ____24_FF0E_514B_6797_59C6_5FB7_738B_63A5_89C1 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．第二章.24．克林姆德王接见")
    ____exports["克林姆德国王委托剧情片段"] = ____24_FF0E_514B_6797_59C6_5FB7_738B_63A5_89C1["克林姆德国王委托剧情片段"]
end
local CreateUnit = jass.CreateUnit
local PauseUnit = jass.PauseUnit
local Player = jass.Player
local SetUnitInvulnerable = jass.SetUnitInvulnerable
local SetUnitOwner = jass.SetUnitOwner
____exports["执行克林姆德王接见"] = function(_____53C2_6570)
    YDUserDataClearSafe("string", "主线NPC", "jl禁军门卫", "unit")
    YDUserDataClearSafe("string", "主线NPC", "jl禁军门卫2", "unit")
    local _____730E_9B42_5F15_7528 = YDUserDataGetSafe("string", "jq", "npc", "unit")
    if _____730E_9B42_5F15_7528 ~= nil and _____730E_9B42_5F15_7528 ~= 0 then
        SetUnitInvulnerable(_____730E_9B42_5F15_7528, true)
        PauseUnit(_____730E_9B42_5F15_7528, true)
    end
    local _____536B_961F_5355_4F4D = YDUserDataGetSafe("string", "主线NPC", "jlw", "unit")
    if _____536B_961F_5355_4F4D ~= nil and _____536B_961F_5355_4F4D ~= 0 then
        SetUnitOwner(
            _____536B_961F_5355_4F4D,
            Player(6),
            true
        )
    end
    local _____730E_9B42_7C7B_578BID = stringToFourCCSafe("ohun")
    if not (_____730E_9B42_7C7B_578BID > 0) then
        return
    end
    local _____730E_9B42 = CreateUnit(
        Player(jass.PLAYER_NEUTRAL_AGGRESSIVE),
        _____730E_9B42_7C7B_578BID,
        __TS__Number(_____53C2_6570["猎魂位置X"]) or -2823.1,
        __TS__Number(_____53C2_6570["猎魂位置Y"]) or -14119.8,
        180
    )
    if _____730E_9B42 == nil or _____730E_9B42 == 0 then
        return
    end
    YDUserDataSetSafe(
        "string",
        "jq",
        "npc",
        "unit",
        _____730E_9B42
    )
end
local function _____6267_884C_53D1_5E03_5DE8_9B54_7EBF_4EFB_52A1()
end
____exports["克林姆德王接见剧情动作注册表"] = {["JLC精灵城_克林姆德王接见"] = ____exports["执行克林姆德王接见"], ["JLC精灵城_发布巨魔线任务"] = _____6267_884C_53D1_5E03_5DE8_9B54_7EBF_4EFB_52A1}
return ____exports
