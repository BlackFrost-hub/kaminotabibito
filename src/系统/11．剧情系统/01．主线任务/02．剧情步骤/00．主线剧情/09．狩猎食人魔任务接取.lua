local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local ____03_FF0E_5267_60C5Boss_9884_7F6E_6865_63A5 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.03．剧情Boss预置桥接")
local _____6CE8_518C_5267_60C5Boss_8303_56F4_9884_7F6E_89E6_53D1_5668 = ____03_FF0E_5267_60C5Boss_9884_7F6E_6865_63A5["注册剧情Boss范围预置触发器"]
local ____02_FF0E_5267_60C5NPC_521B_5EFA = require("系统.11．剧情系统.00．公共.02．剧情NPC创建")
local _____521B_5EFA_5267_60C5_573A_666F_5355_4F4D = ____02_FF0E_5267_60C5NPC_521B_5EFA["创建剧情场景单位"]
---
-- @noSelfInFile
local jass = require("jass.common")
local _____6C99_6F20_98DF_4EBA_9B54_5F85_6218_6682_505C_6765_6E90 = "剧情系统:沙漠食人魔待战"
local ____require_result_0 = require("系统.01．单位系统.08．单位配置表.02．Boss配置表")
local _____6309_540D_5B57_53CD_67E5Boss_5355_4F4DID = ____require_result_0["按名字反查Boss单位ID"]
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
local ____require_result_2 = require("lib.扩展函数.BJ函数.01．触发与事件")
local TriggerRegisterUnitInRangeSimple = ____require_result_2.TriggerRegisterUnitInRangeSimple
local ____require_result_3 = require("系统.07．地形系统.03．区域传送")
local _____6CE8_518C_5267_60C5_914D_7F6E_4F20_9001 = ____require_result_3["注册剧情配置传送"]
local _____8BFB_53D6_5267_60C5_4F20_9001_914D_7F6E = ____require_result_3["读取剧情传送配置"]
local ____require_result_4 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D = ____require_result_4["是玩家英雄组单位"]
local _____83B7_53D6_73A9_5BB6_82F1_96C4_5355_4F4D_7EC4 = ____require_result_4["获取玩家英雄单位组"]
local ____require_result_5 = require("lib.扩展函数.BJ函数.08．单位BJ扩展")
local CreatePermanentCorpseLocBJ = ____require_result_5.CreatePermanentCorpseLocBJ
local ____require_result_6 = require("lib.扩展函数.Star扩展函数.GS扩展库.00．极坐标投影")
local GS_PolarProjectionBJ = ____require_result_6.GS_PolarProjectionBJ
local ____require_result_7 = require("lib.扩展函数.BJ函数.07．杂项")
local GetRandomDirectionDeg = ____require_result_7.GetRandomDirectionDeg
do
    local ____09_FF0E_72E9_730E_98DF_4EBA_9B54_4EFB_52A1_63A5_53D6 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.01．第一章.09．狩猎食人魔任务接取")
    ____exports["蛇人族接受食人魔任务剧情片段"] = ____09_FF0E_72E9_730E_98DF_4EBA_9B54_4EFB_52A1_63A5_53D6["蛇人族接受食人魔任务剧情片段"]
end
local GetUnitLoc = jass.GetUnitLoc
local Player = jass.Player
local RemoveLocation = jass.RemoveLocation
local PLAYER_NEUTRAL_PASSIVE = jass.PLAYER_NEUTRAL_PASSIVE
local bj_CORPSETYPE_BONE = require("jass.globals").bj_CORPSETYPE_BONE
local _____98DF_4EBA_9B54_4EFB_52A1_4F20_9001_914D_7F6EID = "jlc_desert_ogre_challenge"
local _____53D6_6D88_98DF_4EBA_9B54_4EFB_52A1_4F20_9001
local function _____6CE8_518C_98DF_4EBA_9B54_4EFB_52A1_4F20_9001()
    if _____53D6_6D88_98DF_4EBA_9B54_4EFB_52A1_4F20_9001 ~= nil then
        return
    end
    _____53D6_6D88_98DF_4EBA_9B54_4EFB_52A1_4F20_9001 = _____6CE8_518C_5267_60C5_914D_7F6E_4F20_9001(
        _____98DF_4EBA_9B54_4EFB_52A1_4F20_9001_914D_7F6EID,
        {
            ["读取玩家英雄组"] = _____83B7_53D6_73A9_5BB6_82F1_96C4_5355_4F4D_7EC4,
            ["允许进入单位"] = _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D,
            ["完成"] = function()
                _____53D6_6D88_98DF_4EBA_9B54_4EFB_52A1_4F20_9001 = nil
            end
        }
    )
end
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
    local _____4F20_9001_914D_7F6E = _____8BFB_53D6_5267_60C5_4F20_9001_914D_7F6E(_____98DF_4EBA_9B54_4EFB_52A1_4F20_9001_914D_7F6EID)
    if _____4F20_9001_914D_7F6E ~= nil then
        local _____88C2_7F1D_5355_4F4D = _____521B_5EFA_5267_60C5_573A_666F_5355_4F4D({
            ["单位ID"] = "e08L",
            X = _____4F20_9001_914D_7F6E["入口中心X"],
            Y = _____4F20_9001_914D_7F6E["入口中心Y"],
            ["朝向"] = 0,
            ["玩家ID"] = PLAYER_NEUTRAL_PASSIVE,
            ["YD表"] = "剧情",
            ["YD键"] = "沙漠次元裂缝",
            ["YD字段"] = "unit"
        })
        if _____88C2_7F1D_5355_4F4D ~= nil and _____88C2_7F1D_5355_4F4D ~= 0 then
            _____6CE8_518C_98DF_4EBA_9B54_4EFB_52A1_4F20_9001()
        end
    end
    local bossRawId = _____6309_540D_5B57_53CD_67E5Boss_5355_4F4DID("沙漠食人魔")
    if bossRawId == nil then
        return
    end
    local bossUnit = _____521B_5EFA_5267_60C5_573A_666F_5355_4F4D({
        ["单位ID"] = bossRawId,
        X = 28354.9,
        Y = 13678.3,
        ["朝向"] = 270,
        ["玩家ID"] = PLAYER_NEUTRAL_PASSIVE,
        ["YD表"] = "Boss",
        ["YD键"] = "沙漠食人魔",
        ["YD字段"] = "unit",
        ["初始化无敌"] = true,
        ["初始化暂停来源"] = _____6C99_6F20_98DF_4EBA_9B54_5F85_6218_6682_505C_6765_6E90
    })
    if bossUnit == nil or bossUnit == 0 then
        return
    end
    _____6CE8_518C_5267_60C5Boss_8303_56F4_9884_7F6E_89E6_53D1_5668(
        bossUnit,
        __TS__Number(_____53C2_6570["注册范围"]) or 1000,
        "沙漠食人魔Boss启动",
        "jlc_desert_ogre_boss_start",
        "Boss.沙漠食人魔",
        10
    )
    _____521B_5EFA_6C99_6F20_98DF_4EBA_9B54_5C38_9AA8_5708(bossUnit)
end
____exports["狩猎食人魔任务接取剧情动作注册表"] = {["SRZ蛇人族_接受食人魔任务"] = ____exports["执行蛇人族接受食人魔任务"]}
return ____exports
