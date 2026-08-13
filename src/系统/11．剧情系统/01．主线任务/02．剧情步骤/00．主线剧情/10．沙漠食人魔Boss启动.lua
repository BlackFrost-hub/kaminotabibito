--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____8BFB_53D6_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["读取当前剧情动作上下文"]
local ____11_FF0E_5267_60C5Boss_6218_542F_52A8_6865_63A5 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.11．剧情Boss战启动桥接")
local _____542F_52A8_5267_60C5Boss_6218 = ____11_FF0E_5267_60C5Boss_6218_542F_52A8_6865_63A5["启动剧情Boss战"]
---
-- @noSelfInFile
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.06．单位状态安全包装")
local _____6682_505C_5E76_8BBE_7F6E_65E0_654C_5B89_5168 = ____require_result_0["暂停并设置无敌安全"]
local _____6C99_6F20_98DF_4EBA_9B54_5F85_6218_6682_505C_6765_6E90 = "剧情系统:沙漠食人魔待战"
local ____require_result_1 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_1.YDUserDataGetSafe
local ____require_result_2 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWEAngleBetweenUnitsSafe = ____require_result_2.YDWEAngleBetweenUnitsSafe
local ____require_result_3 = require("lib.扩展函数.BJ函数.14．音效函数")
local PlaySoundBJ = ____require_result_3.PlaySoundBJ
local ____require_result_4 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_4["创建点特效"]
local ____require_result_5 = require("lib.扩展函数.BJ函数.02．单位与英雄")
local IsUnitAliveBJ = ____require_result_5.IsUnitAliveBJ
local ____require_result_6 = require("lib.扩展函数.Star扩展函数.Star扩展库.00．镜头函数")
local StarOther_PanCameraToTimedUnitForPlayer = ____require_result_6.StarOther_PanCameraToTimedUnitForPlayer
do
    local ____10_FF0E_6C99_6F20_98DF_4EBA_9B54Boss_542F_52A8 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.01．第一章.10．沙漠食人魔Boss启动")
    ____exports["沙漠食人魔Boss启动剧情片段"] = ____10_FF0E_6C99_6F20_98DF_4EBA_9B54Boss_542F_52A8["沙漠食人魔Boss启动剧情片段"]
end
local GroupAddUnit = jass.GroupAddUnit
local GetOwningPlayer = jass.GetOwningPlayer
local Player = jass.Player
local SetUnitFacing = jass.SetUnitFacing
local SetUnitOwner = jass.SetUnitOwner
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local PLAYER_NEUTRAL_PASSIVE = jass.PLAYER_NEUTRAL_PASSIVE
local PLAYER_NEUTRAL_AGGRESSIVE = jass.PLAYER_NEUTRAL_AGGRESSIVE
local function _____64AD_653E_6C99_6F20_98DF_4EBA_9B54_5F00_6218_7279_6548(bossUnit)
    local x = GetUnitX(bossUnit)
    local y = GetUnitY(bossUnit)
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = "Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl",
        X = x,
        Y = y,
        ["面向角度"] = 270,
        ["缩放"] = 2.5,
        ["持续秒"] = 1
    })
    do
        local i = 1
        while i <= 6 do
            local angle = 60 * i * math.pi / 180
            _____521B_5EFA_70B9_7279_6548({
                ["模型路径"] = "war3mapImported\\blood2022720203813.mdl",
                X = x + math.cos(angle) * 150,
                Y = y + math.sin(angle) * 150,
                ["面向角度"] = 270,
                ["缩放"] = 2,
                ["持续秒"] = 1
            })
            i = i + 1
        end
    end
end
____exports["执行沙漠食人魔Boss前置"] = function()
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
    _____6682_505C_5E76_8BBE_7F6E_65E0_654C_5B89_5168(bossUnit, _____6C99_6F20_98DF_4EBA_9B54_5F85_6218_6682_505C_6765_6E90)
    local _____4E0A_4E0B_6587 = _____8BFB_53D6_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587()
    if _____4E0A_4E0B_6587["触发单位"] ~= nil and _____4E0A_4E0B_6587["触发单位"] ~= 0 then
        StarOther_PanCameraToTimedUnitForPlayer(
            GetOwningPlayer(_____4E0A_4E0B_6587["触发单位"]),
            bossUnit,
            0.75
        )
        SetUnitFacing(
            bossUnit,
            YDWEAngleBetweenUnitsSafe(bossUnit, _____4E0A_4E0B_6587["触发单位"])
        )
    end
end
____exports["执行沙漠食人魔Boss开战"] = function(_____53C2_6570)
    local bossUnit = YDUserDataGetSafe("string", "Boss", "沙漠食人魔", "unit")
    if bossUnit == nil or bossUnit == 0 or not IsUnitAliveBJ(bossUnit) then
        return
    end
    local ____53C2_6570__64AD_653E_97F3_6548_7 = _____53C2_6570["播放音效"]
    if ____53C2_6570__64AD_653E_97F3_6548_7 == nil then
        ____53C2_6570__64AD_653E_97F3_6548_7 = ""
    end
    local _____97F3_6548_53D8_91CF_540D = tostring(____53C2_6570__64AD_653E_97F3_6548_7)
    _____64AD_653E_6C99_6F20_98DF_4EBA_9B54_5F00_6218_7279_6548(bossUnit)
    if _____97F3_6548_53D8_91CF_540D ~= "" then
        local soundHandle = jglobals[_____97F3_6548_53D8_91CF_540D]
        if soundHandle ~= nil and soundHandle ~= 0 then
            PlaySoundBJ(soundHandle)
        end
    end
    _____542F_52A8_5267_60C5Boss_6218(
        bossUnit,
        {
            ["触发单位"] = _____8BFB_53D6_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587()["触发单位"],
            ["暂停来源"] = _____6C99_6F20_98DF_4EBA_9B54_5F85_6218_6682_505C_6765_6E90
        }
    )
end
____exports["沙漠食人魔Boss启动剧情动作注册表"] = {["SRZ蛇人族_沙漠食人魔Boss前置"] = ____exports["执行沙漠食人魔Boss前置"], ["SRZ蛇人族_沙漠食人魔Boss开战"] = ____exports["执行沙漠食人魔Boss开战"]}
return ____exports
