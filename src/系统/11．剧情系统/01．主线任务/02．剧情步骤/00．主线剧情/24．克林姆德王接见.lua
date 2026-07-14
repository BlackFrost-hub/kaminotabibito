local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local ____02_FF0E_5267_60C5_52A8_4F5C_6865_63A5 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.02．剧情动作桥接")
local _____53D1_9001_5267_60C5_4EFB_52A1_6D88_606F = ____02_FF0E_5267_60C5_52A8_4F5C_6865_63A5["发送剧情任务消息"]
---
-- @noSelfInFile
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_0["添加单位暂停"]
local _____730E_9B42_63A5_89C1_6682_505C_6765_6E90 = "剧情系统:猎魂接见"
local ____require_result_1 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataClearSafe = ____require_result_1.YDUserDataClearSafe
local YDUserDataGetSafe = ____require_result_1.YDUserDataGetSafe
local YDUserDataSetSafe = ____require_result_1.YDUserDataSetSafe
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_2.stringToFourCCSafe
do
    local ____24_FF0E_514B_6797_59C6_5FB7_738B_63A5_89C1 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．第二章.24．克林姆德王接见")
    ____exports["克林姆德国王委托剧情片段"] = ____24_FF0E_514B_6797_59C6_5FB7_738B_63A5_89C1["克林姆德国王委托剧情片段"]
end
local CreateUnit = jass.CreateUnit
local Player = jass.Player
local SetUnitInvulnerable = jass.SetUnitInvulnerable
local SetUnitOwner = jass.SetUnitOwner
local bj_QUESTMESSAGE_ITEMACQUIRED = jglobals.bj_QUESTMESSAGE_ITEMACQUIRED
____exports["执行克林姆德王接见"] = function(_____53C2_6570)
    YDUserDataClearSafe("string", "主线NPC", "jl禁军门卫", "unit")
    YDUserDataClearSafe("string", "主线NPC", "jl禁军门卫2", "unit")
    local _____730E_9B42_5F15_7528 = YDUserDataGetSafe("string", "jq", "npc", "unit")
    if _____730E_9B42_5F15_7528 ~= nil and _____730E_9B42_5F15_7528 ~= 0 then
        SetUnitInvulnerable(_____730E_9B42_5F15_7528, true)
        _____6DFB_52A0_5355_4F4D_6682_505C(_____730E_9B42_5F15_7528, _____730E_9B42_63A5_89C1_6682_505C_6765_6E90)
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
____exports["执行接见金币提示"] = function(_____53C2_6570)
    local ____53D1_9001_5267_60C5_4EFB_52A1_6D88_606F_4 = _____53D1_9001_5267_60C5_4EFB_52A1_6D88_606F
    local ____53C2_6570__63D0_793A_6587_672C_3 = _____53C2_6570["提示文本"]
    if ____53C2_6570__63D0_793A_6587_672C_3 == nil then
        ____53C2_6570__63D0_793A_6587_672C_3 = "|cffffff00『系统提示』：|r所有英雄收到了|cffffff0015000金币！|r"
    end
    ____53D1_9001_5267_60C5_4EFB_52A1_6D88_606F_4({
        ["消息类型"] = bj_QUESTMESSAGE_ITEMACQUIRED,
        ["文本"] = tostring(____53C2_6570__63D0_793A_6587_672C_3)
    })
end
____exports["克林姆德王接见剧情动作注册表"] = {["JLC精灵城_克林姆德王接见"] = ____exports["执行克林姆德王接见"], ["JLC精灵城_接见金币提示"] = ____exports["执行接见金币提示"], ["JLC精灵城_发布巨魔线任务"] = _____6267_884C_53D1_5E03_5DE8_9B54_7EBF_4EFB_52A1}
return ____exports
