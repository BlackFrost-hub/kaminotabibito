--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.14．铃仙.00．配置")
local _____94C3_4ED9_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["铃仙单位技能配置"]
local ____12_FF0E_94C3_4ED9 = require("系统.05．Buff系统.03．Buff表.02．英雄.12．铃仙")
local _____94C3_4ED9BuffID = ____12_FF0E_94C3_4ED9["铃仙BuffID"]
local ____00A_FF0E_8868_73B0_5DE5_5177 = require("系统.03．技能系统.05．单位技能.04．英雄技能.14．铃仙.00A．表现工具")
local _____64AD_653E_94C3_4ED9_5355_4F4D_7ED1_5B9A_97F3_6548 = ____00A_FF0E_8868_73B0_5DE5_5177["播放铃仙单位绑定音效"]
local _____64AD_653E_94C3_4ED9_914D_7F6E_52A8_4F5C = ____00A_FF0E_8868_73B0_5DE5_5177["播放铃仙配置动作"]
local ____00B_FF0E_5206_8EAB_4E0E_72B6_6001_7BA1_7406 = require("系统.03．技能系统.05．单位技能.04．英雄技能.14．铃仙.00B．分身与状态管理")
local _____662F_94C3_4ED9_672C_4F53 = ____00B_FF0E_5206_8EAB_4E0E_72B6_6001_7BA1_7406["是铃仙本体"]
local _____662F_6709_6548_654C_5BF9_76EE_6807 = ____00B_FF0E_5206_8EAB_4E0E_72B6_6001_7BA1_7406["是有效敌对目标"]
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_1.registerSpellEffectListener
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_2.addDelayedCallback
local addPeriodicCallback = ____require_result_2.addPeriodicCallback
local removePeriodicCallback = ____require_result_2.removePeriodicCallback
local ____require_result_3 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_3.YDUserDataGetSafe
local YDUserDataSetSafe = ____require_result_3.YDUserDataSetSafe
local YDWESetUnitAbilityStateSafe = ____require_result_3.YDWESetUnitAbilityStateSafe
local ____require_result_4 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_6280_80FD_4F24_5BB3 = ____require_result_4["造成技能伤害"]
local ____require_result_5 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_5["创建点特效"]
local ____require_result_6 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境")
local _____65BD_52A0_7729_6655 = ____require_result_6["施加眩晕"]
local ____require_result_7 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_7.registerManualBuff
local ____require_result_8 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getUnitsInRange = ____require_result_8.getUnitsInRange
local ____require_result_9 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_9["读取单位攻击力"]
local _____8BFB_53D6_5355_4F4D_654F_6377 = ____require_result_9["读取单位敏捷"]
local _____5355_4F4D_5B58_6D3B = ____require_result_9["单位存活"]
local _____8DDD_79BBXY = ____require_result_9["距离XY"]
local _____4E24_70B9_89D2_5EA6 = ____require_result_9["两点角度"]
local _____6781_5750_6807X = ____require_result_9["极坐标X"]
local _____6781_5750_6807Y = ____require_result_9["极坐标Y"]
local ____require_result_10 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.24．整数与时间换算")
local _____79D2_8F6C_6BEB_79D2 = ____require_result_10["秒转毫秒"]
local _____5411_4E0B_53D6_6574_6574_6570 = ____require_result_10["向下取整整数"]
local cfg = _____94C3_4ED9_5355_4F4D_6280_80FD_914D_7F6E
local ____R_6280_80FDID_6570_503C = stringToFourCCSafe(cfg["R技能ID"])
local ____R_4E8C_6BB5_6280_80FDID_6570_503C = stringToFourCCSafe(cfg["R二段技能ID"])
local _____51C6_5FC3_9A6C_7532ID = stringToFourCCSafe(cfg.R["准心马甲ID"])
local _____5F39_5E55_9A6C_7532ID = stringToFourCCSafe(cfg.R["弹幕马甲ID"])
local _____6280_80FD_51B7_5374_72B6_6001 = 1
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local GetHandleId = jass.GetHandleId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetSpellTargetX = jass.GetSpellTargetX
local GetSpellTargetY = jass.GetSpellTargetY
local GetOwningPlayer = jass.GetOwningPlayer
local SetUnitPathing = jass.SetUnitPathing
local SetUnitAnimation = jass.SetUnitAnimation
local SetUnitPosition = jass.SetUnitPosition
local SetUnitScale = jass.SetUnitScale
local SetUnitFlyHeight = jass.SetUnitFlyHeight
local CreateUnit = jass.CreateUnit
local RemoveUnit = jass.RemoveUnit
local SetPlayerAbilityAvailable = jass.SetPlayerAbilityAvailable
local UnitShareVision = jass.UnitShareVision
local IssueImmediateOrder = jass.IssueImmediateOrder
local Player = jass.Player
local PLAYER_NEUTRAL_AGGRESSIVE = jass.PLAYER_NEUTRAL_AGGRESSIVE
--- 结束翻滚：停止动作、恢复路径与动画倍速。
-- 二段可用性切换与 2 秒瞄准窗口在施法瞬间已同步开启（与源 JASS 一致）。
local function _____7ED3_675F_7FFB_6EDA(_____94C3_4ED9)
    if _____94C3_4ED9 == nil or _____94C3_4ED9 == 0 then
        return
    end
    IssueImmediateOrder(_____94C3_4ED9, "stop")
    SetUnitPathing(_____94C3_4ED9, true)
    _____64AD_653E_94C3_4ED9_914D_7F6E_52A8_4F5C(_____94C3_4ED9, -1, 1)
