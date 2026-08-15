--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.03．阿伦劳特.00．配置")
local _____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["阿伦劳特单位技能配置"]
local ____00B_FF0E_5F62_6001_4E0E_72B6_6001_7BA1_7406 = require("系统.03．技能系统.05．单位技能.04．英雄技能.03．阿伦劳特.00B．形态与状态管理")
local _____662F_963F_4F26_52B3_7279_82F1_96C4 = ____00B_FF0E_5F62_6001_4E0E_72B6_6001_7BA1_7406["是阿伦劳特英雄"]
local _____662F_5149_5F62_6001 = ____00B_FF0E_5F62_6001_4E0E_72B6_6001_7BA1_7406["是光形态"]
local _____662F_6697_5F62_6001 = ____00B_FF0E_5F62_6001_4E0E_72B6_6001_7BA1_7406["是暗形态"]
local _____662F_6709_6548_76EE_6807 = ____00B_FF0E_5F62_6001_4E0E_72B6_6001_7BA1_7406["是有效目标"]
local _____62E5_6709_88C1_51B3_5BA1_5224 = ____00B_FF0E_5F62_6001_4E0E_72B6_6001_7BA1_7406["拥有裁决审判"]
local _____6DFB_52A0_539F_751FBuff_6301_7EED = ____00B_FF0E_5F62_6001_4E0E_72B6_6001_7BA1_7406["添加原生Buff持续"]
local _____4E24_70B9_89D2_5EA6 = ____00B_FF0E_5F62_6001_4E0E_72B6_6001_7BA1_7406["两点角度"]
local _____4E24_70B9_8DDD_79BB = ____00B_FF0E_5F62_6001_4E0E_72B6_6001_7BA1_7406["两点距离"]
local ____13_FF0E_963F_4F26_52B3_7279 = require("系统.05．Buff系统.03．Buff表.02．英雄.13．阿伦劳特")
local _____963F_4F26_52B3_7279BuffID = ____13_FF0E_963F_4F26_52B3_7279["阿伦劳特BuffID"]
local ____require_result_0 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_0.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_0["移除单位指定Buff"]
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
local ____require_result_2 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_2.registerSpellEffectListener
local ____require_result_3 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_3.addDelayedCallback
local addPeriodicCallback = ____require_result_3.addPeriodicCallback
local removePeriodicCallback = ____require_result_3.removePeriodicCallback
local ____require_result_4 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_6280_80FD_4F24_5BB3 = ____require_result_4["造成技能伤害"]
local ____require_result_5 = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
local doHeal = ____require_result_5.doHeal
local ____require_result_6 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境")
local _____65BD_52A0_7729_6655 = ____require_result_6["施加眩晕"]
local ____require_result_7 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.16．属性位移与指令")
local _____4E34_65F6_8C03_6574_653B_51FB = ____require_result_7["临时调整攻击"]
local ____require_result_8 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getUnitsInRange = ____require_result_8.getUnitsInRange
local ____require_result_9 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_9["读取单位攻击力"]
local _____5355_4F4D_5B58_6D3B = ____require_result_9["单位存活"]
local ____require_result_10 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_10["创建点特效"]
local _____9500_6BC1_70B9_7279_6548 = ____require_result_10["销毁点特效"]
local createTimedUnitEffect = ____require_result_10.createTimedUnitEffect
local ____Q_6280_80FDID = stringToFourCCSafe(_____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E["Q技能ID"])
local _____88C1_51B3_5236_88C1BuffID = stringToFourCCSafe(_____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E["裁决制裁BuffID"])
local DAMAGE_TYPE_DIVINE = jass.DAMAGE_TYPE_DIVINE
local DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local PLAYER_NEUTRAL_PASSIVE = jass.PLAYER_NEUTRAL_PASSIVE
local GetSpellTargetUnit = jass.GetSpellTargetUnit
local GetSpellTargetX = jass.GetSpellTargetX
local GetSpellTargetY = jass.GetSpellTargetY
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFlyHeight = jass.GetUnitFlyHeight
local GetOwningPlayer = jass.GetOwningPlayer
local GetUnitState = jass.GetUnitState
local SetUnitState = jass.SetUnitState
local IsUnitEnemy = jass.IsUnitEnemy
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MANA = jass.UNIT_STATE_MANA
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA
local EXSetEffectXY = japi.EXSetEffectXY
local _____89D2_5EA6_8F6C_5F27_5EA6 = math.pi / 180
local function _____5149_5F62_6001Q(_____65BD_6CD5_8005, _____76EE_6807_5355_4F4D, _____76EE_6807X, _____76EE_6807Y)
    local cfg = _____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E.Q
    local _____65BD_6CD5_8005_73A9_5BB6 = GetOwningPlayer(_____65BD_6CD5_8005)
    local _____653B_51FB_529B = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005)
    local _____4F24_5BB3_91CF = _____653B_51FB_529B * cfg["光倍率"]
    local _____5355_4F4D_5217_8868 = getUnitsInRange(_____76EE_6807X, _____76EE_6807Y, cfg["范围"])
    do
        local i = 0
        while i < #_____5355_4F4D_5217_8868 do
            do
                local _____76EE_6807 = _____5355_4F4D_5217_8868[i + 1]
                if not _____662F_6709_6548_76EE_6807(_____76EE_6807) then
                    goto __continue4
                end
                if IsUnitEnemy(_____76EE_6807, _____65BD_6CD5_8005_73A9_5BB6) == true then
                    _____9020_6210_6280_80FD_4F24_5BB3({
                        ["来源"] = _____65BD_6CD5_8005,
                        ["目标"] = _____76EE_6807,
                        ["伤害"] = _____4F24_5BB3_91CF,
                        ["伤害类型"] = DAMAGE_TYPE_DIVINE,
                        attack = false,
                        attackType = ATTACK_TYPE_NORMAL,
                        weaponType = WEAPON_TYPE_WHOKNOWS,
                        ["来源类型"] = "单位技能",
                        ["技能ID"] = ____Q_6280_80FDID,
                        ["标签"] = "阿伦劳特-Q-神圣之光",
                        ["伤害形态"] = "AOE",
                        ["参与技能伤害加成"] = true
                    })
                    createTimedUnitEffect(_____76EE_6807, "overhead", cfg["光敌人特效"], cfg["光敌人特效持续秒"])
                    if _____76EE_6807 == _____76EE_6807_5355_4F4D then
                        _____65BD_52A0_7729_6655(
                            _____65BD_6CD5_8005,
                            _____76EE_6807,
                            cfg["光主目标眩晕秒"],
                            "阿伦劳特-Q-神圣之光",
                            "技能"
                        )
                    end
                else
                    local _____6CBB_7597_503C = _____4F24_5BB3_91CF
                    if _____76EE_6807 == _____76EE_6807_5355_4F4D then
                        _____6CBB_7597_503C = _____6CBB_7597_503C * cfg["光主目标治疗倍率"]
                    end
                    doHeal({
                        HealSource = _____65BD_6CD5_8005,
                        HealTarget = _____76EE_6807,
                        HealAmount = _____6CBB_7597_503C,
                        ItemHeal = false,
                        HealEffect = true
                    })
                end
            end
            ::__continue4::
            i = i + 1
        end
    end
