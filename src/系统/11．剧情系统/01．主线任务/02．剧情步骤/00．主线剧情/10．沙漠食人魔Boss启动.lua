--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____8BFB_53D6_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["读取当前剧情动作上下文"]
---
-- @noSelfInFile
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_0.YDUserDataGetSafe
local YDUserDataSetSafe = ____require_result_0.YDUserDataSetSafe
local ____require_result_1 = require("lib.扩展函数.BJ函数.14．音效函数")
local PlaySoundBJ = ____require_result_1.PlaySoundBJ
local ____require_result_2 = require("lib.扩展函数.BJ函数.02．单位与英雄")
local IsUnitAliveBJ = ____require_result_2.IsUnitAliveBJ
local ____require_result_3 = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.04．Boss战运行.03．Boss战运行驱动")
local _____542F_52A8Boss_6218_8FD0_884C = ____require_result_3["启动Boss战运行"]
do
    local ____10_FF0E_6C99_6F20_98DF_4EBA_9B54Boss_542F_52A8 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.01．第一章.10．沙漠食人魔Boss启动")
    ____exports["沙漠食人魔Boss启动剧情片段"] = ____10_FF0E_6C99_6F20_98DF_4EBA_9B54Boss_542F_52A8["沙漠食人魔Boss启动剧情片段"]
end
local GroupAddUnit = jass.GroupAddUnit
local GetOwningPlayer = jass.GetOwningPlayer
local PauseUnit = jass.PauseUnit
local Player = jass.Player
local SetUnitInvulnerable = jass.SetUnitInvulnerable
local SetUnitOwner = jass.SetUnitOwner
local PLAYER_NEUTRAL_PASSIVE = jass.PLAYER_NEUTRAL_PASSIVE
local PLAYER_NEUTRAL_AGGRESSIVE = jass.PLAYER_NEUTRAL_AGGRESSIVE
____exports["执行沙漠食人魔Boss启动"] = function(_____53C2_6570)
    local bossUnit = YDUserDataGetSafe("string", "Boss", "沙漠食人魔", "unit")
    if bossUnit == nil or bossUnit == 0 or not IsUnitAliveBJ(bossUnit) then
        return
    end
    if GetOwningPlayer(bossUnit) ~= Player(PLAYER_NEUTRAL_PASSIVE) then
        return
    end
    local _____8840_6761Boss_7EC4 = YDUserDataGetSafe("string", "血条Boss", "单位组", "group")
    if _____8840_6761Boss_7EC4 ~= nil and _____8840_6761Boss_7EC4 ~= 0 then
        GroupAddUnit(_____8840_6761Boss_7EC4, bossUnit)
    end
    SetUnitOwner(
        bossUnit,
        Player(PLAYER_NEUTRAL_AGGRESSIVE),
        true
    )
    PauseUnit(bossUnit, false)
    SetUnitInvulnerable(bossUnit, false)
    local _____4E0A_4E0B_6587 = _____8BFB_53D6_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587()
    YDUserDataSetSafe(
        "string",
        "Boss战",
        "绑定单位",
        "unit",
        bossUnit
    )
    if _____4E0A_4E0B_6587["触发单位"] ~= nil and _____4E0A_4E0B_6587["触发单位"] ~= 0 then
        YDUserDataSetSafe(
            "string",
            "Boss战",
            "触发玩家",
            "unit",
            _____4E0A_4E0B_6587["触发单位"]
        )
    end
    local ____53C2_6570__64AD_653E_97F3_6548_4 = _____53C2_6570["播放音效"]
    if ____53C2_6570__64AD_653E_97F3_6548_4 == nil then
        ____53C2_6570__64AD_653E_97F3_6548_4 = ""
    end
    local _____97F3_6548_53D8_91CF_540D = tostring(____53C2_6570__64AD_653E_97F3_6548_4)
    if _____97F3_6548_53D8_91CF_540D ~= "" then
        local soundHandle = jglobals[_____97F3_6548_53D8_91CF_540D]
        if soundHandle ~= nil and soundHandle ~= 0 then
            PlaySoundBJ(soundHandle)
        end
    end
    _____542F_52A8Boss_6218_8FD0_884C(bossUnit)
end
____exports["沙漠食人魔Boss启动剧情动作注册表"] = {["SRZ蛇人族_沙漠食人魔Boss启动"] = ____exports["执行沙漠食人魔Boss启动"]}
return ____exports