end
--- 翻滚推进：每 tick 沿施法方向移动 70 码，翻滚次数归零后停止
local function _____6267_884C_7FFB_6EDA(_____94C3_4ED9, _____65B9_5411_89D2, _____7FFB_6EDA_6B21_6570)
    if _____7FFB_6EDA_6B21_6570 <= 0 then
        _____7ED3_675F_7FFB_6EDA(_____94C3_4ED9)
        return
    end
    local _____6BCFtick_8DDD_79BB = cfg.R["翻滚每tick距离"]
    local _____5269_4F59_6B21_6570 = _____7FFB_6EDA_6B21_6570
    local _____56DE_8C03ID
    _____56DE_8C03ID = addPeriodicCallback(
        20,
        function()
            if _____94C3_4ED9 == nil or _____94C3_4ED9 == 0 then
                removePeriodicCallback(_____56DE_8C03ID)
                return
            end
            if jass.IsUnitPaused(_____94C3_4ED9) == true then
                return
            end
            if _____5269_4F59_6B21_6570 <= 0 or not _____5355_4F4D_5B58_6D3B(_____94C3_4ED9) then
                removePeriodicCallback(_____56DE_8C03ID)
                _____7ED3_675F_7FFB_6EDA(_____94C3_4ED9)
                return
            end
            local x = _____6781_5750_6807X(
                GetUnitX(_____94C3_4ED9),
                _____65B9_5411_89D2,
                _____6BCFtick_8DDD_79BB
            )
            local y = _____6781_5750_6807Y(
                GetUnitY(_____94C3_4ED9),
                _____65B9_5411_89D2,
                _____6BCFtick_8DDD_79BB
            )
            SetUnitPosition(_____94C3_4ED9, x, y)
            _____5269_4F59_6B21_6570 = _____5269_4F59_6B21_6570 - 1
        end
    )
end
--- 2 秒瞄准窗口超时：停止动作、恢复 A0GL 可用性；未使用二段则冷却恢复为 8 秒。
local function _____7784_51C6_7A97_53E3_8D85_65F6(_____94C3_4ED9, _____73A9_5BB6)
    if _____94C3_4ED9 ~= nil and _____94C3_4ED9 ~= 0 then
        IssueImmediateOrder(_____94C3_4ED9, "stop")
    end
    SetPlayerAbilityAvailable(_____73A9_5BB6, ____R_4E8C_6BB5_6280_80FDID_6570_503C, false)
    SetPlayerAbilityAvailable(_____73A9_5BB6, ____R_6280_80FDID_6570_503C, true)
    local _____4E8C_6BB5_5DF2_4F7F_7528 = _____94C3_4ED9 ~= nil and _____94C3_4ED9 ~= 0 and YDUserDataGetSafe("unit", _____94C3_4ED9, "二段使用", "boolean") == true
    if not _____4E8C_6BB5_5DF2_4F7F_7528 and _____94C3_4ED9 ~= nil and _____94C3_4ED9 ~= 0 then
        YDWESetUnitAbilityStateSafe(_____94C3_4ED9, ____R_6280_80FDID_6570_503C, _____6280_80FD_51B7_5374_72B6_6001, cfg.R["未发射冷却秒"])
    end