end
--- 弹道命中后按 1:2 恢复施法者生命/魔法
local function _____7ED3_7B97_6697_62BD_53D6_6062_590D(_____65BD_6CD5_8005, _____62BD_53D6_503CHP, _____62BD_53D6_503CMP)
    local cfg = _____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E.Q
    if _____65BD_6CD5_8005 == nil or _____65BD_6CD5_8005 == 0 or not _____5355_4F4D_5B58_6D3B(_____65BD_6CD5_8005) then
        return
    end
    doHeal({
        HealSource = _____65BD_6CD5_8005,
        HealTarget = _____65BD_6CD5_8005,
        HealAmount = _____62BD_53D6_503CHP * cfg["抽取恢复倍率"],
        HealManaAmount = _____62BD_53D6_503CMP * cfg["抽取恢复倍率"],
        ItemHeal = false,
        HealEffect = true,
        ManaEffect = true
    })
end
--- 暗形态抽取弹道：AnnihilationMissile.mdl 从目标点飞向施法者。
-- 每 0.02 秒移动 20 码，最多 80 次；到达施法者后销毁并结算恢复，超时只销毁特效。
local function _____5F00_59CB_6697_62BD_53D6(_____65BD_6CD5_8005, _____76EE_6807_5355_4F4D, _____76EE_6807X, _____76EE_6807Y)
    local cfg = _____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E.Q
    if not _____5355_4F4D_5B58_6D3B(_____76EE_6807_5355_4F4D) then
        return
    end
    local _____62BD_53D6_503CHP = GetUnitState(_____76EE_6807_5355_4F4D, UNIT_STATE_MAX_LIFE) * cfg["抽取最大生命比例"]
    local _____62BD_53D6_503CMP = GetUnitState(_____76EE_6807_5355_4F4D, UNIT_STATE_MAX_MANA) * cfg["抽取最大魔法比例"]
    SetUnitState(
        _____76EE_6807_5355_4F4D,
        UNIT_STATE_LIFE,
        GetUnitState(_____76EE_6807_5355_4F4D, UNIT_STATE_LIFE) - _____62BD_53D6_503CHP
    )
    SetUnitState(
        _____76EE_6807_5355_4F4D,
        UNIT_STATE_MANA,
        GetUnitState(_____76EE_6807_5355_4F4D, UNIT_STATE_MANA) - _____62BD_53D6_503CMP
    )
    local _____5F39_9053_7279_6548 = _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = cfg["暗抽取弹道特效"],
        X = _____76EE_6807X,
        Y = _____76EE_6807Y,
        Z = GetUnitFlyHeight(_____76EE_6807_5355_4F4D) + cfg["暗抽取弹道高度偏移"],
        ["缩放"] = cfg["暗抽取弹道缩放"]
    })
    if _____5F39_9053_7279_6548 == nil or _____5F39_9053_7279_6548 == 0 then
        _____7ED3_7B97_6697_62BD_53D6_6062_590D(_____65BD_6CD5_8005, _____62BD_53D6_503CHP, _____62BD_53D6_503CMP)
        return
    end
    local _____4E0A_4E0B_6587 = {
        ["施法者"] = _____65BD_6CD5_8005,
        ["弹道特效"] = _____5F39_9053_7279_6548,
        ["当前X"] = _____76EE_6807X,
        ["当前Y"] = _____76EE_6807Y,
        ["抽取值HP"] = _____62BD_53D6_503CHP,
        ["抽取值MP"] = _____62BD_53D6_503CMP,
        ["剩余tick"] = cfg["暗抽取弹道最大tick"],
        ["回调ID"] = 0
    }
    _____4E0A_4E0B_6587["回调ID"] = addPeriodicCallback(
        20,
        function()
            local ctx = _____4E0A_4E0B_6587
            if ctx["剩余tick"] <= 0 or ctx["施法者"] == nil or ctx["施法者"] == 0 then
                removePeriodicCallback(ctx["回调ID"])
                _____9500_6BC1_70B9_7279_6548(ctx["弹道特效"])
                return
            end
            ctx["剩余tick"] = ctx["剩余tick"] - 1
            local _____65BD_6CD5_8005X = GetUnitX(ctx["施法者"])
            local _____65BD_6CD5_8005Y = GetUnitY(ctx["施法者"])
            if _____4E24_70B9_8DDD_79BB(ctx["当前X"], ctx["当前Y"], _____65BD_6CD5_8005X, _____65BD_6CD5_8005Y) <= 25 then
                removePeriodicCallback(ctx["回调ID"])
                _____9500_6BC1_70B9_7279_6548(ctx["弹道特效"])
                _____7ED3_7B97_6697_62BD_53D6_6062_590D(ctx["施法者"], ctx["抽取值HP"], ctx["抽取值MP"])
                return
            end
            local _____89D2_5EA6 = _____4E24_70B9_89D2_5EA6(ctx["当前X"], ctx["当前Y"], _____65BD_6CD5_8005X, _____65BD_6CD5_8005Y)
            ctx["当前X"] = ctx["当前X"] + math.cos(_____89D2_5EA6 * _____89D2_5EA6_8F6C_5F27_5EA6) * cfg["暗抽取弹道每tick距离"]
            ctx["当前Y"] = ctx["当前Y"] + math.sin(_____89D2_5EA6 * _____89D2_5EA6_8F6C_5F27_5EA6) * cfg["暗抽取弹道每tick距离"]
            if EXSetEffectXY ~= nil then
                EXSetEffectXY(ctx["弹道特效"], ctx["当前X"], ctx["当前Y"])
            end
        end
    )
