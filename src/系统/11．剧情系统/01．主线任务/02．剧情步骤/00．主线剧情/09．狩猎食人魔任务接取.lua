local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local ____03_FF0E_5267_60C5Boss_9884_7F6E_6865_63A5 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.03．剧情Boss预置桥接")
local _____6CE8_518C_5267_60C5Boss_8303_56F4_9884_7F6E_89E6_53D1_5668 = ____03_FF0E_5267_60C5Boss_9884_7F6E_6865_63A5["注册剧情Boss范围预置触发器"]
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataSetSafe = ____require_result_0.YDUserDataSetSafe
local ____require_result_1 = require("系统.01．单位系统.08．单位配置表.02．Boss配置表")
local _____6309_540D_5B57_53CD_67E5Boss_5355_4F4DID = ____require_result_1["按名字反查Boss单位ID"]
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_2.stringToFourCCSafe
local ____require_result_3 = require("lib.扩展函数.BJ函数.01．触发与事件")
local TriggerRegisterUnitInRangeSimple = ____require_result_3.TriggerRegisterUnitInRangeSimple
local ____require_result_4 = require("lib.扩展函数.Star扩展函数.GS扩展库.00．极坐标投影")
local GS_PolarProjectionBJ = ____require_result_4.GS_PolarProjectionBJ
local ____require_result_5 = require("lib.扩展函数.BJ函数.07．杂项")
local GetRandomDirectionDeg = ____require_result_5.GetRandomDirectionDeg
do
    local ____09_FF0E_72E9_730E_98DF_4EBA_9B54_4EFB_52A1_63A5_53D6 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.01．第一章.09．狩猎食人魔任务接取")
    ____exports["蛇人族接受食人魔任务剧情片段"] = ____09_FF0E_72E9_730E_98DF_4EBA_9B54_4EFB_52A1_63A5_53D6["蛇人族接受食人魔任务剧情片段"]
end
local CreatePermanentCorpseLocBJ = jass.CreatePermanentCorpseLocBJ
local CreateUnit = jass.CreateUnit
local GetUnitLoc = jass.GetUnitLoc
local PauseUnit = jass.PauseUnit
local Player = jass.Player
local RemoveLocation = jass.RemoveLocation
local SetUnitInvulnerable = jass.SetUnitInvulnerable
local PLAYER_NEUTRAL_PASSIVE = jass.PLAYER_NEUTRAL_PASSIVE
local bj_CORPSETYPE_BONE = require("jass.globals").bj_CORPSETYPE_BONE
local function _____521B_5EFA_6C99_6F20_98DF_4EBA_9B54_5C38_9AA8_5708(bossUnit)
    if bossUnit == nil or bossUnit == 0 then
        return
    end
    local _____6B65_5175_5355_4F4DID = stringToFourCCSafe("hfoo")
    if not (_____6B65_5175_5355_4F4DID > 0) then
        return
    end
    do
        local i = 1
        while i <= 6 do
            local sourceLoc = GetUnitLoc(bossUnit)
            local corpseLoc = GS_PolarProjectionBJ(sourceLoc, 150, 60 * i)
            if corpseLoc ~= nil and corpseLoc ~= 0 then
                CreatePermanentCorpseLocBJ(
                    bj_CORPSETYPE_BONE,
                    _____6B65_5175_5355_4F4DID,
                    Player(PLAYER_NEUTRAL_PASSIVE),
                    corpseLoc,
                    GetRandomDirectionDeg()
                )
                RemoveLocation(corpseLoc)
            end
            i = i + 1
        end
    end
end
____exports["执行蛇人族接受食人魔任务"] = function(_____53C2_6570)
    local _____6B21_5143_88C2_7F1D_5355_4F4DID = stringToFourCCSafe("e08L")
    if _____6B21_5143_88C2_7F1D_5355_4F4DID > 0 then
        local _____88C2_7F1D_5355_4F4D = CreateUnit(
            Player(PLAYER_NEUTRAL_PASSIVE),
            _____6B21_5143_88C2_7F1D_5355_4F4DID,
            -20606.8,
            2780.5,
            0
        )
        if _____88C2_7F1D_5355_4F4D ~= nil and _____88C2_7F1D_5355_4F4D ~= 0 then
            YDUserDataSetSafe(
                "string",
                "剧情",
                "沙漠次元裂缝",
                "unit",
                _____88C2_7F1D_5355_4F4D
            )
        end
    end
    local bossRawId = _____6309_540D_5B57_53CD_67E5Boss_5355_4F4DID("沙漠食人魔")
    local bossTypeId = stringToFourCCSafe(bossRawId)
    if not (bossTypeId > 0) then
        return
    end
    local bossUnit = CreateUnit(
        Player(PLAYER_NEUTRAL_PASSIVE),
        bossTypeId,
        28354.9,
        13678.3,
        270
    )
    if bossUnit == nil or bossUnit == 0 then
        return
    end
    YDUserDataSetSafe(
        "string",
        "Boss",
        "沙漠食人魔",
        "unit",
        bossUnit
    )
    SetUnitInvulnerable(bossUnit, true)
    PauseUnit(bossUnit, true)
    _____6CE8_518C_5267_60C5Boss_8303_56F4_9884_7F6E_89E6_53D1_5668(
        bossUnit,
        __TS__Number(_____53C2_6570["注册范围"]) or 850,
        "沙漠食人魔Boss启动",
        "jlc_desert_ogre_boss_start",
        "Boss.沙漠食人魔",
        10
    )
    _____521B_5EFA_6C99_6F20_98DF_4EBA_9B54_5C38_9AA8_5708(bossUnit)
end
____exports["狩猎食人魔任务接取剧情动作注册表"] = {["SRZ蛇人族_接受食人魔任务"] = ____exports["执行蛇人族接受食人魔任务"]}
return ____exports