end
local function ____on_94C3_4ED9R_751F_6548(_____65BD_6CD5_5355_4F4D, _____6280_80FDID_6570_503C)
    if _____6280_80FDID_6570_503C ~= ____R_6280_80FDID_6570_503C then
        return
    end
    if not _____662F_94C3_4ED9_672C_4F53(_____65BD_6CD5_5355_4F4D) then
        return
    end
    local _____8D77_59CBX = GetUnitX(_____65BD_6CD5_5355_4F4D)
    local _____8D77_59CBY = GetUnitY(_____65BD_6CD5_5355_4F4D)
    local _____76EE_6807X = GetSpellTargetX()
    local _____76EE_6807Y = GetSpellTargetY()
    local _____65BD_6CD5_8DDD_79BB = _____8DDD_79BBXY(_____8D77_59CBX, _____8D77_59CBY, _____76EE_6807X, _____76EE_6807Y)
    local _____65B9_5411_89D2 = _____4E24_70B9_89D2_5EA6(_____8D77_59CBX, _____8D77_59CBY, _____76EE_6807X, _____76EE_6807Y)
    local _____7FFB_6EDA_8DDD_79BB_57FA_7840 = cfg.R["翻滚基础距离"] + _____8BFB_53D6_5355_4F4D_654F_6377(_____65BD_6CD5_5355_4F4D) * cfg.R["翻滚敏捷系数"]
    local _____7FFB_6EDA_8DDD_79BB = _____7FFB_6EDA_8DDD_79BB_57FA_7840 < _____65BD_6CD5_8DDD_79BB and _____7FFB_6EDA_8DDD_79BB_57FA_7840 or _____65BD_6CD5_8DDD_79BB
    local _____7FFB_6EDA_6B21_6570 = _____5411_4E0B_53D6_6574_6574_6570(_____7FFB_6EDA_8DDD_79BB / cfg.R["翻滚每tick距离"])
    local _____73A9_5BB6 = GetOwningPlayer(_____65BD_6CD5_5355_4F4D)
    SetUnitPathing(_____65BD_6CD5_5355_4F4D, false)
    _____64AD_653E_94C3_4ED9_914D_7F6E_52A8_4F5C(_____65BD_6CD5_5355_4F4D, -1, cfg.R["翻滚动画倍速"])
    SetPlayerAbilityAvailable(_____73A9_5BB6, ____R_4E8C_6BB5_6280_80FDID_6570_503C, true)
    SetPlayerAbilityAvailable(_____73A9_5BB6, ____R_6280_80FDID_6570_503C, false)
    _____6267_884C_7FFB_6EDA(_____65BD_6CD5_5355_4F4D, _____65B9_5411_89D2, _____7FFB_6EDA_6B21_6570)
    addDelayedCallback(
        _____79D2_8F6C_6BEB_79D2(cfg.R["瞄准窗口秒"]),
        function() return _____7784_51C6_7A97_53E3_8D85_65F6(_____65BD_6CD5_5355_4F4D, _____73A9_5BB6) end
    )