end
local function _____6697_5F62_6001Q(_____65BD_6CD5_8005, _____76EE_6807_5355_4F4D, _____76EE_6807X, _____76EE_6807Y)
    local cfg = _____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E.Q
    local _____65BD_6CD5_8005_73A9_5BB6 = GetOwningPlayer(_____65BD_6CD5_8005)
    local _____653B_51FB_529B = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005)
    local _____4F24_5BB3_91CF = _____653B_51FB_529B * cfg["暗倍率"]
    local _____88C1_51B3_5BA1_5224_6FC0_6D3B = _____62E5_6709_88C1_51B3_5BA1_5224(_____65BD_6CD5_8005)
    local _____5355_4F4D_5217_8868 = getUnitsInRange(_____76EE_6807X, _____76EE_6807Y, cfg["范围"])
    do
        local i = 0
        while i < #_____5355_4F4D_5217_8868 do
            do
                local _____76EE_6807 = _____5355_4F4D_5217_8868[i + 1]
                if not _____662F_6709_6548_76EE_6807(_____76EE_6807) then
                    goto __continue21
                end
                if IsUnitEnemy(_____76EE_6807, _____65BD_6CD5_8005_73A9_5BB6) == true then
                    local _____4F24_5BB3 = _____4F24_5BB3_91CF
                    if _____76EE_6807 == _____76EE_6807_5355_4F4D then
                        _____4F24_5BB3 = _____4F24_5BB3 * cfg["暗主目标倍率"]
                        if _____88C1_51B3_5BA1_5224_6FC0_6D3B then
                            _____4F24_5BB3 = _____4F24_5BB3 + GetUnitState(_____65BD_6CD5_8005, UNIT_STATE_MAX_LIFE) * cfg["裁决审判额外生命比例"]
                        end
                    end
                    _____9020_6210_6280_80FD_4F24_5BB3({
                        ["来源"] = _____65BD_6CD5_8005,
                        ["目标"] = _____76EE_6807,
                        ["伤害"] = _____4F24_5BB3,
                        ["伤害类型"] = DAMAGE_TYPE_SHADOW_STRIKE,
                        attack = false,
                        attackType = ATTACK_TYPE_NORMAL,
                        weaponType = WEAPON_TYPE_WHOKNOWS,
                        ["来源类型"] = "单位技能",
                        ["技能ID"] = ____Q_6280_80FDID,
                        ["标签"] = "阿伦劳特-Q-裁决制裁",
                        ["伤害形态"] = "AOE",
                        ["参与技能伤害加成"] = true
                    })
                    createTimedUnitEffect(_____76EE_6807, "origin", cfg["暗敌人特效"], cfg["暗敌人特效持续秒"])
                else
                    local _____52A0_653B_503C = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____76EE_6807) * cfg["暗友军加攻比例"]
                    if _____52A0_653B_503C > 0 then
                        _____4E34_65F6_8C03_6574_653B_51FB(_____76EE_6807, _____52A0_653B_503C)
                        registerManualBuff(_____76EE_6807, _____963F_4F26_52B3_7279BuffID["裁决制裁"], cfg["暗友军加攻持续秒"], _____52A0_653B_503C)
                        addDelayedCallback(
                            math.floor(cfg["暗友军加攻持续秒"] * 1000 + 0.5),
                            function()
                                if _____76EE_6807 == nil or _____76EE_6807 == 0 then
                                    return
                                end
                                _____4E34_65F6_8C03_6574_653B_51FB(_____76EE_6807, -_____52A0_653B_503C)
                                _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____76EE_6807, _____963F_4F26_52B3_7279BuffID["裁决制裁"])
                            end
                        )
                    end
                    _____6DFB_52A0_539F_751FBuff_6301_7EED(_____76EE_6807, _____88C1_51B3_5236_88C1BuffID, cfg["暗友军加攻持续秒"])
                    createTimedUnitEffect(_____76EE_6807, "origin", cfg["暗友军加攻特效"], cfg["暗友军加攻特效持续秒"])
                    if _____76EE_6807 == _____76EE_6807_5355_4F4D and _____76EE_6807 ~= _____65BD_6CD5_8005 and GetOwningPlayer(_____76EE_6807) ~= PLAYER_NEUTRAL_PASSIVE then
                        _____5F00_59CB_6697_62BD_53D6(_____65BD_6CD5_8005, _____76EE_6807, _____76EE_6807X, _____76EE_6807Y)
                    end
                end
            end
            ::__continue21::
            i = i + 1
        end
    end
end
local function ____on_963F_4F26_52B3_7279Q(_____65BD_6CD5_8005, _____6280_80FDID_6570_503C)
    if _____6280_80FDID_6570_503C ~= ____Q_6280_80FDID then
        return
    end
    if not _____662F_963F_4F26_52B3_7279_82F1_96C4(_____65BD_6CD5_8005) then
        return
    end
    local _____76EE_6807_5355_4F4D = GetSpellTargetUnit()
    local _____76EE_6807X = GetSpellTargetX()
    local _____76EE_6807Y = GetSpellTargetY()
    if _____662F_5149_5F62_6001(_____65BD_6CD5_8005) then
        _____5149_5F62_6001Q(_____65BD_6CD5_8005, _____76EE_6807_5355_4F4D, _____76EE_6807X, _____76EE_6807Y)
    elseif _____662F_6697_5F62_6001(_____65BD_6CD5_8005) then
        _____6697_5F62_6001Q(_____65BD_6CD5_8005, _____76EE_6807_5355_4F4D, _____76EE_6807X, _____76EE_6807Y)
    end
end
registerSpellEffectListener(____on_963F_4F26_52B3_7279Q)
return ____exports