end
--- 弹幕路径伤害：140 码内敌对单位受 攻击力×1.5 魔法伤害（去重）
local function _____5904_7406_8DEF_5F84_4F24_5BB3(_____94C3_4ED9, _____5F39_5E55, _____91CD_590D_5355_4F4D_8868)
    local _____5355_4F4D_5217_8868 = getUnitsInRange(
        GetUnitX(_____5F39_5E55),
        GetUnitY(_____5F39_5E55),
        cfg.R["弹幕命中半径"]
    )
    do
        local i = 0
        while i < #_____5355_4F4D_5217_8868 do
            do
                local _____76EE_6807 = _____5355_4F4D_5217_8868[i + 1]
                if not _____662F_6709_6548_654C_5BF9_76EE_6807(_____94C3_4ED9, _____76EE_6807) then
                    goto __continue19
                end
                local id = GetHandleId(_____76EE_6807)
                if _____91CD_590D_5355_4F4D_8868[id] == true then
                    goto __continue19
                end
                _____91CD_590D_5355_4F4D_8868[id] = true
                _____9020_6210_6280_80FD_4F24_5BB3({
                    ["来源"] = _____94C3_4ED9,
                    ["目标"] = _____76EE_6807,
                    ["伤害"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____94C3_4ED9) * cfg.R["路径攻击倍率"],
                    ["伤害类型"] = DAMAGE_TYPE_MAGIC,
                    attack = true,
                    attackType = ATTACK_TYPE_NORMAL,
                    weaponType = WEAPON_TYPE_WHOKNOWS,
                    ["来源类型"] = "单位技能",
                    ["技能ID"] = ____R_6280_80FDID_6570_503C,
                    ["标签"] = "铃仙-R-丧心疮痍-路径",
                    ["伤害形态"] = "单体",
                    ["参与技能伤害加成"] = true
                })
            end
            ::__continue19::
            i = i + 1
        end
    end
end
--- 弹幕到达目标点：目标 400 码范围 攻击力×3.5 魔法伤害；200 码内眩晕 1 秒（attack=true 表达必定暴击）
local function _____7ED3_7B97_8303_56F4_4F24_5BB3(_____94C3_4ED9, _____76EE_6807X, _____76EE_6807Y, _____8DEF_5F84_4F24_5BB3, _____8303_56F4_4F24_5BB3, _____91CD_590D_5355_4F4D_8868)
    local _____5355_4F4D_5217_8868 = getUnitsInRange(_____76EE_6807X, _____76EE_6807Y, cfg.R["范围伤害半径"])
    do
        local i = 0
        while i < #_____5355_4F4D_5217_8868 do
            do
                local _____76EE_6807 = _____5355_4F4D_5217_8868[i + 1]
                if not _____662F_6709_6548_654C_5BF9_76EE_6807(_____94C3_4ED9, _____76EE_6807) then
                    goto __continue24
                end
                local id = GetHandleId(_____76EE_6807)
                local _____5DF2_53D7_8DEF_5F84_4F24_5BB3 = _____91CD_590D_5355_4F4D_8868[id] == true
                local _____4F24_5BB3 = _____5DF2_53D7_8DEF_5F84_4F24_5BB3 and _____8303_56F4_4F24_5BB3 - _____8DEF_5F84_4F24_5BB3 or _____8303_56F4_4F24_5BB3
                if not (_____4F24_5BB3 > 0) then
                    goto __continue24
                end
                if _____8DDD_79BBXY(
                    GetUnitX(_____76EE_6807),
                    GetUnitY(_____76EE_6807),
                    _____76EE_6807X,
                    _____76EE_6807Y
                ) <= cfg.R["暴击半径"] then
                    _____65BD_52A0_7729_6655(
                        _____94C3_4ED9,
                        _____76EE_6807,
                        cfg.R["眩晕秒"],
                        _____94C3_4ED9BuffID["R眩晕"],
                        "技能"
                    )
                end
                _____9020_6210_6280_80FD_4F24_5BB3({
                    ["来源"] = _____94C3_4ED9,
                    ["目标"] = _____76EE_6807,
                    ["伤害"] = _____4F24_5BB3,
                    ["伤害类型"] = DAMAGE_TYPE_MAGIC,
                    attack = true,
                    attackType = ATTACK_TYPE_NORMAL,
                    weaponType = WEAPON_TYPE_WHOKNOWS,
                    ["来源类型"] = "单位技能",
                    ["技能ID"] = ____R_6280_80FDID_6570_503C,
                    ["标签"] = "铃仙-R-丧心疮痍-范围",
                    ["伤害形态"] = "AOE",
                    ["参与技能伤害加成"] = true
                })
            end
            ::__continue24::
            i = i + 1
        end
    end
end
--- 发射 e07Q 弹幕并推进至目标点 200 码内（无最大距离限制）
local function _____5F00_59CB_53D1_5C04_5F39_5E55(_____94C3_4ED9, _____73A9_5BB6, _____65B9_5411_89D2, _____76EE_6807X, _____76EE_6807Y, _____51C6_5FC3)
    if _____94C3_4ED9 == nil or _____94C3_4ED9 == 0 or not _____5355_4F4D_5B58_6D3B(_____94C3_4ED9) then
        if _____51C6_5FC3 ~= nil and _____51C6_5FC3 ~= 0 then
            RemoveUnit(_____51C6_5FC3)
        end
        return
    end
    local _____5F39_5E55_8D77_70B9X = GetUnitX(_____94C3_4ED9)
    local _____5F39_5E55_8D77_70B9Y = GetUnitY(_____94C3_4ED9)
    local _____5F39_5E55 = CreateUnit(
        _____73A9_5BB6,
        _____5F39_5E55_9A6C_7532ID,
        _____5F39_5E55_8D77_70B9X,
        _____5F39_5E55_8D77_70B9Y,
        _____65B9_5411_89D2
    )
    if _____5F39_5E55 == nil or _____5F39_5E55 == 0 then
        if _____51C6_5FC3 ~= nil and _____51C6_5FC3 ~= 0 then
            RemoveUnit(_____51C6_5FC3)
        end
        return
    end
    SetUnitScale(_____5F39_5E55, cfg.R["弹幕缩放"], cfg.R["弹幕缩放"], cfg.R["弹幕缩放"])
    SetUnitFlyHeight(_____5F39_5E55, cfg.R["弹幕高度"], 0)
    local _____8DEF_5F84_4F24_5BB3 = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____94C3_4ED9) * cfg.R["路径攻击倍率"]
    local _____8303_56F4_4F24_5BB3 = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____94C3_4ED9) * cfg.R["范围攻击倍率"]
    local _____91CD_590D_5355_4F4D_8868 = {}
    local _____5F39_5E55X = _____5F39_5E55_8D77_70B9X
    local _____5F39_5E55Y = _____5F39_5E55_8D77_70B9Y
    local _____5DF2_5B8C_6210 = false
    local _____56DE_8C03ID
    _____56DE_8C03ID = addPeriodicCallback(
        20,
        function()
            if _____5DF2_5B8C_6210 then
                removePeriodicCallback(_____56DE_8C03ID)
                return
            end
            if _____5F39_5E55 == nil or _____5F39_5E55 == 0 or not _____5355_4F4D_5B58_6D3B(_____5F39_5E55) then
                _____5DF2_5B8C_6210 = true
                removePeriodicCallback(_____56DE_8C03ID)
                if _____51C6_5FC3 ~= nil and _____51C6_5FC3 ~= 0 then
                    RemoveUnit(_____51C6_5FC3)
                end
                return
            end
            _____5F39_5E55X = _____5F39_5E55X + _____6781_5750_6807X(0, _____65B9_5411_89D2, cfg.R["弹幕每tick距离"])
            _____5F39_5E55Y = _____5F39_5E55Y + _____6781_5750_6807Y(0, _____65B9_5411_89D2, cfg.R["弹幕每tick距离"])
            SetUnitPosition(_____5F39_5E55, _____5F39_5E55X, _____5F39_5E55Y)
            _____5904_7406_8DEF_5F84_4F24_5BB3(_____94C3_4ED9, _____5F39_5E55, _____91CD_590D_5355_4F4D_8868)
            if _____8DDD_79BBXY(_____5F39_5E55X, _____5F39_5E55Y, _____76EE_6807X, _____76EE_6807Y) <= cfg.R["暴击半径"] then
                _____7ED3_7B97_8303_56F4_4F24_5BB3(
                    _____94C3_4ED9,
                    _____76EE_6807X,
                    _____76EE_6807Y,
                    _____8DEF_5F84_4F24_5BB3,
                    _____8303_56F4_4F24_5BB3,
                    _____91CD_590D_5355_4F4D_8868
                )
                _____521B_5EFA_70B9_7279_6548({["模型路径"] = cfg.R["爆炸特效1"], X = _____76EE_6807X, Y = _____76EE_6807Y, ["持续秒"] = cfg.R["爆炸特效持续秒"]})
                _____521B_5EFA_70B9_7279_6548({["模型路径"] = cfg.R["爆炸特效2"], X = _____76EE_6807X, Y = _____76EE_6807Y, ["持续秒"] = cfg.R["爆炸特效持续秒"]})
                if _____51C6_5FC3 ~= nil and _____51C6_5FC3 ~= 0 then
                    RemoveUnit(_____51C6_5FC3)
                end
                RemoveUnit(_____5F39_5E55)
                _____5DF2_5B8C_6210 = true
                removePeriodicCallback(_____56DE_8C03ID)
            end
        end
    )
end
local function ____on_94C3_4ED9R_4E8C_6BB5_751F_6548(_____65BD_6CD5_5355_4F4D, _____6280_80FDID_6570_503C)
    if _____6280_80FDID_6570_503C ~= ____R_4E8C_6BB5_6280_80FDID_6570_503C then
        return
    end
    if not _____662F_94C3_4ED9_672C_4F53(_____65BD_6CD5_5355_4F4D) then
        return
    end
    local _____94C3_4ED9X = GetUnitX(_____65BD_6CD5_5355_4F4D)
    local _____94C3_4ED9Y = GetUnitY(_____65BD_6CD5_5355_4F4D)
    local _____76EE_6807X = GetSpellTargetX()
    local _____76EE_6807Y = GetSpellTargetY()
    local _____8DDD_79BB = _____8DDD_79BBXY(_____94C3_4ED9X, _____94C3_4ED9Y, _____76EE_6807X, _____76EE_6807Y)
    if _____8DDD_79BB <= cfg.R["最小施法距离"] then
        YDWESetUnitAbilityStateSafe(_____65BD_6CD5_5355_4F4D, ____R_6280_80FDID_6570_503C, _____6280_80FD_51B7_5374_72B6_6001, 0)
        return
    end
    local _____73A9_5BB6 = GetOwningPlayer(_____65BD_6CD5_5355_4F4D)
    local _____65B9_5411_89D2 = _____4E24_70B9_89D2_5EA6(_____94C3_4ED9X, _____94C3_4ED9Y, _____76EE_6807X, _____76EE_6807Y)
    YDUserDataSetSafe(
        "unit",
        _____65BD_6CD5_5355_4F4D,
        "二段使用",
        "boolean",
        true
    )
    addDelayedCallback(
        35000,
        function()
            YDUserDataSetSafe(
                "unit",
                _____65BD_6CD5_5355_4F4D,
                "二段使用",
                "boolean",
                false
            )
        end
    )
    _____64AD_653E_94C3_4ED9_5355_4F4D_7ED1_5B9A_97F3_6548(_____65BD_6CD5_5355_4F4D, "gg_snd_LX_R", 100)
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = cfg.R["蓄力特效模型"],
        X = _____94C3_4ED9X,
        Y = _____94C3_4ED9Y,
        ["动画速度"] = cfg.R["蓄力特效速度"],
        ["持续秒"] = cfg.R["蓄力特效持续秒"]
    })
    SetUnitAnimation(_____65BD_6CD5_5355_4F4D, "spell one")
    UnitShareVision(
        _____65BD_6CD5_5355_4F4D,
        Player(PLAYER_NEUTRAL_AGGRESSIVE),
        true
    )
    local _____51C6_5FC3 = CreateUnit(
        _____73A9_5BB6,
        _____51C6_5FC3_9A6C_7532ID,
        _____76EE_6807X,
        _____76EE_6807Y,
        0
    )
    addDelayedCallback(
        _____79D2_8F6C_6BEB_79D2(cfg.R["蓄力秒"]),
        function()
            UnitShareVision(
                _____65BD_6CD5_5355_4F4D,
                Player(PLAYER_NEUTRAL_AGGRESSIVE),
                false
            )
            _____64AD_653E_94C3_4ED9_914D_7F6E_52A8_4F5C(_____65BD_6CD5_5355_4F4D, -1, 1)
            _____5F00_59CB_53D1_5C04_5F39_5E55(
                _____65BD_6CD5_5355_4F4D,
                _____73A9_5BB6,
                _____65B9_5411_89D2,
                _____76EE_6807X,
                _____76EE_6807Y,
                _____51C6_5FC3
            )
        end
    )
end
registerSpellEffectListener(____on_94C3_4ED9R_751F_6548)
registerSpellEffectListener(____on_94C3_4ED9R_4E8C_6BB5_751F_6548)
return ____exports
